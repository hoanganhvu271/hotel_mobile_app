import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBoxWidget extends StatefulWidget {
  final Function(String) onChange;
  const SearchBoxWidget({super.key, required this.onChange});

  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onChange(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isFocused ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: "Tìm kiếm theo tên ...",
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFFD9D9D9),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/icon_search.svg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
        )
    );
  }
}
