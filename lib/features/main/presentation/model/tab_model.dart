enum TabEnum { home, order, noti, more }

extension TabEnumExtension on TabEnum {
  String get enumToString {
    switch (this) {
      case TabEnum.home:
        return "Home";
      case TabEnum.order:
        return "Order";
      case TabEnum.noti:
        return "Notification";
      case TabEnum.more:
        return "More";
    }
  }
}
