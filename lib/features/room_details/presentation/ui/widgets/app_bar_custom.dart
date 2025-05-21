import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/common/state/room_id_state.dart';
import 'package:hotel_app/features/room_details/presentation/provider/room_details_provider.dart';

class AppBarCustom extends ConsumerWidget implements PreferredSizeWidget {
  final int roomId;
  final bool isScrolled;

  const AppBarCustom({
    Key? key,
    required this.roomId,
    this.isScrolled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomDetailsState = ref.watch(roomDetailsViewModel);
    final roomNotifier = ref.read(compareRoomProvider.notifier);

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          gradient: isScrolled
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
          color: isScrolled ? Colors.brown : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    ref.read(roomIdProvider.notifier).state = 0;
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    ref.read(compareRoomIdProvider.notifier).state = roomId;
                    Navigator.pop(context);
                    final data = roomDetailsState.data;
                    if (data != null) {
                      roomNotifier.setRoomDetails(data);
                      ref.read(roomIdProvider.notifier).state = 0;
                    }
                  },
                  icon: const Icon(Icons.compare_arrows, color: Colors.white),
                  label: const Text('So sánh',
                      style: TextStyle(color: Colors.white)),
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
