import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/hotel_storage_provider.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../constants/app_colors.dart';
import '../provider/report_url_provider.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportUrlAsync = ref.watch(reportUrlProvider);
    final downloader = ref.watch(pdfDownloadProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const TopAppBar(title: "Báo cáo PDF"),
            const SizedBox(height: 10),
            Expanded(
              child: reportUrlAsync.when(
                data: (url) {
                  if (url == null) {
                    return const Center(
                      child: Text(
                        "Không có báo cáo nào. Vui lòng thử lại sau.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ReadPDFWidget(url: url);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    "Lỗi khi tải báo cáo: ${error.toString()}",
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: reportUrlAsync.maybeWhen(
                data: (url) => url != null ? CustomFilledButton(
                  title: "Tải xuống",
                  backgroundColor: ColorsLib.primaryColor,
                  onTap: () async {
                    try {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đang tải xuống báo cáo...")),
                      );
                      await downloader.downloadAndOpenPdf(
                        url,
                        onSuccess: (path) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Tải xuống thành công: $path")),
                          );
                        },
                        onError: (errorMessage) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Lỗi khi tải xuống: $errorMessage")),
                          );
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lỗi không xác định: ${e.toString()}")),
                      );
                    }
                  },
                ) : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReadPDFWidget extends StatelessWidget {
  final String url;

  const ReadPDFWidget({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(
      url,
      onDocumentLoadFailed: (details) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi tải PDF: ${details.error}")),
        );
      },
    );
  }
}