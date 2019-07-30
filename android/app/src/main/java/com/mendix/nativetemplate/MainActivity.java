package com.mendix.nativetemplate;

import android.os.Bundle;
import androidx.annotation.Nullable;


import com.mendix.mendixnative.activity.MendixReactActivity;
import com.mendix.mendixnative.config.AppUrl;
import com.mendix.mendixnative.react.MendixApp;
import com.mendix.mendixnative.react.MxConfiguration;

public class MainActivity extends MendixReactActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        mendixApp = new MendixApp(AppUrl.getUrlFromResource(this),
                MxConfiguration.WarningsFilter.none);

        super.onCreate(savedInstanceState);
    }
}
