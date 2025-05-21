import 'package:flutter/material.dart';
import '../../../../common/widgets/keep_alive_component.dart';

class TabComponent extends StatelessWidget {
  final GlobalKey<NavigatorState> tabKey;
  final Widget child;

  const TabComponent({
    super.key,
    required this.tabKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: tabKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => KeepAliveComponent(
            child: child,
          ),
        );
      },
    );
  }
}
