import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:hotel_app/features/noti/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/utils/api_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchNotifications();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final token = prefs.getString('jwt_token');
    if (userId == null || token == null) {
      debugPrint('User not logged in or token missing');
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/notifications/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint('Fetched notifications: $data');
        setState(() {
          notifications = data
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        });
      }
      else {
        debugPrint('Failed to fetch notifications: ${response.statusCode}');
        final errorData = json.decode(response.body);
        debugPrint('Error data: $errorData');
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Match HomeScreen background
      appBar: AppBar(
        backgroundColor: Colors.brown, // Match HomeScreen AppBar color
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.white, // White text for AppBar title
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // White color for AppBar icons
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchNotifications,
        child: notifications.isEmpty
            ? const Center(
          child: Text(
            'Không có thông báo',
            style: TextStyle(
              color: Colors.brown, // Match text color to HomeScreen
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isEven = index % 2 == 0;

            return Align(
              alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isEven ? Colors.white : Colors.brown[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.content,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatDateTime(notification.notificationTime),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}