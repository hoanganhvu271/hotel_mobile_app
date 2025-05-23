enum TabEnum { home, order, noti, more }

extension TabEnumExtension on TabEnum {
  String get enumToString {
    switch (this) {
      case TabEnum.home:
        return "Trang chủ";
      case TabEnum.order:
        return "Đơn đặt";
      case TabEnum.noti:
        return "Thông báo";
      case TabEnum.more:
        return "Mở rộng";
    }
  }
}
