import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/common/state/room_id_state.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/room_details/presentation/ui/widgets/mini_room_card.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/custom_appbar.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/room_cart_item.dart';
import 'package:hotel_app/features/search_room/presentation/provider/room_search_provider.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';

class SearchListScreen extends ConsumerStatefulWidget {
  final SearchRequest searchRequest;

  const SearchListScreen({super.key, required this.searchRequest});

  static const String routeName = '/searchList';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchListScreenState();
}

class _SearchListScreenState extends ConsumerState<SearchListScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(roomSearchViewModel.notifier)
          .getRoomsSearch(widget.searchRequest);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomSearchViewModel);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomSearchAppBar(),
      body: Stack(
        children: [
          roomState.when(
            none: () => const Center(child: Text('Please search for rooms.')),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (roomList) => roomList.isEmpty
                ? const Center(child: Text('No rooms found.'))
                : ListView.builder(
                    itemCount: roomList.length,
                    itemBuilder: (context, index) {
                      return RoomCardItem(room: roomList[index]);
                    },
                  ),
            error: (msg) => Center(child: Text('Error: $msg')),
            orElse: () => const Center(
              child: Text('Something went wrong. Please try again.'),
            ),
          ),
          Positioned(
            child: MiniRoomCard(width: screenWidth * 0.45),
            bottom: 5,
            right: 0,
          )
        ],
      ),
      bottomNavigationBar: BottomBarNavigation(),
    );
  }
}
