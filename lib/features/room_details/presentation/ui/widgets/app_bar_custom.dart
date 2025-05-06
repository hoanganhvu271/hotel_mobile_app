import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';

class AppBarCustom extends ConsumerWidget implements PreferredSizeWidget {
  final int roomId;
  const AppBarCustom({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(), // đẩy nút so sánh về bên phải
                TextButton.icon(
                  onPressed: () {
                    ref.read(compareRoomIdProvider.notifier).state = roomId;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.compare_arrows, color: Colors.white),
                  label: const Text(
                    'So sánh',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
