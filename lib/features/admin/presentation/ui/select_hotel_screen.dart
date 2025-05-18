import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/app_colors.dart';
import 'package:hotel_app/features/admin/model/hotel_dto.dart';

import '../../../../common/hotel_storage_provider.dart';
import '../provider/user_hotel_provider.dart';

class SelectHotelScreen extends ConsumerStatefulWidget {
  const SelectHotelScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectHotelScreen> createState() => _SelectHotelScreenState();
}

class _SelectHotelScreenState extends ConsumerState<SelectHotelScreen> {
  @override
  void initState() {
    super.initState();

    // Load user's hotels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userHotelsProvider.notifier).getUserHotels();
    });
  }

  Future<void> _selectHotel(HotelDto hotel) async {
    // Save the selected hotel ID and return to the previous screen
    await ref.read(hotelStorageProvider).saveHotelId(hotel.hotelId);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelState = ref.watch(userHotelsProvider);
    final currentHotelId = ref.watch(selectedHotelIdProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Select Hotel", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorsLib.primaryBoldColor,
      ),
      body: hotelState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => Center(child: Text("Error: $error")),
        success: (hotels) {
          if (hotels.isEmpty) {
            return const Center(child: Text("No hotels found. Please contact admin to add a hotel."));
          }

          return ListView.builder(
            itemCount: hotels.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              final isSelected = hotel.hotelId == currentHotelId;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    hotel.hotelName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${hotel.address.specificAddress}, ${hotel.address.ward}, ${hotel.address.district}, ${hotel.address.city}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                      : const Icon(Icons.arrow_forward_ios, size: 20),
                  selected: isSelected,
                  selectedTileColor: Colors.grey.withOpacity(0.1),
                  onTap: () => _selectHotel(hotel),
                ),
              );
            },
          );
        },
        orElse: () => const Center(child: Text("Loading hotels...")),
      ),
    );
  }
}