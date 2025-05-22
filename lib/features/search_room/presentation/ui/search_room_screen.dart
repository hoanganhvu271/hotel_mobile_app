import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/search_room/model/search.dart';
import 'package:hotel_app/features/search_room/presentation/extention/search_request_ref_extention.dart';
import 'package:hotel_app/features/search_room/presentation/state/search_request_state.dart';
import 'package:hotel_app/features/search_room/presentation/ui/search_list_screen.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/search_filter.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/search_list.dart';
import 'package:hotel_app/features/search_room/presentation/provider/search_entry_provider.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';

class SearchRoomScreen extends ConsumerStatefulWidget {
  final int isFiltered;
  const SearchRoomScreen({super.key, this.isFiltered = 0});
  static const String routeName = '/searchRoom';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchRoomScreenState();
}

class _SearchRoomScreenState extends ConsumerState<SearchRoomScreen> {
  int _isFiltered = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int isReseted = 0;

  @override
  void initState() {
    super.initState();
    _isFiltered = widget.isFiltered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchEntryState = ref.watch(searchEntryViewModel);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(compareRoomIdProvider.notifier).state = 0;
      // _searchController.text =
      //     ref.read(searchRequestState.notifier).state.keyword.toString();
      // ref.resetSearchRequest();
      if (isReseted == 0) {
        ref.resetSearchRequest();
        isReseted = 1;
      }
    });

    List<Search> list = [];

    if (searchEntryState.status.isSuccess && searchEntryState.data != null) {
      list = searchEntryState.data!
          .map((entry) => Search.fromSearchEntry(entry))
          .toList();
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Size.fromHeight(kToolbarHeight).height + 20,
        title: const Text('Tìm phòng'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF65462D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      // TextField & Filter Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth - 40 - 10 - 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                print(value);
                                _isFiltered = 0;
                                setState(() {
                                  _searchQuery = value;
                                });
                                Future.delayed(const Duration(seconds: 1), () {
                                  if (_searchController.text == value) {
                                    ref
                                        .read(searchEntryViewModel.notifier)
                                        .getSearchEntries(_searchQuery);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Khách sạn, địa điểm,...",
                                hintStyle: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0x669A775C),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Color(0xFF65462D),
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = _searchController.text;
                                    });
                                    ref.setKeyword(_searchQuery);

                                    ref.validateSearchRequest();
                                    print(ref.watch(searchRequestState));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchListScreen(
                                                  searchRequest: ref.watch(
                                                      searchRequestState),
                                                )));
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 13),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFiltered = _isFiltered == 0 ? 1 : 0;
                              });
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _isFiltered == 0
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFFA68367),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.tune,
                                color: _isFiltered == 0
                                    ? const Color(0xFF65462D)
                                    : Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (searchEntryState.status.isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (searchEntryState.status.isError) {
                              return Center(
                                child: Text(
                                  "Lỗi: ${searchEntryState.message}",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isFiltered == 0
                                  ? SearchList(
                                      key: const ValueKey('list'), list: list)
                                  : const SearchFilter(key: ValueKey('filter')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
