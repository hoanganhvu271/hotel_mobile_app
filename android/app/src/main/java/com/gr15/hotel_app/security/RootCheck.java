package com.gr15.hotel_app.security;

import android.os.Build;

import java.io.File;

public class RootCheck {
    public static boolean check() {
        return checkForBinary("su")
                || checkForBinary("magisk")
                || checkForBinary("busybox")
                || detectTestKeys()
                || checkCommandExecute()
                || checkRootNative(); // This method placeholder
    }

    private static boolean checkForBinary(String filename) {
        String[] paths = Const.getPaths();
        for (String path : paths) {
            File file = new File(path, filename);
            if (file.exists()) {
                return true;
            }
        }
        return false;
    }

    private static boolean checkCommandExecute() {
        try {
            Runtime.getRuntime().exec("su");
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private static boolean detectTestKeys() {
        String buildTags = Build.TAGS;
        return buildTags != null && buildTags.contains("test-keys");
    }

    private static boolean checkRootNative() {
        return false; // Add native check if needed
    }
}

