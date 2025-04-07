// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Home Screen'));
//   }
// }

import 'package:flutter/material.dart';

import '../../common/widgets/home_booking_btn.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Home Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            BookingBtn(),
          ],
        ),
      ),
    );
  }
}



// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _nameController = TextEditingController();
//
//   void _goToWelcomeScreen() {
//     final name = _nameController.text.trim();
//     if (name.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => WelcomeScreen(name: name),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng nhập tên!")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Trang chủ")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Nhập tên của bạn:", style: TextStyle(fontSize: 20)),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Tên của bạn",
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _goToWelcomeScreen,
//               child: const Text("Chuyển sang trang khác"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
