import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_app/features/login/login_screen.dart';

import '../../common/utils/api_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('${ApiConstants.baseUrl}/api/auth/register');
    final body = {
      'fullName': _fullNameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clear any previous session data if needed

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['message'] ?? 'Đăng ký thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi kết nối đến server'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                'Đăng ký tài khoản',
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
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person, color: Colors.brown),
                        labelText: 'Họ và tên',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone, color: Colors.brown),
                        labelText: 'Số điện thoại',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email, color: Colors.brown),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_circle, color: Colors.brown),
                        labelText: 'Tên đăng nhập',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.vpn_key, color: Colors.brown),
                        labelText: 'Mật khẩu',
                      ),
                    ),
                    const SizedBox(height: 25),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Đăng ký',
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
              const Text('Bạn đã có tài khoản?'),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Đăng nhập',
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