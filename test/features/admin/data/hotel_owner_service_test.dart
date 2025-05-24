import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_service.dart';
import 'package:hotel_app/features/admin/model/booking_status.dart';

import 'hotel_owner_service_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  group('HotelOwnerService updateBookingStatus', () {
    late MockDioClient mockDioClient;
    late HotelOwnerService service;

    setUp(() {
      mockDioClient = MockDioClient();
      service = HotelOwnerService();
    });

    test('should return success response when API call succeeds', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: true,
      );

      when(mockDioClient.put(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await service.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );

      // Assert
      expect(result.isSuccessful, true);
      expect(result.successfulData, true);
      verify(mockDioClient.put(
        '/api/hotel-owner/booking/status/1',
        queryParameters: {'status': 'CONFIRMED'},
      )).called(1);
    });

    test('should return error response when API call fails with DioException', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      const errorMessage = "Booking not found";

      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
          data: {'message': errorMessage},
        ),
      );

      when(mockDioClient.put(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(dioException);

      // Act
      final result = await service.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );

      // Assert
      expect(result.isSuccessful, false);
      expect(result.errorMessage, errorMessage);
      expect(result.errorCode, '404');
    });

    test('should return error response when API call fails with general exception', () async {
      // Arrange
      const bookingId = 1;
      const status = BookingStatus.CONFIRMED;
      const errorMessage = "Network error";

      when(mockDioClient.put(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(Exception(errorMessage));

      // Act
      final result = await service.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );

      // Assert
      expect(result.isSuccessful, false);
      expect(result.errorMessage, contains(errorMessage));
    });

    test('should work with CANCELLED status', () async {
      // Arrange
      const bookingId = 2;
      const status = BookingStatus.CANCELLED;
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: true,
      );

      when(mockDioClient.put(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await service.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );

      // Assert
      expect(result.isSuccessful, true);
      expect(result.successfulData, true);
      verify(mockDioClient.put(
        '/api/hotel-owner/booking/status/2',
        queryParameters: {'status': 'CANCELLED'},
      )).called(1);
    });
  });
}
