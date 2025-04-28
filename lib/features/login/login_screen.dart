import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/keep_alive_component.dart';
import 'package:hotel_app/features/home/home_screen.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_app/features/more/more_screen.dart';

import '../../common/utils/api_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('${ApiConstants.baseUrl}/api/auth/login');
    final body = {
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['jwt'];
        final userId = data['userId'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setInt('user_id', userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }


      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final token = data['jwt'];
      //
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('jwt_token', token);
      //
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HomeScreen()),
      //   );
      // } else {
      //   setState(() {
      //     _errorMessage = 'Sai tài khoản hoặc mật khẩu';
      //   });
      // }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối đến server';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Tài khoản'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Đăng nhập'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      // bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
    );

  }
}
