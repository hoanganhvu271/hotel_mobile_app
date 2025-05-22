import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/utils/value_utils.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/features/admin/model/room_response_dto.dart';
import 'package:hotel_app/features/admin/presentation/provider/room_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/search_box_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/features/admin/presentation/ui/room_edit_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/room_form_screen.dart';

class RoomManagerScreen extends ConsumerStatefulWidget {
  const RoomManagerScreen({super.key});

  @override
  ConsumerState<RoomManagerScreen> createState() => _RoomManagerScreenState();
}

class _RoomManagerScreenState extends ConsumerState<RoomManagerScreen> {
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(roomViewModel.notifier).loadMore();
    }
  }
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(roomViewModel);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoomFormScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              const TopAppBar(title: "Danh sách phòng"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                child: SearchBoxWidget(
                    onChange: (text) => ref.read(roomViewModel.notifier).setSearchState(query: text, page: 0),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(roomViewModel.notifier).refresh(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: viewModel.when(
                      emptyData: () {
                        return const Center(
                          child: Text("No data"),
                        );
                      },
                      success: (rooms) {
                        return ListView.separated(
                          itemBuilder: (_, index) {
                            if (index == viewModel.listData.length) {
                              return viewModel.canLoadMore ? const Center(
                                child: CircularProgressIndicator(),
                              ) : const SizedBox.shrink();
                            }
                            else {
                              return RoomItemWidget(room: viewModel.listData[index]);
                            }
                          },
                          itemCount: viewModel.listData.length + 1,
                          separatorBuilder: (_, index) => const SizedBox(height: 14),
                        );
                      },
                      error: (error) {
                        return Center(
                          child: Text("Error: $error"),
                        );
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      orElse: () {
                        return const Center(
                          child: Text("No data"),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class RoomItemWidget extends StatelessWidget {
  final RoomResponseDto room;

  const RoomItemWidget({
    super.key,
    required this.room
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomEditScreen(room: room),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // replace with CacheNetworkImage later ...
              CachedNetworkImage(
                imageUrl: '${ApiUrl.baseURL}${ApiUrl.uploadPath}/${room.roomImg}',
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 27),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text("ID: ${room.id}"),
                    const SizedBox(height: 5),
                    Text("Giá: ${ValueUtils.formatCurrency(room.pricePerNight)} /đêm"),
                    const SizedBox(height: 5),
                    Text("Diện tích: ${room.area} m2"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
