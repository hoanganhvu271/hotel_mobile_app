import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/tab_model.dart';

final tabProvider = AutoDisposeNotifierProvider<TabNotifier, TabEnum>(TabNotifier.new);

class TabNotifier extends AutoDisposeNotifier<TabEnum> {
  @override
  TabEnum build() {
    return TabEnum.home;
  }

  void setTab(TabEnum tab) {
    state = tab;
  }
}