import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/widgets/user_hotel_card.dart';
import 'admin_hotel_list_screen.dart';
import 'model/user_owner_hotel.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/services/admin_owner_hotel.dart';

class AdminSystemHotels extends StatefulWidget {
  const AdminSystemHotels({super.key});

  @override
  _AdminSystemHotelsState createState() => _AdminSystemHotelsState();
}

class _AdminSystemHotelsState extends State<AdminSystemHotels> {
  Future<List<User>>? _usersFuture;
  final UserService _userService = UserService();
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  static const Color _brownColor = Colors.brown;

  @override
  void initState() {
    super.initState();
    _fetchAndSetUsers();
  }

  void _fetchAndSetUsers() {
    _usersFuture = _userService.fetchUsers();
    _usersFuture!.then((users) {
      if (mounted) {
        setState(() {
          _allUsers = users;
          _filterUsers(_searchController.text);
        });
      }
    }).catchError((error) {
      if (mounted) {
        print("Error fetching users: $error");
        setState(() {});
      }
    });
  }

  void _filterUsers(String query) {
    final lowerCaseQuery = query.toLowerCase();
    List<User> newlyFiltered;
    if (query.isEmpty) {
      newlyFiltered = _allUsers;
    } else {
      newlyFiltered = _allUsers.where((user) {
        return user.id.toString().contains(lowerCaseQuery) ||
            user.fullName.toLowerCase().contains(lowerCaseQuery) ||
            user.username.toLowerCase().contains(lowerCaseQuery) ||
            user.phone.contains(query) ||
            user.email.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }

    if (!listEquals(_filteredUsers, newlyFiltered)) {
      if (mounted) {
        setState(() {
          _filteredUsers = newlyFiltered;
        });
      }
    } else if (_filteredUsers.isEmpty &&
        newlyFiltered.isEmpty &&
        query.isNotEmpty &&
        _searchController.text.isNotEmpty) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(0, -5),
              child: Stack(
                children: [
                  const Heading(title: 'QUẢN LÝ CHỦ KHÁCH SẠN'),
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
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: _brownColor),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm ID, tên, username, sdt, email...',
                  hintStyle: TextStyle(color: _brownColor.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: _brownColor),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          tooltip: 'Xóa tìm kiếm',
                          onPressed: () {
                            _searchController.clear();
                            _filterUsers('');
                          },
                        )
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: _brownColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: _brownColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 15.0),
                ),
                onChanged: _filterUsers,
              ),
            ),

            Expanded(
              child: FutureBuilder<List<User>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      (snapshot.connectionState == ConnectionState.none &&
                          _usersFuture != null)) {
                    if (_allUsers.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: _brownColor),
                      );
                    }
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 40),
                            const SizedBox(height: 10),
                            Text('Lỗi tải dữ liệu: ${snapshot.error}',
                                textAlign: TextAlign.center),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: _brownColor),
                              onPressed: _fetchAndSetUsers,
                              child: const Text('Thử lại',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (_filteredUsers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Không có chủ khách sạn nào.'
                                  : 'Không tìm thấy kết quả.',
                              style: textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: _filteredUsers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return UserHotelCard(
                        user: user,
                        color: Colors.grey,
                        textTheme: textTheme,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HotelListScreen(userId: user.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
