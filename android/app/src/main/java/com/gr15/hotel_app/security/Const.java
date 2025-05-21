package com.gr15.hotel_app.security;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Const {
    private static final String[] suPaths = {
            "/data/local/", "/data/local/bin/", "/data/local/xbin/",
            "/sbin/", "/su/bin/", "/system/bin/", "/system/bin/.ext/",
            "/system/bin/failsafe/", "/system/sd/xbin/", "/system/usr/we-need-root/",
            "/system/xbin/", "/cache/", "/data/", "/dev/"
    };

    public static String[] getPaths() {
        List<String> paths = new ArrayList<>(Arrays.asList(suPaths));
        String sysPaths = System.getenv("PATH");
        if (sysPaths == null || sysPaths.isEmpty()) {
            return paths.toArray(new String[0]);
        }

        for (String path : sysPaths.split(":")) {
            if (!path.endsWith("/")) {
                path += "/";
            }
            if (!paths.contains(path)) {
                paths.add(path);
            }
        }
        return paths.toArray(new String[0]);
    }
}
