import 'package:image_picker/image_picker.dart';

class RoomImageWrapper {
  final int id;
  final String? url;
  final XFile? file;

  RoomImageWrapper({this.id = -1, this.url, this.file});

  bool get isFromServer => url != null;
  bool get isLocalFile => file != null;

  String get displayPath => isFromServer ? url! : file!.path;

  XFile? get imageFile => file;
}
