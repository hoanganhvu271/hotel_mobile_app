import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/admin_system_home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_app/features/register/register_screen.dart';
import 'package:hotel_app/features/home/home_screen.dart';
import 'package:hotel_app/features/more/more_screen.dart';
import 'package:hotel_app/features/map/map_screen.dart';

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
        final roles = data['roles'] as List<dynamic>;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setInt('user_id', userId);

        // Navigate based on roles
        if (roles.contains('ROLE_ADMIN')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminSystemHome()),
          );
        } else if (roles.contains('ROLE_CUSTOMER')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (roles.contains('ROLE_HOTEL_OWNER')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            _errorMessage = 'Vai trò không hợp lệ';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Sai tài khoản hoặc mật khẩu';
        });
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
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.apartment,
                size: 80,
                color: Colors.pink,
              ),
              const SizedBox(height: 10),
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person, color: Colors.brown),
                        labelText: 'Tên đăng nhập',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.vpn_key, color: Colors.brown),
                        labelText: 'Mật khẩu',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Quên mật khẩu ?',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(color: Colors.white),
                      ),
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
              const SizedBox(height: 20),
              const Text('Bạn chưa có tài khoản?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Đăng Ký',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}