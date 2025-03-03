package com.mendix.nativetemplate;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.util.Consumer;

import com.google.zxing.Result;
import com.mendix.mendixnative.activity.MendixReactActivity;
import com.mendix.mendixnative.config.AppPreferences;
import com.mendix.mendixnative.config.AppUrl;
import com.mendix.mendixnative.react.MendixApp;
import com.mendix.mendixnative.react.MxConfiguration;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URL;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import me.dm7.barcodescanner.zxing.ZXingScannerView;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class MainActivity extends AppCompatActivity implements ZXingScannerView.ResultHandler {
    static private final int CAMERA_REQUEST = 1;
    private final Executor httpExecutor = Executors.newSingleThreadExecutor();
    private ZXingScannerView cameraView;
    private AppPreferences appPreferences;
    private Button launchAppButton;
    private CheckBox devModeCheckBox;
    private CheckBox clearDataCheckBox;
    private EditText appUrl;
    private View loaderView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_dev);

        appPreferences = new AppPreferences(this);

        appUrl = findViewById(R.id.app_url_input_field);
        launchAppButton = findViewById(R.id.launch_app_button);
        devModeCheckBox = findViewById(R.id.checkbox_dev_mode);
        clearDataCheckBox = findViewById(R.id.checkbox_clear_data);
        loaderView = findViewById(R.id.loader);

        ViewGroup cameraContainer = findViewById(R.id.barcode_scanner_container);
        cameraView = new ZXingScannerView(this);
        cameraContainer.addView(cameraView);

        attachListeners();

        appUrl.setText(appPreferences.getAppUrl());
        devModeCheckBox.setChecked(appPreferences.isDevModeEnabled());

        cameraView.setResultHandler(this);
        startCameraWithPermissions();

        handleLaunchWithData(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleLaunchWithData(intent);
    }

    private void handleLaunchWithData(Intent intent) {
        try {
            // These lines introduce a way to bypass the initial screen containing the app url.
            // In order to use it you need to launch detox with an extra launchArgs
            // detox.launchApp({ launchArgs: { appUrl: "http://localhost:8080" }});
            Bundle bundleExtra = intent.getBundleExtra("launchArgs");
            String appUrl = bundleExtra.getString("appUrl");
            launchApp(appUrl, intent);
            return;
        } catch (Exception e) {}

        if (intent.getData() != null) {
            launchApp(appPreferences.getAppUrl(), intent);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onResume() {
        super.onResume();
        try {
            cameraView.startCamera();
        } catch (Exception e) {
            // No permissions
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        cameraView.stopCamera();
    }

    @Override
    public void handleResult(Result rawResult) {
        try {
            String url = rawResult.getText();
            launchApp(url, null);
        } catch (Exception e) {
            Toast.makeText(MainActivity.this, R.string.qr_code_invalid, Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == CAMERA_REQUEST) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                cameraView.startCamera();
            }
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    private void attachListeners() {
        loaderView.setOnTouchListener((view, event) -> true);

        appUrl.setOnEditorActionListener((view, actionId, keyEvent) -> {
            launchApp(appUrl.getText().toString(), null);
            return false;
        });

        launchAppButton.setOnClickListener((view) -> launchApp(appUrl.getText().toString(), null));
    }

    private void isPackagerRunning(String appUrl, Consumer<Boolean> result) {
        httpExecutor.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    URL runtimeUrl = new URL(AppUrl.forRuntime(appUrl));
                    OkHttpClient client = new OkHttpClient.Builder().connectTimeout(4, TimeUnit.SECONDS).callTimeout(4, TimeUnit.SECONDS).build();
                    URL statusUrl = new URL(runtimeUrl.getProtocol(), runtimeUrl.getHost(), appPreferences.getPackagerPort(), "status");
                    Response response = client.newCall(new Request.Builder().url(statusUrl).get().build()).execute();
                    if (!response.isSuccessful()) {
                        showPackagerErrorToast();
                    }
                    resultInMainThread(response.isSuccessful());
                } catch (Exception e) {
                    showPackagerErrorToast();
                    resultInMainThread(false);
                }
            }

            void resultInMainThread(boolean success) {
                MainActivity.this.runOnUiThread(() -> result.accept(success));
            }

            void showPackagerErrorToast() {
                MainActivity.this.runOnUiThread(() -> Toast.makeText(MainActivity.this, R.string.packager_connection_timeout, Toast.LENGTH_LONG).show());
            }
        });
    }

    private void disableUIInteraction(boolean disable) {
        loaderView.setVisibility(disable ? View.VISIBLE : View.GONE);
        if (!disable) {
            cameraView.resumeCameraPreview(this);
        }
    }

    private void startCameraWithPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA)) {
                new AlertDialog.Builder(this)
                        .setTitle(getString(R.string.camera_permission_title))
                        .setMessage(getString(R.string.camera_permission_message))
                        .setNeutralButton(R.string.camera_permission_button, (view, which) -> ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, CAMERA_REQUEST)).create().show();
            } else {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, CAMERA_REQUEST);
            }
        } else {
            cameraView.startCamera();
        }
    }

    private void launchApp(String url, Intent passedIntent) {
        disableUIInteraction(true);
        isPackagerRunning(url, (res) -> {
            if (!res) {
                disableUIInteraction(false);
                return;
            }
            boolean clearData = clearDataCheckBox.isChecked();
            boolean devModeEnabled = devModeCheckBox.isChecked();
            String runtimeUrl = AppUrl.forRuntime(url);

            appPreferences.setAppUrl(AppUrl.forRuntime(runtimeUrl));

            Intent intent = new Intent(this, MendixReactActivity.class);
            MxConfiguration.WarningsFilter warningsFilter = devModeEnabled ? MxConfiguration.WarningsFilter.partial : MxConfiguration.WarningsFilter.none;
            MendixApp mendixApp = new MendixApp(runtimeUrl, warningsFilter, devModeEnabled, true);
            intent.putExtra(MendixReactActivity.MENDIX_APP_INTENT_KEY, mendixApp);
            intent.putExtra(MendixReactActivity.CLEAR_DATA, clearData);
            if (passedIntent != null) {
                intent.setData(passedIntent.getData());
                intent.setAction(passedIntent.getAction());
            }

            startActivity(intent);
            disableUIInteraction(false);
        });
    }
}
