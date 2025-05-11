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
  double _miniCardTop = 500;
  double _miniCardRight = 0;
  final double _miniCardWidthFraction = 0.45;
  final GlobalKey _miniCardKey = GlobalKey();

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
            top: _miniCardTop - 35,
            right: _miniCardRight,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _miniCardTop += details.delta.dy;
                  _miniCardRight -= details.delta.dx;

                  final mediaQuery = MediaQuery.of(context);
                  final screenHeight =
                      mediaQuery.size.height - mediaQuery.padding.top - 215;
                  final screenWidth = mediaQuery.size.width;

                  final renderBox = _miniCardKey.currentContext
                      ?.findRenderObject() as RenderBox?;
                  final cardSize = renderBox?.size;

                  final cardHeight = cardSize?.height ?? 200.0; // fallback
                  final cardWidth =
                      cardSize?.width ?? (screenWidth * _miniCardWidthFraction);

                  _miniCardTop =
                      _miniCardTop.clamp(0.0, screenHeight - cardHeight);
                  _miniCardRight =
                      _miniCardRight.clamp(0.0, screenWidth - cardWidth);
                });
              },
              onPanEnd: (details) {
                double screenWidth = MediaQuery.of(context).size.width;
                double cardWidth = screenWidth * _miniCardWidthFraction;

                setState(() {
                  // Nếu gần bên trái hơn => snap vào trái (right = screenWidth - cardWidth)
                  // Nếu gần bên phải hơn => snap vào phải (right = 0)
                  if (_miniCardRight < (screenWidth - cardWidth) / 2) {
                    _miniCardRight = 0; // Snap vào phải
                  } else {
                    _miniCardRight = screenWidth - cardWidth; // Snap vào trái
                  }
                });
              },
              child: MiniRoomCard(
                width:
                    MediaQuery.of(context).size.width * _miniCardWidthFraction,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarNavigation(),
    );
  }
}
