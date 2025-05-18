import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/app_colors.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/features/admin/presentation/provider/review_management_provider.dart';
import 'package:hotel_app/features/admin/model/review_response_dto.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/search_box_widget.dart';

class ReviewManagementScreen extends ConsumerStatefulWidget {
  const ReviewManagementScreen({super.key});

  @override
  ConsumerState<ReviewManagementScreen> createState() => _ReviewManagementScreenState();
}

class _ReviewManagementScreenState extends ConsumerState<ReviewManagementScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'all'; // all, 5, 4, 3, 2, 1

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(reviewManagementProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(reviewManagementProvider);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: Column(
            children: [
              const TopAppBar(title: "Quản lý đánh giá"),

              // Filter and Search Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    // Rating Filter
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'Tất cả'),
                          const SizedBox(width: 8),
                          _buildFilterChip('5', '5 ⭐'),
                          const SizedBox(width: 8),
                          _buildFilterChip('4', '4 ⭐'),
                          const SizedBox(width: 8),
                          _buildFilterChip('3', '3 ⭐'),
                          const SizedBox(width: 8),
                          _buildFilterChip('2', '2 ⭐'),
                          const SizedBox(width: 8),
                          _buildFilterChip('1', '1 ⭐'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Box
                    SearchBoxWidget(
                      onChange: (text) => ref.read(reviewManagementProvider.notifier).setSearchState(
                        query: text,
                        page: 0,
                        rating: _selectedFilter == 'all' ? null : int.parse(_selectedFilter),
                      ),
                    ),
                  ],
                ),
              ),

              // Reviews List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(reviewManagementProvider.notifier).refresh(),
                  child: viewModel.when(
                    emptyData: () => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "Chưa có đánh giá nào",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    success: (reviews) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: viewModel.listData.length + 1,
                        itemBuilder: (context, index) {
                          if (index == viewModel.listData.length) {
                            return viewModel.canLoadMore
                                ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            )
                                : const SizedBox.shrink();
                          }

                          return ReviewItemWidget(
                            review: viewModel.listData[index],
                            onReply: (review) => _showReplyDialog(review),
                          );
                        },
                      );
                    },
                    error: (error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text("Lỗi: $error"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.read(reviewManagementProvider.notifier).refresh(),
                            child: const Text("Thử lại"),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
        ref.read(reviewManagementProvider.notifier).setSearchState(
          page: 0,
          rating: value == 'all' ? null : int.parse(value),
        );
      },
      selectedColor: ColorsLib.primaryColor.withOpacity(0.2),
      checkmarkColor: ColorsLib.primaryBoldColor,
      labelStyle: TextStyle(
        color: isSelected ? ColorsLib.primaryBoldColor : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _showReplyDialog(ReviewResponseDto review) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phản hồi đánh giá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đánh giá của ${review.guestName}:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(review.content),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Phản hồi của bạn',
                border: OutlineInputBorder(),
                hintText: 'Nhập phản hồi cho đánh giá này...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                ref.read(reviewManagementProvider.notifier).replyToReview(
                  review.reviewId,
                  replyController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsLib.primaryBoldColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Gửi phản hồi'),
          ),
        ],
      ),
    );
  }
}

class ReviewItemWidget extends StatelessWidget {
  final ReviewResponseDto review;
  final Function(ReviewResponseDto) onReply;

  const ReviewItemWidget({
    super.key,
    required this.review,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with guest info and rating
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorsLib.primaryColor.withOpacity(0.2),
                  child: Text(
                    review.guestName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: ColorsLib.primaryBoldColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.guestName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStarRating(review.rating),
                          const SizedBox(width: 8),
                          Text(
                            review.roomName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  TimeUtils.formatDateOnly(review.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Review content
            Text(
              review.content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),

            // Reply section
            if (review.ownerReply != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorsLib.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsLib.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reply,
                          size: 16,
                          color: ColorsLib.primaryBoldColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Phản hồi từ khách sạn:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorsLib.primaryBoldColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.ownerReply!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => onReply(review),
                  icon: const Icon(Icons.reply, size: 18),
                  label: const Text('Phản hồi'),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorsLib.primaryBoldColor,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        );
      }),
    );
  }
}