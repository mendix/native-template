package com.mendix.nativeteamplate.developerapp;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.mendix.mendixnative.activity.MendixReactActivity;
import com.mendix.mendixnative.config.AppUrl;
import com.mendix.mendixnative.react.MendixApp;
import com.mendix.mendixnative.react.MxConfiguration;
import com.mendix.nativetemplate.R;

public class DevMenuActivity extends AppCompatActivity {
    Button launchAppButton;
    CheckBox clearDataCheckBox;
    EditText appUrl;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_dev);

        appUrl = findViewById(R.id.app_url_input_field);
        launchAppButton = findViewById(R.id.launch_app_button);
        clearDataCheckBox = findViewById(R.id.checkbox_clear_data);

        launchAppButton.setOnClickListener((view) -> {
            String url = appUrl.getText().toString();
            boolean clearData = clearDataCheckBox.isChecked();
            Intent intent = new Intent(this, MendixReactActivity.class);
            MendixApp mendixApp = new MendixApp(AppUrl.forRuntime(url), MxConfiguration.WarningsFilter.all, true);
            intent.putExtra(MendixReactActivity.MENDIX_APP_INTENT_KEY, mendixApp);
            intent.putExtra(MendixReactActivity.CLEAR_DATA, clearData);
            startActivity(intent);
        });
    }
}
