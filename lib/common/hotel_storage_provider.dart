import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/local/shared_prefs/shared_pref.dart';
import '../../di/injector.dart';

// Provider for accessing the selected hotel ID
final selectedHotelIdProvider = StateProvider<int?>((ref) => null);

// Provider for managing hotel storage
final hotelStorageProvider = Provider<HotelStorage>((ref) => HotelStorage(ref));

// Constants for storage keys
const String _hotelIdKey = "selected_hotel_id";

// Class to handle hotel-related storage operations
class HotelStorage {
  final ProviderRef _ref;
  final SharedPref _sharedPref;

  HotelStorage(this._ref) : _sharedPref = injector<SharedPref>();

  // Initialize by loading stored hotel ID
  Future<void> init() async {
    final hotelId = await getStoredHotelId();
    if (hotelId != null) {
      _ref.read(selectedHotelIdProvider.notifier).state = hotelId;
    }
  }

  // Get the stored hotel ID
  Future<int?> getStoredHotelId() async {
    if (await _sharedPref.has(_hotelIdKey)) {
      final value = await _sharedPref.get(_hotelIdKey);
      if (value != null) {
        return int.tryParse(value.toString());
      }
    }
    return null;
  }

  // Save the hotel ID
  Future<bool> saveHotelId(int hotelId) async {
    _ref.read(selectedHotelIdProvider.notifier).state = hotelId;
    return await _sharedPref.set(_hotelIdKey, hotelId.toString());
  }

  // Clear the stored hotel ID
  Future<bool> clearHotelId() async {
    _ref.read(selectedHotelIdProvider.notifier).state = null;
    return await _sharedPref.remove(_hotelIdKey);
  }

  // Get current hotel ID (from provider)
  int? getCurrentHotelId() {
    return _ref.read(selectedHotelIdProvider);
  }
}