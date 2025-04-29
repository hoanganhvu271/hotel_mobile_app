import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/model/user_model.dart';
import 'package:hotel_app/features/admin_system/services/admin_user_service.dart';
import 'package:hotel_app/features/admin_system/widgets/user_card.dart';

class AdminSystemUsers extends StatefulWidget {
  const AdminSystemUsers({super.key});

  @override
  State<AdminSystemUsers> createState() => _AdminSystemUsersState();
}


class _AdminSystemUsersState extends State<AdminSystemUsers> {
  final userService = UserService();
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  List<String> selectedRoles = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final users = await userService.fetchUsers();
    setState(() {
      allUsers = users;
      filteredUsers = users;
    });
  }


  void _filterUsers() {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final matchesSearchTerm =
            (user.fullName?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false) ||
                (user.phone?.contains(searchController.text) ?? false) ||
                (user.username?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false) ||
                (user.email?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false);

        final matchesRoles = selectedRoles.isEmpty || user.roleDtoList.any((role) => selectedRoles.contains(role.name));

        return matchesSearchTerm && matchesRoles;
      }).toList();
    });
  }

  void _openEditModal(User user) {
    TextEditingController nameController = TextEditingController(text: user.fullName);
    TextEditingController phoneController = TextEditingController(text: user.phone);
    TextEditingController emailController = TextEditingController(text: user.email);
    TextEditingController usernameController = TextEditingController(text: user.username);
    List<String> selectedRoles = user.roleDtoList.map((e) => e.name).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Sửa thông tin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: "Họ tên")),
                    TextField(controller: phoneController, decoration: const InputDecoration(labelText: "SĐT")),
                    TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
                    TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: selectedRoles.contains("ROLE_CUSTOMER"),
                          onChanged: (val) {
                            setStateModal(() {
                              val == true
                                  ? selectedRoles.add("ROLE_CUSTOMER")
                                  : selectedRoles.remove("ROLE_CUSTOMER");
                            });
                          },
                        ),
                        const Text("Khách hàng"),
                        Checkbox(
                          value: selectedRoles.contains("ROLE_ADMIN"),
                          onChanged: (val) {
                            setStateModal(() {
                              val == true
                                  ? selectedRoles.add("ROLE_ADMIN")
                                  : selectedRoles.remove("ROLE_ADMIN");
                            });
                          },
                        ),
                        const Text("Quản lý"),
                        Checkbox(
                          value: selectedRoles.contains("ROLE_HOTEL_OWNER"),
                          onChanged: (val) {
                            setStateModal(() {
                              val == true
                                  ? selectedRoles.add("ROLE_HOTEL_OWNER")
                                  : selectedRoles.remove("ROLE_HOTEL_OWNER");
                            });
                          },
                        ),
                        const Text("Chủ khách sạn"),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        User updatedUser = User(
                          userId: user.userId,
                          fullName: nameController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                          username: usernameController.text,
                          score: user.score ?? 0,
                          roleDtoList: selectedRoles.map((e) {
                            int roleId = switch (e) {
                              'ROLE_ADMIN' => 2,
                              'ROLE_CUSTOMER' => 1,
                              'ROLE_HOTEL_OWNER' => 3,
                              _ => 0
                            };
                            return Role(roleId: roleId, name: e);
                          }).toList(),
                        );
                        await userService.updateUser(user.userId, updatedUser);
                        Navigator.pop(context);
                        _loadUsers();
                      },
                      child: const Text("Lưu"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  String getRoleNameVN(String roleName) {
    switch (roleName) {
      case 'ROLE_ADMIN':
        return 'Quản lý';
      case 'ROLE_CUSTOMER':
        return 'Khách hàng';
      case 'ROLE_HOTEL_OWNER':
        return 'Chủ khách sạn';
      default:
        return 'Không rõ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'DANH SÁCH KHÁCH HÀNG'),
              Positioned(
                left: 20,
                top: 22,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm theo tên, số điện thoại, username, gmail',
                      labelStyle: TextStyle(color: Colors.brown.shade800),
                    ),
                    onChanged: (value) => _filterUsers(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _filterUsers,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Checkbox(
                  value: selectedRoles.contains("ROLE_CUSTOMER"),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedRoles.add("ROLE_CUSTOMER");
                      } else {
                        selectedRoles.remove("ROLE_CUSTOMER");
                      }
                      _filterUsers();
                    });
                  },
                ),
                const Text("Khách hàng"),
                Checkbox(
                  value: selectedRoles.contains("ROLE_ADMIN"),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedRoles.add("ROLE_ADMIN");
                      } else {
                        selectedRoles.remove("ROLE_ADMIN");
                      }
                      _filterUsers();
                    });
                  },
                ),
                const Text("Quản lý"),
                Checkbox(
                  value: selectedRoles.contains("ROLE_HOTEL_OWNER"),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedRoles.add("ROLE_HOTEL_OWNER");
                      } else {
                        selectedRoles.remove("ROLE_HOTEL_OWNER");
                      }
                      _filterUsers();
                    });
                  },
                ),
                const Text("Chủ khách sạn"),
              ],
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(child: Text("Không có khách hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (_, index) {
                final user = filteredUsers[index];
                return UserCard(
                  user: user,
                  roleTranslator: getRoleNameVN,
                  onTap: () async {
                    final detail = await userService.fetchUserById(user.userId);
                    _openEditModal(detail);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}