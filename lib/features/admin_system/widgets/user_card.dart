import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/model/user_model.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final String Function(String) roleTranslator; // <- thêm dòng này

  const UserCard({
    super.key,
    required this.user,
    required this.onTap,
    required this.roleTranslator, // <- thêm dòng này
  });

  @override
  Widget build(BuildContext context) {
    final translatedRoles = user.roleDtoList.map((e) => roleTranslator(e.name)).join(', ');

    return Card(
      color: Color(0xFFFAFAFA),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.person, size: 40),
        title: Text(
          user.fullName ?? 'Chưa có tên',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(user.email ?? 'Chưa có email'),
            Text("Tên đăng nhập: ${user.username ?? 'Chưa có'}"),
            Text("Vai trò: $translatedRoles"),
          ],
        ),
        trailing: const Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }
}
