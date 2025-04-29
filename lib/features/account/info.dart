import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/utils/api_constants.dart';
import 'user_update.dart';
import 'package:hotel_app/features/more/more_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _userInfo;

  Future<void> _fetchUserInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('${ApiConstants.baseUrl}/api/user/info');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _userInfo = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Không thể tải thông tin người dùng';
        });
      }
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
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.brown),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MoreScreen()),
                );
              },
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.brown,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            buildTextField('Họ và Tên', _userInfo?['fullName']),
                            buildTextField('Tên đăng nhập', _userInfo?['username']),
                            buildTextField('Số điện thoại', _userInfo?['phone']),
                            buildTextField('Email', _userInfo?['email']),
                            buildTextField('Điểm tích lũy', _userInfo?['score'].toString()),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      fullName: _userInfo?['fullName'] ?? '',
                                      email: _userInfo?['email'] ?? '',
                                      phone: _userInfo?['phone'] ?? '',
                                    ),
                                  ),
                                ).then((updatedData) {
                                  if (updatedData != null) {
                                    setState(() {
                                      _userInfo = updatedData;
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Chỉnh sửa',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value ?? 'N/A'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.brown),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.brown),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}