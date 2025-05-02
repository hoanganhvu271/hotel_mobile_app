
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/create_room_request.dart';
import 'package:hotel_app/features/admin/presentation/provider/image_upload_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';
import '../../model/put_room_request.dart';
import '../../model/room_response_dto.dart';

final createRoomViewModel = AutoDisposeNotifierProvider<CreateRoomNotifier, BaseState<RoomResponseDto>>(() => CreateRoomNotifier());

class CreateRoomNotifier extends AutoDisposeNotifier<BaseState<RoomResponseDto>> {
  @override
  BaseState<RoomResponseDto> build() {
    state = BaseState.none();
    return state;
  }

  void createRoom(CreateRoomRequest request) async {
    state = BaseState.loading();
    try {

      final mainImage = ref.read(uploadImageProvider.notifier).getMainImage();
      if (mainImage.imageFile == null) {
        state = BaseState.error("Main image is required");
        return;
      }

      final response = await ref.read(hotelOwnerRepository).createRoomWithImages(
          request: request,
          mainImage: ref.read(uploadImageProvider.notifier).getMainImage().imageFile!,
          extraImages: ref.read(uploadImageProvider.notifier).getExtraImages().isNotEmpty
            ? ref.read(uploadImageProvider.notifier).getExtraImages()
            : null,
      );

      if (response.isSuccessful) {
        final RoomResponseDto data = response.successfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }

  void updateRoom(PutRoomRequest request) async {
    state = BaseState.loading();
    try {
      final mainImage = ref.read(uploadImageProvider.notifier).getMainImage();

      final response = await ref.read(hotelOwnerRepository).updateRoomWithImages(
        request: request,
        mainImage: mainImage.isLocalFile ? mainImage.imageFile! : null,
        extraImages: ref.read(uploadImageProvider.notifier).getUpdateImage().isNotEmpty
            ? ref.read(uploadImageProvider.notifier).getUpdateImage()
            : null,
      );

      if (response.isSuccessful) {
        final RoomResponseDto data = response.successfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }

}
