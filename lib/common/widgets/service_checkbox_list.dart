import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/label_brown_dark.dart';
import 'package:hotel_app/common/widgets/sevice_item.dart';
import '../../features/booking/model/service.dart';
import '../../features/booking/services/service_service.dart';

class ServiceCheckboxList extends StatefulWidget {
  final ValueChanged<List<String>>? onChanged;

  const ServiceCheckboxList({super.key, this.onChanged});

  @override
  State<ServiceCheckboxList> createState() => _ServiceCheckboxListState();
}

class _ServiceCheckboxListState extends State<ServiceCheckboxList> {
  List<Service> services = [];
  List<int> selectedServiceIds = [];

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      final result = await fetchServices();
      setState(() => services = result);
    } catch (e) {
      print('Error loading services: $e');
    }
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedServiceIds.contains(id)) {
        selectedServiceIds.remove(id);
      } else {
        selectedServiceIds.add(id);
      }
    });

    final selectedNames = services
        .where((service) => selectedServiceIds.contains(service.id))
        .map((service) => service.name)
        .toList();

    widget.onChanged?.call(selectedNames);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelBrownDark(label: 'Dịch vụ'),
        ...services.map((service) {
          final isSelected = selectedServiceIds.contains(service.id);
          return ServiceItem(
            label: service.name,
            isSelected: isSelected,
            onTap: () => toggleSelection(service.id),
          );
        }).toList(),
      ],
    );
  }
}
