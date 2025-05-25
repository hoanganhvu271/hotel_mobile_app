import 'dart:async';
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
      // Act
      final state = container.read(updateBookingStatusViewModel);

      // Assert
      expect(state.status, BaseStatus.none);
      expect(state.data, isNull);
      expect(state.message, isNull);
    });

    test('should update booking status successfully', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      final successResponse = BaseResponse<bool>(
        isSuccessful: true,
        successfulData: true,
      );

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) async => successResponse);

      // Keep provider alive by listening to it
      final subscription = container.listen(
        updateBookingStatusViewModel,
            (previous, next) {},
      );

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      notifier.update(bookingId, status);

      // Wait for the async operation to complete
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.success);
      expect(state.data, true);
      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);

      // Cleanup
      subscription.close();
    });

    test('should handle update error', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      const errorMessage = "Update failed";
      final errorResponse = BaseResponse<bool>(
        isSuccessful: false,
        errorMessage: errorMessage,
      );

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) async => errorResponse);

      // Keep provider alive
      final subscription = container.listen(
        updateBookingStatusViewModel,
            (previous, next) {},
      );

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      notifier.update(bookingId, status);

      // Wait for the async operation to complete
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.error);
      expect(state.message, errorMessage);
      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);

      // Cleanup
      subscription.close();
    });

    test('should handle exception', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenThrow(Exception('Network error'));

      // Keep provider alive
      final subscription = container.listen(
        updateBookingStatusViewModel,
            (previous, next) {},
      );

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      notifier.update(bookingId, status);

      // Wait for the async operation to complete
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.error);
      expect(state.message, contains('Network error'));
      verify(mockRepository.updateBookingStatus(bookingId, status)).called(1);

      // Cleanup
      subscription.close();
    });

    test('should work with different booking statuses', () async {
      // Arrange
      const bookingId = 1;
      final successResponse = BaseResponse<bool>(
        isSuccessful: true,
        successfulData: true,
      );

      when(mockRepository.updateBookingStatus(any, any))
          .thenAnswer((_) async => successResponse);

      // Keep provider alive
      final subscription = container.listen(
        updateBookingStatusViewModel,
            (previous, next) {},
      );

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Test CONFIRMED status
      notifier.update(bookingId, BookingStatus.CONFIRMED);
      await Future.delayed(Duration(milliseconds: 100));

      var state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.success);
      expect(state.data, true);

      // Test CANCELLED status
      notifier.update(bookingId, BookingStatus.CANCELLED);
      await Future.delayed(Duration(milliseconds: 100));

      state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.success);
      expect(state.data, true);

      verify(mockRepository.updateBookingStatus(bookingId, any)).called(2);

      // Cleanup
      subscription.close();
    });

    test('should show loading state during update', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      final completer = Completer<BaseResponse<bool>>();

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) => completer.future);

      // Keep provider alive
      final subscription = container.listen(
        updateBookingStatusViewModel,
            (previous, next) {},
      );

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Assert initial state
      expect(container.read(updateBookingStatusViewModel).status, BaseStatus.none);

      // Act
      notifier.update(bookingId, status);

      // Wait a bit for loading state
      await Future.delayed(Duration(milliseconds: 10));

      // Assert loading state
      var state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.loading);

      // Complete the future
      completer.complete(BaseResponse<bool>(
        isSuccessful: true,
        successfulData: true,
      ));

      // Wait for completion
      await Future.delayed(Duration(milliseconds: 50));

      // Assert final state
      state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.success);
      expect(state.data, true);

      // Cleanup
      subscription.close();
    });

    test('should transition from loading to error', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      const errorMessage = "Update failed";
      final completer = Completer<BaseResponse<bool>>();

      when(mockRepository.updateBookingStatus(bookingId, status))
          .thenAnswer((_) => completer.future);

      // Keep provider alive
      final subscription = container.listen(
        updateBookingStatusViewModel,
            (previous, next) {},
      );

      final notifier = container.read(updateBookingStatusViewModel.notifier);

      // Act
      notifier.update(bookingId, status);
      await Future.delayed(Duration(milliseconds: 10));

      // Assert loading state
      expect(container.read(updateBookingStatusViewModel).status, BaseStatus.loading);

      // Complete with error
      completer.complete(BaseResponse<bool>(
        isSuccessful: false,
        errorMessage: errorMessage,
      ));

      await Future.delayed(Duration(milliseconds: 50));

      // Assert error state
      final state = container.read(updateBookingStatusViewModel);
      expect(state.status, BaseStatus.error);
      expect(state.message, errorMessage);

      // Cleanup
      subscription.close();
    });
  });
}