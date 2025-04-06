import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/add_more_image_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/room_info_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/service_widget.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';
import '../../../../constants/app_colors.dart';

class RoomFormScreen extends StatelessWidget {
  const RoomFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          child: ColoredBox(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BigImagePickerWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 19,
                      children: <Widget>[
                        const AddMoreImageWidget(),
                        const RoomInfoWidget(),
                        const ServiceWidget(),
                        const SizedBox(height: 10),
                        CustomFilledButton(title: "Xác nhận", backgroundColor: ColorsLib.primaryColor)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
