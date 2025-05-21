import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/service_model.dart';
import 'package:hotel_app/features/admin/presentation/provider/services_provider.dart';

class ServiceSelectorWidget extends ConsumerStatefulWidget {
  final List<int> selectedServiceIds;
  final Function(List<int>) onServicesChanged;

  const ServiceSelectorWidget({
    Key? key,
    required this.selectedServiceIds,
    required this.onServicesChanged,
  }) : super(key: key);

  @override
  ConsumerState<ServiceSelectorWidget> createState() => _ServiceSelectorWidgetState();
}

class _ServiceSelectorWidgetState extends ConsumerState<ServiceSelectorWidget> {
  late List<int> _selectedServiceIds;

  @override
  void initState() {
    super.initState();
    _selectedServiceIds = List.from(widget.selectedServiceIds);
    // Fetch services when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesProvider.notifier).fetchServices();
    });
  }

  void _toggleService(ServiceModel service) {
    setState(() {
      if (_selectedServiceIds.contains(service.serviceId)) {
        _selectedServiceIds.remove(service.serviceId);
      } else {
        _selectedServiceIds.add(service.serviceId);
      }
      widget.onServicesChanged(_selectedServiceIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(servicesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dịch vụ phòng",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        servicesState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Text(
              "Lỗi: $message",
              style: const TextStyle(color: Colors.red),
            ),
          ),
          success: (services) => _buildServicesList(services),
          none: () => const Center(child: Text("Không có dịch vụ nào")),
          orElse: () => const Center(child: Text("Đang tải...")),
        ),
      ],
    );
  }

  Widget _buildServicesList(List<ServiceModel> services) {
    if (services.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text("Không có dịch vụ nào")),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: services.map((service) {
        final isSelected = _selectedServiceIds.contains(service.serviceId);

        return InkWell(
          onTap: () => _toggleService(service),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  service.serviceName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? Colors.green.shade800 : Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "(${service.price.toStringAsFixed(0)}đ)",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.green.shade800 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}