package com.gr15.hotel_app.security;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import java.io.File;

public class EmulatorCheck {

    public static boolean check(Context context) {
        return checkBasics() || checkEmulatorFiles() || IMEICheck(context);
    }

    private static boolean checkBasics() {
        Log.d("vu", "Build Info:\n"
                + "PRODUCT: " + Build.PRODUCT + "\n"
                + "MANUFACTURER: " + Build.MANUFACTURER + "\n"
                + "BRAND: " + Build.BRAND + "\n"
                + "DEVICE: " + Build.DEVICE + "\n"
                + "MODEL: " + Build.MODEL + "\n"
                + "HARDWARE: " + Build.HARDWARE + "\n"
                + "FINGERPRINT: " + Build.FINGERPRINT);

        return (Build.FINGERPRINT.startsWith("google/sdkgphone")
                && Build.FINGERPRINT.endsWith(":user/release-keys")
                && "Google".equals(Build.MANUFACTURER)
                && Build.PRODUCT.startsWith("sdk_gphone")
                && "google".equals(Build.BRAND)
                && Build.MODEL.startsWith("sdk_gphone"))
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || "Build2".equals(Build.HOST)
                || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || Build.PRODUCT.contains("sdk_google")
                || "google_sdk".equals(Build.PRODUCT)
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("sdk_x86")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator");
    }

    private static final String[] GENY_FILES = {"/dev/socket/genyd", "/dev/socket/baseband_genyd"};
    private static final String[] PIPES = {"/dev/socket/qemud", "/dev/qemu_pipe"};
    private static final String[] X86_FILES = {
            "ueventd.android_x86.rc", "x86.prop", "ueventd.ttVM_x86.rc",
            "init.ttVM_x86.rc", "fstab.ttVM_x86", "fstab.vbox86",
            "init.vbox86.rc", "ueventd.vbox86.rc"
    };
    private static final String[] ANDY_FILES = {"fstab.andy", "ueventd.andy.rc"};
    private static final String[] NOX_FILES = {"fstab.nox", "init.nox.rc", "ueventd.nox.rc"};

    private static boolean checkFiles(String[] targets) {
        for (String filePath : targets) {
            File file = new File(filePath);
            if (file.exists()) {
                Log.d("vu", "EmulatorCheck: Found file: " + filePath);
                return true;
            }
        }
        return false;
    }

    private static boolean checkEmulatorFiles() {
        return checkFiles(GENY_FILES) || checkFiles(ANDY_FILES) || checkFiles(NOX_FILES)
                || checkFiles(X86_FILES) || checkFiles(PIPES);
    }

    public static boolean IMEICheck(Context context) {
        // Check permissions and real IMEI if needed
        return false;
    }
}

