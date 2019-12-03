package com.mendix.nativeteamplate.developerapp;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.zxing.Result;
import com.mendix.mendixnative.activity.MendixReactActivity;
import com.mendix.mendixnative.config.AppUrl;
import com.mendix.mendixnative.react.MendixApp;
import com.mendix.mendixnative.react.MxConfiguration;
import com.mendix.nativetemplate.R;

import org.json.JSONException;
import org.json.JSONObject;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

public class DevMenuActivity extends AppCompatActivity implements ZXingScannerView.ResultHandler {
    static private int CAMERA_REQUEST = 1;
    private Button launchAppButton;
    private CheckBox clearDataCheckBox;
    private EditText appUrl;
    private ZXingScannerView cameraView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_dev);

        appUrl = findViewById(R.id.app_url_input_field);
        launchAppButton = findViewById(R.id.launch_app_button);
        clearDataCheckBox = findViewById(R.id.checkbox_clear_data);

        ViewGroup cameraContainer = findViewById(R.id.barcode_scanner_container);
        cameraView = new ZXingScannerView(this);
        cameraContainer.addView(cameraView);

        launchAppButton.setOnClickListener((view) -> {
            String url = appUrl.getText().toString();
            launchApp(url);
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onResume() {
        super.onResume();
        cameraView.setResultHandler(this);
        startCameraWithPermissions();
    }

    @Override
    protected void onPause() {
        super.onPause();
        cameraView.stopCamera();
    }

    @Override
    public void handleResult(Result rawResult) {
        try {
            JSONObject res = new JSONObject(rawResult.getText());
            String url = res.getString("url");
            launchApp(url);
        } catch (JSONException e) {
            e.printStackTrace();
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

    private void startCameraWithPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA)) {
                new AlertDialog.Builder(this)
                        .setTitle(getString(R.string.camera_permission_title))
                        .setMessage(getString(R.string.camera_permission_message))
                        .setNeutralButton(R.string.camera_permission_button, (view, which) -> {
                            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, CAMERA_REQUEST);
                        }).create().show();
            } else {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, CAMERA_REQUEST);
            }
        } else {
            cameraView.startCamera();
        }
    }

    private void launchApp(String url) {
        boolean clearData = clearDataCheckBox.isChecked();
        Intent intent = new Intent(this, MendixReactActivity.class);
        MendixApp mendixApp = new MendixApp(AppUrl.forRuntime(url), MxConfiguration.WarningsFilter.all, true);
        intent.putExtra(MendixReactActivity.MENDIX_APP_INTENT_KEY, mendixApp);
        intent.putExtra(MendixReactActivity.CLEAR_DATA, clearData);
        startActivity(intent);
    }
}
