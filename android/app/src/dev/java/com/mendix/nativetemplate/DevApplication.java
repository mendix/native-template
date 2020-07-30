package com.mendix.nativetemplate;

import com.mendix.mendixnative.react.splash.MendixSplashScreenPresenter;

public class DevApplication extends MainApplication {
    @Override
    public boolean getUseDeveloperSupport() {
        return true;
    }

    @Override
    public MendixSplashScreenPresenter createSplashScreenPresenter() {
        return null;
    }
}
