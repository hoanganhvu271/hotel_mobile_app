import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/widgets/service_checkbox_list.dart';
import 'package:hotel_app/features/search_room/presentation/provider/city_provider.dart';
import 'package:hotel_app/features/search_room/presentation/provider/district_provider.dart';
import 'package:hotel_app/features/search_room/presentation/provider/service_provider.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/custom_dropdown.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/custom_input_field.dart';

class SearchFilter extends ConsumerStatefulWidget {
  const SearchFilter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFilterState();
}

class _SearchFilterState extends ConsumerState<SearchFilter> {
  bool hasCityFetched = false;
  double fontSize = 18;
  FontWeight fontWeight = FontWeight.w500;
  Color color = const Color(0xFF65462D);
  String fontFamily = 'Roboto';

  @override
  Widget build(BuildContext context) {
    final cityState = ref.watch(cityViewModel);

    final districtState = ref.watch(districtViewModel);

    final serviceState = ref.watch(serviceViewModel);

    if (!hasCityFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(cityViewModel.notifier).getCities();
        ref.read(serviceViewModel.notifier).getServices();
      });
      hasCityFetched = true;
    }

    return Column(
      children: [
        CustomDropdown(
          label: 'Tỉnh/Thành phố',
          fetchData: cityState.when(orElse: () => [], success: (data) => data),
          onChanged: (value) {
            print("City selected: $value");
            ref.read(districtViewModel.notifier).getDistricts(value.toString());
          },
        ),
        // CustomDropdown(
        //   label: 'Quận/Huyện',
        //   fetchData:
        //       districtState.when(orElse: () => [], success: (data) => data),
        //   onChanged: (value) {
        //     print("District selected: $value");
        //   },
        // ),
        CustomInputField(
          label: 'Người lớn',
          initialValue: '0',
          onChanged: (value) => print("Adults selected: $value"),
        ),
        CustomInputField(
          label: 'Trẻ em',
          initialValue: '0',
          onChanged: (value) => print("Children selected: $value"),
        ),
        CustomInputField(
          label: 'Giường',
          initialValue: '0',
          onChanged: (value) => print("Bed number selected: $value"),
        ),
        //   ServiceCheckboxList(
        //     onChanged: (selected) => print("Services selected: $selected"),
        //   ),
      ],
    );
  }
}
