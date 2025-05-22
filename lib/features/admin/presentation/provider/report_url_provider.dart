import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common/hotel_storage_provider.dart';
import '../../../../common/network/dio_client.dart';
import '../../../../constants/api_url.dart';
import '../../../../di/injector.dart';
import 'package:open_filex/open_filex.dart';

final dioClientProvider = Provider<DioClient>((ref) => injector<DioClient>());

final reportUrlProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
    final hotelId = ref.read(hotelStorageProvider).getCurrentHotelId();
    if (hotelId == null) {
      throw Exception("No hotel selected");
    }

    final dio = ref.read(dioClientProvider);
    final response = await dio.get("${ApiUrl.baseURL}/api/report/${hotelId}/latest");

    if (response.statusCode == 200 && response.data != null) {
      final String pdfUri = response.data['pdfUri'];
      return "${ApiUrl.baseURL}/$pdfUri";
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching report: $e');
    return null;
  }
});

final pdfDownloadProvider = Provider<PdfDownloadService>((ref) {
  return PdfDownloadService();
});

class PdfDownloadService {
  final Dio _dio = Dio();

  Future<void> downloadAndOpenPdf(String url, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        onError("Không có quyền lưu file.");
        return;
      }

      final dir = Directory('/storage/emulated/0/Download');
      final filePath = "${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final response = await Dio().download(url, filePath);

      if (response.statusCode == 200) {
        onSuccess(filePath);
        await OpenFilex.open(filePath);
      } else {
        onError("Lỗi tải xuống: ${response.statusCode}");
      }
    } catch (e) {
      onError("Lỗi: ${e.toString()}");
    }
  }
}