import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBoxWidget extends StatefulWidget {
  const SearchBoxWidget({super.key});

  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
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
          suffixIcon: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/icon_filter.svg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}