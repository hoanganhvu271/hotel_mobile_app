import 'package:flutter/services.dart';

class SecurityPlatform {
  static const MethodChannel _channel = MethodChannel('security_plugin');

  static Future<bool> isRooted() async {
    final bool result = await _channel.invokeMethod('isRooted');
    return result;
  }

  static Future<bool> isEmulator() async {
    final bool result = await _channel.invokeMethod('isEmulator');
    return result;
  }
}
