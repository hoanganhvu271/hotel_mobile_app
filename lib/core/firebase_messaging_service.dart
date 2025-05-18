import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/di/injector.dart';
import 'package:hotel_app/common/auth/auth_service.dart';
import 'dart:io';

import '../main.dart';

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>(
      (ref) => FirebaseMessagingService(ref.read(authServiceProvider)),
);

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final AuthService _authService;

  FirebaseMessagingService(this._authService);

  Future<void> initializeFirebaseMessaging() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Get the token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _registerDeviceToken(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_registerDeviceToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle notification opened app
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Handle notification when app is terminated
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _registerDeviceToken(String token) async {
    try {
      // You'll need to get the current user ID from your auth system
      // For now, I'll use a placeholder
      var userId = await _getCurrentUserId();
      if (userId == null) userId = 4;

      final deviceType = Platform.isIOS ? 'ios' : 'android';

      await injector<DioClient>().post(
        '/api/device-token/register',
        data: {
          'userId': userId,
          'deviceToken': token,
          'deviceType': deviceType,
        },
      );

      print('Device token registered successfully');
    } catch (e) {
      print('Error registering device token: $e');
    }
  }

  Future<void> unregisterDeviceToken() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) return;

      final token = await _firebaseMessaging.getToken();
      if (token == null) return;

      await injector<DioClient>().delete(
        '/api/device-token/unregister',
        queryParameters: {
          'userId': userId,
          'deviceToken': token,
        },
      );

      print('Device token unregistered successfully');
    } catch (e) {
      print('Error unregistering device token: $e');
    }
  }

  Future<int?> _getCurrentUserId() async {
    return await _authService.getCurrentUserId();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

      // Show local notification or update UI
      _showLocalNotification(message);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print('Message data: ${message.data}');

    // Handle navigation based on message data
    if (message.data['type'] == 'booking_status_update') {
      final bookingId = message.data['bookingId'];
      if (bookingId != null) {
        // Navigate to booking details screen
        _navigateToBookingDetails(bookingId);
      }
    }
  }

  void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel_id', // ID kênh thông báo
      'Thông báo chung',     // Tên kênh
      channelDescription: 'Kênh dùng cho thông báo mặc định',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title ?? 'Thông báo',
      message.notification?.body ?? 'Bạn có một thông báo mới',
      platformChannelSpecifics,
    );
  }

  void _navigateToBookingDetails(String bookingId) {
    // Implement navigation to booking details screen
    // You might need to use a global navigator key or a navigation service
  }
}

// Background message handler (must be a top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
}