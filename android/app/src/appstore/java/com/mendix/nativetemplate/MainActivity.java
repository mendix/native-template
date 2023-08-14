package com.mendix.nativetemplate;

import android.os.Build;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;

import com.mendix.mendixnative.activity.MendixReactActivity;
import com.mendix.mendixnative.config.AppUrl;
import com.mendix.mendixnative.react.MendixApp;
import com.mendix.mendixnative.react.MxConfiguration;

import org.devio.rn.splashscreen.SplashScreen;

public class MainActivity extends MendixReactActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        SplashScreen.show(this);
        this.getLifecycle().addObserver(new MendixActivityObserver(this));
        boolean hasDeveloperSupport = ((MainApplication) getApplication()).getUseDeveloperSupport();
        mendixApp = new MendixApp(AppUrl.getUrlFromResource(this), MxConfiguration.WarningsFilter.none, hasDeveloperSupport, false);
        super.onCreate(savedInstanceState);

        // Checks the current theme and apply the correct style (Backwards compatible)
        boolean isDarkMode;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            isDarkMode = getResources().getConfiguration().isNightModeActive();
        } else {
            isDarkMode = AppCompatDelegate.getDefaultNightMode() == AppCompatDelegate.MODE_NIGHT_YES;
        }
        setTheme(isDarkMode ? R.style.AppTheme : R.style.AppTheme_Dark);
    }
}
