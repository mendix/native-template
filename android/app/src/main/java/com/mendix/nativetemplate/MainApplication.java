package com.mendix.nativetemplate;

import android.app.Activity;

import androidx.annotation.NonNull;
import android.content.Context;
import android.content.Intent;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.os.Build;

import com.facebook.react.PackageList;
import com.facebook.react.ReactPackage;
import com.mendix.mendixnative.MendixReactApplication;
import com.mendix.mendixnative.react.splash.MendixSplashScreenPresenter;
import com.microsoft.codepush.react.BuildConfig;
import com.microsoft.codepush.react.CodePush;

import org.devio.rn.splashscreen.SplashScreen;
import org.devio.rn.splashscreen.SplashScreenReactPackage;

import java.util.List;

public class MainApplication extends MendixReactApplication {
    @Override
    public Intent registerReceiver(BroadcastReceiver receiver, IntentFilter filter) {
        if (Build.VERSION.SDK_INT >= 34 && getApplicationInfo().targetSdkVersion >= 34) {
            return super.registerReceiver(receiver, filter, Context.RECEIVER_EXPORTED);
        } else {
            return super.registerReceiver(receiver, filter);
        }
    }

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
        packages.add(new CodePush(getCodePushKey(), getApplicationContext(), BuildConfig.DEBUG));
        packages.add(new SplashScreenReactPackage());

        return packages;
    }

    @Override
    public MendixSplashScreenPresenter createSplashScreenPresenter() {
        return new MendixSplashScreenPresenter() {
            @Override
            public void show(@NonNull Activity activity) {
                hide(activity);
                SplashScreen.show(activity, true);
            }

            @Override
            public void hide(@NonNull Activity activity) {
                SplashScreen.hide(activity);
            }
        };
    }
}
