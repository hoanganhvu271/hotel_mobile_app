package com.gr15.hotel_app;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import com.gr15.hotel_app.security.SecurityPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // Đăng ký plugin
        flutterEngine.getPlugins().add(new SecurityPlugin());
    }
}
