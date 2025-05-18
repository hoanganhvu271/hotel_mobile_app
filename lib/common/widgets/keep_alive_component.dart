import 'package:flutter/material.dart';

class KeepAliveComponent extends StatefulWidget {
  final Widget child;

  const KeepAliveComponent({
    super.key,
    required this.child,
  });

  @override
  State<KeepAliveComponent> createState() => _KeepAliveComponentState();
}

class _KeepAliveComponentState extends State<KeepAliveComponent> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      child: widget.child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
