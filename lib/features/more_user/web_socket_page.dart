import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';  // Để sử dụng jsonDecode

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://172.28.160.1:8000/ws/current-sensor-data/'),
  );

  String receivedData = '';

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      try {
        final jsonData = jsonDecode(data);
        setState(() {
          receivedData = 'Message: ${jsonData['message']}\nSensor Data: ${jsonData['data']}';
        });
      } catch (e) {
        print("Error decoding data: $e");
      }
    });

  }

  @override
  void dispose() {
    // Đóng kết nối khi widget không còn sử dụng
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Received Data:'),
            Text(
              receivedData.isEmpty ? 'No data received yet' : receivedData,
              style: TextStyle(fontSize: 24),
            ),
            Text('Received Data1'),
            Text(
              receivedData
            ),
          ],
        ),
      ),
    );
  }
}
