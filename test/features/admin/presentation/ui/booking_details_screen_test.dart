import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/model/booking_details_dto.dart';
import 'package:hotel_app/features/admin/model/user_dto.dart';
import 'package:hotel_app/features/admin/presentation/ui/booking_details_screen.dart';

import 'booking_details_screen_test.mocks.dart';

@GenerateMocks([HotelRepository])
void main() {
  group('BookingDetailsScreen', () {
    late MockHotelRepository mockRepository;

    setUp(() {
      mockRepository = MockHotelRepository();
    });

    Widget createWidgetUnderTest(int bookingId) {
      return ProviderScope(
        overrides: [
          hotelOwnerRepository.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: BookingDetailsScreen(id: bookingId),
        ),
      );
    }

    testWidgets('should display loading indicator initially', (tester) async {
      // Arrange
      const bookingId = 1;
      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => Future.delayed(Duration(seconds: 1)));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display booking details when loaded successfully', (tester) async {
      // Arrange
      const bookingId = 1;
      final bookingDetails = BookingDetailsDto(
        bookingId: bookingId,
        checkIn: DateTime.now().add(Duration(days: 1)),
        checkOut: DateTime.now().add(Duration(days: 2)),
        price: 1000.0,
        status: "PENDING",
        user: UserDto(
          userId: 1,
          fullName: "Test User",
          email: "test@example.com",
          phone: "0123456789",
        ),
        roomName: "Test Room",
        bill: null,
        createdAt: DateTime.now(),
        reviewIdList: [],
      );

      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => BaseResponse(
        isSuccessful: true,
        successfulData: bookingDetails,
      ));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('#$bookingId'), findsOneWidget);
      expect(find.text('Test Room'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('0123456789'), findsOneWidget);
    });

    testWidgets('should show action buttons for PENDING booking', (tester) async {
      // Arrange
      const bookingId = 1;
      final bookingDetails = BookingDetailsDto(
        bookingId: bookingId,
        checkIn: DateTime.now().add(Duration(days: 1)),
        checkOut: DateTime.now().add(Duration(days: 2)),
        price: 1000.0,
        status: "PENDING",
        user: UserDto(
          userId: 1,
          fullName: "Test User",
          email: "test@example.com",
          phone: "0123456789",
        ),
        roomName: "Test Room",
        bill: null,
        createdAt: DateTime.now(),
        reviewIdList: [],
      );

      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => BaseResponse(
        isSuccessful: true,
        successfulData: bookingDetails,
      ));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Từ chối đặt phòng'), findsOneWidget);
      expect(find.text('Chấp nhận đặt phòng'), findsOneWidget);
    });

    testWidgets('should not show action buttons for CONFIRMED booking', (tester) async {
      // Arrange
      const bookingId = 1;
      final bookingDetails = BookingDetailsDto(
        bookingId: bookingId,
        checkIn: DateTime.now().add(Duration(days: 1)),
        checkOut: DateTime.now().add(Duration(days: 2)),
        price: 1000.0,
        status: "CONFIRMED",
        user: UserDto(
          userId: 1,
          fullName: "Test User",
          email: "test@example.com",
          phone: "0123456789",
        ),
        roomName: "Test Room",
        bill: null,
        createdAt: DateTime.now(),
        reviewIdList: [],
      );

      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => BaseResponse(
        isSuccessful: true,
        successfulData: bookingDetails,
      ));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Từ chối đặt phòng'), findsNothing);
      expect(find.text('Chấp nhận đặt phòng'), findsNothing);
      expect(find.text('Đặt phòng đã được xác nhận'), findsOneWidget);
    });

    testWidgets('should show confirmation dialog when tapping accept button', (tester) async {
      // Arrange
      const bookingId = 1;
      final bookingDetails = BookingDetailsDto(
        bookingId: bookingId,
        checkIn: DateTime.now().add(Duration(days: 1)),
        checkOut: DateTime.now().add(Duration(days: 2)),
        price: 1000.0,
        status: "PENDING",
        user: UserDto(
          userId: 1,
          fullName: "Test User",
          email: "test@example.com",
          phone: "0123456789",
        ),
        roomName: "Test Room",
        bill: null,
        createdAt: DateTime.now(),
        reviewIdList: [],
      );

      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => BaseResponse(
        isSuccessful: true,
        successfulData: bookingDetails,
      ));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chấp nhận đặt phòng'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Xác nhận chấp nhận đặt phòng'), findsOneWidget);
      expect(find.text('Bạn có chắc muốn chấp nhận đặt phòng này không?'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.text('Đồng ý'), findsOneWidget);
    });

    testWidgets('should show confirmation dialog when tapping reject button', (tester) async {
      // Arrange
      const bookingId = 1;
      final bookingDetails = BookingDetailsDto(
        bookingId: bookingId,
        checkIn: DateTime.now().add(Duration(days: 1)),
        checkOut: DateTime.now().add(Duration(days: 2)),
        price: 1000.0,
        status: "PENDING",
        user: UserDto(
          userId: 1,
          fullName: "Test User",
          email: "test@example.com",
          phone: "0123456789",
        ),
        roomName: "Test Room",
        bill: null,
        createdAt: DateTime.now(),
        reviewIdList: [],
      );

      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => BaseResponse(
        isSuccessful: true,
        successfulData: bookingDetails,
      ));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Từ chối đặt phòng'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Xác nhận từ chối đặt phòng'), findsOneWidget);
      expect(find.text('Bạn có chắc muốn từ chối đặt phòng này không?'), findsOneWidget);
    });

    testWidgets('should display error message when loading fails', (tester) async {
      // Arrange
      const bookingId = 1;
      const errorMessage = "Failed to load booking details";

      when(mockRepository.getBookingDetails(bookingId))
          .thenAnswer((_) async => BaseResponse(
        isSuccessful: false,
        errorMessage: errorMessage,
      ));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(bookingId));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Lỗi: $errorMessage'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });
  });
}