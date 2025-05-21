import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/search_room/model/service.dart';
import 'package:hotel_app/features/search_room/presentation/provider/service_provider.dart';

class ServiceCheckBoxSection extends ConsumerStatefulWidget {
  final List<Service> selected;
  final ValueChanged<List<Service>> onChanged;

  const ServiceCheckBoxSection({
    Key? key,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  ConsumerState<ServiceCheckBoxSection> createState() =>
      _ServiceCheckBoxSectionState();
}

class _ServiceCheckBoxSectionState
    extends ConsumerState<ServiceCheckBoxSection> {
  late List<Service> _selected;

  @override
  void initState() {
    super.initState();
    _selected = [...widget.selected];

    // Gọi load services sau khi build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceViewModel.notifier).getServices();
    });
  }

  void _onServiceChecked(Service service, bool? checked) {
    final updated = List<Service>.from(_selected);
    if (checked == true) {
      updated.add(service);
    } else {
      updated.removeWhere((s) => s.serviceId == service.serviceId);
    }
    setState(() => _selected = updated);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serviceViewModel);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label bên trái
          const Expanded(
            child: Text(
              'Dịch vụ:',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Checkbox bên phải
          Expanded(
            flex: 2,
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (msg) => Text(
                'Lỗi: $msg',
                style: const TextStyle(color: Colors.red),
              ),
              emptyData: () => const Text(
                'Không có dịch vụ nào',
                style: TextStyle(color: Colors.grey),
              ),
              success: (services) => Wrap(
                spacing: 10,
                runSpacing: -8,
                children: services.map((service) {
                  final isChecked =
                      _selected.any((s) => s.serviceId == service.serviceId);
                  return SizedBox(
                    width: 160, // giới hạn chiều rộng mỗi checkbox
                    child: CheckboxListTile(
                      value: isChecked,
                      onChanged: (checked) =>
                          _onServiceChecked(service, checked),
                      title: Text(
                        service.serviceName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.brown,
                      checkColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                  );
                }).toList(),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
