package com.mendix.nativetemplate

import android.app.Activity
import com.facebook.hermes.reactexecutor.HermesExecutorFactory
import com.facebook.react.PackageList
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.JavaScriptExecutorFactory
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.react.jscexecutor.JSCExecutorFactory
import com.mendix.mendixnative.MendixReactApplication
import com.mendix.mendixnative.react.splash.MendixSplashScreenPresenter
import org.devio.rn.splashscreen.SplashScreen
import org.devio.rn.splashscreen.SplashScreenReactPackage


open class MainApplication : MendixReactApplication() {
    override fun getUseDeveloperSupport(): Boolean = false

    override fun getPackages(): List<ReactPackage> {
        val packages = PackageList(this).packages
        packages.addAll(MendixPackageList(this).packages)
        packages.add(SplashScreenReactPackage())
        return packages
    }

    override fun createSplashScreenPresenter(): MendixSplashScreenPresenter {
        return object : MendixSplashScreenPresenter {
            override fun show(activity: Activity) {
                hide(activity)
                SplashScreen.show(activity, true)
            }

            override fun hide(activity: Activity) {
                SplashScreen.hide(activity)
            }
        }
    }

    override var reactNativeHost: ReactNativeHost = object : DefaultReactNativeHost(this) {
        override fun getUseDeveloperSupport(): Boolean = this@MainApplication.useDeveloperSupport

        override fun getPackages(): List<ReactPackage> = this@MainApplication.packages

        override fun getJSMainModuleName(): String = "index"

        override fun getJSBundleFile(): String? = this@MainApplication.jsBundleFile

        override fun getRedBoxHandler() = this@MainApplication.redBoxHandler

        override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
    }
}