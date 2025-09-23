package com.mendix.nativetemplate;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.facebook.react.PackageList;
import com.facebook.react.ReactPackage;
import com.mendix.mendixnative.MendixReactApplication;
import com.mendix.mendixnative.react.splash.MendixSplashScreenPresenter;

import com.zoontek.rnbootsplash.RNBootSplash;

import java.util.List;

public class MainApplication extends MendixReactApplication {
    @Override
    public boolean getUseDeveloperSupport() {
        return false;
    }

    @Override
    public List<ReactPackage> getPackages() {
        List<ReactPackage> packages = new PackageList(this).getPackages();
        packages.addAll(new MendixPackageList(this).getPackages());

        // Packages that cannot be autolinked yet can be added manually here, for example:
        // packages.add(new MyReactNativePackage());

        return packages;
    }

    @Override
    public MendixSplashScreenPresenter createSplashScreenPresenter() {
        return new MendixSplashScreenPresenter() {
            @Override
            public void show(@NonNull Activity activity) {
                hide(activity);
                RNBootSplash.init(activity, R.style.BootTheme);
            }

            @Override
            public void hide(@NonNull Activity activity) {
            }
        };
    }
}
