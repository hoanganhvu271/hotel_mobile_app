import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/model/booking_status.dart';
import 'package:hotel_app/features/admin/presentation/provider/update_booking_status.dart';

import 'update_booking_status_provider_test.mocks.dart';

@GenerateMocks([HotelRepository])
void main() {
  group('UpdateBookingStatusNotifier', () {
    late MockHotelRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockHotelRepository();
      container = ProviderContainer(
        overrides: [
          hotelOwnerRepository.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be none', () {
      final notifier = container.read(updateBookingStatusViewModel.notifier);
      final state = container.read(updateBookingStatusViewModel);

      expect(state.status, BaseStatus.none);
    });

    test('update should change state to loading then success when repository succeeds', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      final successResponse = BaseResponse<bool>(
        isSuccessful: true,
        successfulData: true,
      );

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) async => successResponse);

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      final future = notifier.update(bookingId, status);

      // Assert loading state
      expect(container.read(updateBookingStatusViewModel).status, BaseStatus.loading);

      await future;

      // Assert success state
      final finalState = container.read(updateBookingStatusViewModel);
      expect(finalState.status, BaseStatus.success);
      expect(finalState.data, true);

      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);
    });

    test('update should change state to error when repository fails', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      const errorMessage = "Network error";
      final errorResponse = BaseResponse<bool>(
        isSuccessful: false,
        errorMessage: errorMessage,
      );

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) async => errorResponse);

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      await notifier.update(bookingId, status);

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.error);
      expect(state.message, errorMessage);

      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);
    });

    test('update should handle exception and set error state', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      const exceptionMessage = "Connection timeout";

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenThrow(Exception(exceptionMessage));

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      await notifier.update(bookingId, status);

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.error);
      expect(state.message, contains(exceptionMessage));

      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);
    });

    test('update should work with CANCELLED status', () async {
      // Arrange
      const bookingId = 2;
      const status = BookingStatus.CANCELLED;
      final successResponse = BaseResponse<bool>(
        isSuccessful: true,
        successfulData: true,
      );

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) async => successResponse);

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      await notifier.update(bookingId, status);

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.success);
      expect(state.data, true);

      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);
    });

    test('multiple updates should work correctly', () async {
      // Arrange
      const bookingId1 = 1;
      const bookingId2 = 2;
      const status1 = BookingStatus.CONFIRMED;
      const status2 = BookingStatus.CANCELLED;

      final successResponse = BaseResponse<bool>(
        isSuccessful: true,
        successfulData: true,
      );

      when(mockRepository.updateBookingStatus(any, any))
          .thenAnswer((_) async => successResponse);

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      await notifier.update(bookingId1, status1);
      await notifier.update(bookingId2, status2);

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.success);
      expect(state.data, true);

      verify(mockRepository.updateBookingStatus(bookingId1, status1)).called(1);
      verify(mockRepository.updateBookingStatus(bookingId2, status2)).called(1);
    });
  });
}
