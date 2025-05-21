import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/room_image_wrapper.dart';
import 'package:image_picker/image_picker.dart';

final uploadImageProvider = StateNotifierProvider.autoDispose<ImageUploadNotifier, List<RoomImageWrapper>>(
  (ref) => ImageUploadNotifier(),
);

class ImageUploadNotifier extends StateNotifier<List<RoomImageWrapper>> {
  ImageUploadNotifier() : super([]);

  RoomImageWrapper getMainImage() {
    if (state.isNotEmpty) {
      return state[0];
    }
    throw Exception("No main image available");
  }

  setMainImage(XFile image) {
    if (state.isNotEmpty) {
      state = [RoomImageWrapper(file: image)] + state.sublist(1);
    } else {
      state = [RoomImageWrapper(file: image)];
    }
  }

  List<XFile> getExtraImages() {
    if (state.length > 1) {
      return state.sublist(1).map((e) => e.imageFile!).toList();
    }
    return [];
  }

  void addImage(RoomImageWrapper image) {
    state = [...state, image];
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.length) {
      state = [...state]..removeAt(index);
    }
  }

  void clearImages() {
    state = [];
  }

  void updateImageAt(int index, RoomImageWrapper image) {
    if (index >= 0 && index < state.length) {
      state = [...state]..[index] = image;
    }
  }

  void removeEndImage() {
    if (state.isNotEmpty) {
      state = [...state]..removeLast();
    }
  }

  List<int> getKeepImageIdList() {
    return state.where((element) => element.file == null).map((e) => e.id).toList();
  }

  List<XFile> getUpdateImage() {
    final lisImage = state;
    final List<XFile> updateImage = [];

    for (var i = 1; i < lisImage.length; i++) {
      if (lisImage[i].file != null) {
        updateImage.add(lisImage[i].file!);
      }
    }

    return updateImage;
  }
}