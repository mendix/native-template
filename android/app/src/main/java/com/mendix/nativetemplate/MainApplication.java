package com.mendix.nativetemplate;

import com.airbnb.android.react.maps.MapsPackage;
import com.brentvatne.react.ReactVideoPackage;
import com.calendarevents.CalendarEventsPackage;
import com.codemotionapps.reactnativedarkmode.DarkModePackage;
import com.devfd.RNGeocoder.RNGeocoderPackage;
import com.dylanvann.fastimage.FastImageViewPackage;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.horcrux.svg.SvgPackage;
import com.imagepicker.ImagePickerPackage;
import com.learnium.RNDeviceInfo.RNDeviceInfo;
import com.mendix.mendixnative.MendixReactApplication;
import com.microsoft.codepush.react.CodePush;
import com.oblador.vectoricons.VectorIconsPackage;
import com.polidea.reactnativeble.BlePackage;
import com.proyecto26.inappbrowser.RNInAppBrowserPackage;
import com.reactnativecommunity.asyncstorage.AsyncStoragePackage;
import com.reactnativecommunity.netinfo.NetInfoPackage;
import com.reactnativecommunity.webview.RNCWebViewPackage;
import com.rnfingerprint.FingerprintAuthPackage;
import com.swmansion.gesturehandler.react.RNGestureHandlerPackage;
import com.zmxv.RNSound.RNSoundPackage;

import org.pgsqlite.SQLitePluginPackage;
import org.reactnative.camera.RNCameraPackage;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import fr.greweb.reactnativeviewshot.RNViewShotPackage;
import io.invertase.firebase.RNFirebasePackage;
import io.invertase.firebase.messaging.RNFirebaseMessagingPackage;
import io.invertase.firebase.notifications.RNFirebaseNotificationsPackage;

public class MainApplication extends MendixReactApplication {
  @Override
  public boolean getUseDeveloperSupport() {
    return false;
  }

  @Override
  public List<ReactPackage> getPackages() {
    List<ReactPackage> packages = new ArrayList<>();
    packages.addAll(Arrays.asList(
            new MainReactPackage(),
            new FastImageViewPackage(),
            new DarkModePackage(),
            new CodePush(getCodePushKey(), getApplicationContext(), BuildConfig.DEBUG),
            new RNGestureHandlerPackage(),
            new RNCWebViewPackage(),
            new RNViewShotPackage(),
            new ReactVideoPackage(),
            new VectorIconsPackage(),
            new FingerprintAuthPackage(),
            new SvgPackage(),
            new SQLitePluginPackage(),
            new RNSoundPackage(),
            new MapsPackage(),
            new RNInAppBrowserPackage(),
            new ImagePickerPackage(),
            new RNGeocoderPackage(),
            new RNDeviceInfo(),
            new RNCameraPackage(),
            new CalendarEventsPackage(),
            new BlePackage(),
            new NetInfoPackage(),
            new AsyncStoragePackage()
    ));

    if (BuildConfig.USE_FIREBASE) {
      packages.addAll(Arrays.asList(
        new RNFirebaseMessagingPackage(),
        new RNFirebaseNotificationsPackage(),
        new RNFirebasePackage()
      ));
    }

    return packages;
  }
}
