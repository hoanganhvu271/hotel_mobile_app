import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/widgets/appbar/back_appbar.dart';
import 'package:hotel_app/core/widgets/buttons/brown_button.dart';
import 'package:hotel_app/core/widgets/buttons/white_button.dart';
import 'package:hotel_app/models/room_model.dart';
import 'package:hotel_app/features/room_details/presentation/provider/room_provider.dart';

class RoomDetailsScreen extends ConsumerStatefulWidget {
  final int roomId;

  const RoomDetailsScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  ConsumerState<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends ConsumerState<RoomDetailsScreen> {
  int _currentImagePage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Gọi fetch dữ liệu thông qua provider khi widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(roomViewmodel.notifier).getRoomById(widget.roomId.toString());
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe state từ Provider
    final roomState = ref.watch(roomViewmodel);

    return Scaffold(
      body: roomState.when(
        // Trạng thái ban đầu - chưa có dữ liệu
        none: () => const Center(
          child: Text('Select a room to view details'),
        ),

        // Đang tải dữ liệu
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFA68367)),
        ),

        // Có lỗi xảy ra
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(roomViewmodel.notifier)
                    .getRoomById(widget.roomId.toString()),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),

        // Dữ liệu được tải thành công
        success: (rooms) {
          // Nếu không có phòng nào trong danh sách
          if (rooms.isEmpty) {
            return const Center(
              child: Text('No room data available'),
            );
          }

          // Hiển thị thông tin phòng đầu tiên trong danh sách
          final room = rooms.first;
          return _buildRoomDetails(room);
        },
        orElse: () {},
      ),
    );
  }

  Widget _buildRoomDetails(RoomModel room) {
    // Danh sách URL hình ảnh
    final List<String> imageUrls = [room.roomImg];
    // Nếu có nhiều hình ảnh, bạn có thể thêm vào đây

    return Stack(
      children: [
        // Nội dung chính
        SingleChildScrollView(
          child: Column(
            children: [
              // Slideshow hình ảnh phòng
              _buildImageSlideshow(imageUrls),

              // Thông tin chi tiết phòng
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên phòng
                    Text(
                      room.roomName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Giá phòng
                    Row(
                      children: [
                        Text(
                          '\$${room.pricePerNight.toStringAsFixed(0)}/night',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA68367),
                          ),
                        ),
                        if (room.pricePerHour > 0)
                          Text(
                            ' • \$${room.pricePerHour.toStringAsFixed(0)}/hour',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Các tính năng phòng
                    _buildFeatureRow(Icons.square_foot, '${room.area} sq m'),
                    _buildFeatureRow(
                        Icons.person, 'Up to ${room.maxOccupancy} guests'),
                    _buildFeatureRow(Icons.bed, '${room.bedNumber} beds'),
                    _buildFeatureRow(Icons.child_care,
                        '${room.numChildrenFree} children free'),

                    const SizedBox(height: 24),
                    const Text(
                      'Room Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description mẫu (thay bằng dữ liệu thực tế nếu có)
                    Text(
                      'Experience comfort and elegance in our ${room.roomName}. '
                      'This spacious room is perfect for relaxation and offers '
                      'all the amenities you need for a pleasant stay.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),

                    // Thêm khoảng trống ở dưới để tránh bị che bởi các nút
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),

        // BackAppbar
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: BackAppbar(),
        ),

        // Các nút dưới cùng
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 255),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: WhiteButton(
                    text: 'Compare',
                    onPressed: () {
                      // Xử lý khi nút Compare được nhấn
                      print('Compare button pressed');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BrownButton(
                    text: 'Book',
                    onPressed: () {
                      // Xử lý khi nút Book được nhấn
                      print('Book button pressed for room ${room.roomId}');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget hiển thị slideshow hình ảnh
  Widget _buildImageSlideshow(List<String> imageUrls) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImagePage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 64,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Indicator chỉ hiện khi có nhiều hình ảnh
          if (imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImagePage == index
                          ? const Color(0xFFA68367)
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget hiển thị một hàng tính năng
  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFA68367)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
