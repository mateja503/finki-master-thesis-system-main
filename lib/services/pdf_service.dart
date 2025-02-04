import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfService {
  static Future<void> downloadAndOpenPdf(String fileName) async {
    try {
      // Get PDF from assets
      final ByteData data = await rootBundle.load('assets/pdfs/$fileName');

      // Get temporary directory
      // final tempDir = await getTemporaryDirectory();
      // final tempPath = '${tempDir.path}/$fileName';
      final directory = await getApplicationDocumentsDirectory();
      final tempPath = '${directory.path}/$fileName';

      // Write to temporary file
      final file = File(tempPath);
      await file.writeAsBytes(data.buffer.asUint8List());

      // Open PDF
      await OpenFile.open(tempPath);
    } catch (e) {
      print('Error opening PDF: $e');
      rethrow;
    }
  }
}
