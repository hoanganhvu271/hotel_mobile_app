import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/app_colors.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const TopAppBar(title: "Báo cáo 3/2025"),
            const SizedBox(height: 10),
            const Expanded(
              child: ReadPDFWidget(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: CustomFilledButton(
                title: "Tải xuống PDF",
                backgroundColor: ColorsLib.primaryColor,
              ),
            ),
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
    this.url = "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
  });

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(url);
  }
}
