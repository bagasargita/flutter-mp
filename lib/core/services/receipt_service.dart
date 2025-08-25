import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptService {
  static Future<File?> generateReceiptPDF({
    required String reference,
    required String total,
    required String date,
    required String time,
    required String location,
    required String name,
    required String transactionType,
    required List<Map<String, String>> denominations,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                pw.SizedBox(height: 20),
                _buildTransactionInfo(
                  reference: reference,
                  total: total,
                  date: date,
                  time: time,
                  location: location,
                  name: name,
                  transactionType: transactionType,
                ),
                pw.SizedBox(height: 20),
                _buildDenominationTable(denominations),
                pw.SizedBox(height: 20),
                _buildFooter(),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/receipt_$reference.pdf');
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Container(
          width: 60,
          height: 60,
          decoration: pw.BoxDecoration(
            color: PdfColors.red,
            borderRadius: pw.BorderRadius.circular(30),
          ),
          child: pw.Center(
            child: pw.Text(
              'MP',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Text(
          'MerahPutih',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTransactionInfo({
    required String reference,
    required String total,
    required String date,
    required String time,
    required String location,
    required String name,
    required String transactionType,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Reference', reference),
          _buildInfoRow('Total', total),
          _buildInfoRow('Date', date),
          _buildInfoRow('Time', time),
          _buildInfoRow('Location', location),
          _buildInfoRow('Name', name),
          _buildInfoRow('Transaction', transactionType),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(color: PdfColors.black)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDenominationTable(
    List<Map<String, String>> denominations,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Denomination Breakdown',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Denom',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Quantity',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Total',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...denominations.map(
                (denom) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(denom['denom'] ?? ''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(denom['quantity'] ?? ''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(denom['total'] ?? ''),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      child: pw.Text(
        'This receipt serves as valid proof of transaction',
        style: pw.TextStyle(
          fontSize: 12,
          fontStyle: pw.FontStyle.italic,
          color: PdfColors.grey,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static Future<void> shareReceipt({
    required String reference,
    required String total,
    required String date,
    required String time,
    required String location,
    required String name,
    required String transactionType,
    required List<Map<String, String>> denominations,
  }) async {
    try {
      final pdfFile = await generateReceiptPDF(
        reference: reference,
        total: total,
        date: date,
        time: time,
        location: location,
        name: name,
        transactionType: transactionType,
        denominations: denominations,
      );

      if (pdfFile != null && await pdfFile.exists()) {
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          text:
              'Receipt from MerahPutih\nReference: $reference\nTotal: $total\nDate: $date $time',
          subject: 'Transaction Receipt - $reference',
        );
      } else {
        throw Exception('Failed to generate PDF file');
      }
    } catch (e) {
      print('Error sharing receipt: $e');
      await _shareReceiptAsText(
        reference: reference,
        total: total,
        date: date,
        time: time,
        location: location,
        name: name,
        transactionType: transactionType,
        denominations: denominations,
      );
    }
  }

  static Future<void> _shareReceiptAsText({
    required String reference,
    required String total,
    required String date,
    required String time,
    required String location,
    required String name,
    required String transactionType,
    required List<Map<String, String>> denominations,
  }) async {
    try {
      final totalAmount = denominations.fold<int>(
        0,
        (sum, denom) => sum + int.parse(denom['total']!.replaceAll('.', '')),
      );

      final text =
          '''
Receipt from MerahPutih

Reference: $reference
Total: $total
Date: $date $time
Location: $location
Name: $name
Transaction Type: $transactionType

Denomination Breakdown:
${denominations.map((d) => '${d['denom']}: ${d['quantity']} x ${d['total']}').join('\n')}

Total Amount: Rp ${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}
''';

      await Share.share(text, subject: 'Transaction Receipt - $reference');
    } catch (e) {
      print('Error sharing receipt as text: $e');
      rethrow;
    }
  }

  static Future<void> shareReceiptSimple({
    required String reference,
    required String total,
    required String date,
    required String time,
    required String location,
    required String name,
    required String transactionType,
    required List<Map<String, String>> denominations,
  }) async {
    try {
      final totalAmount = denominations.fold<int>(
        0,
        (sum, denom) => sum + int.parse(denom['total']!.replaceAll('.', '')),
      );

      final text =
          '''
Receipt from MerahPutih

Reference: $reference
Total: $total
Date: $date $time
Location: $location
Name: $name
Transaction Type: $transactionType

Denomination Breakdown:
${denominations.map((d) => '${d['denom']}: ${d['quantity']} x ${d['total']}').join('\n')}

Total Amount: Rp ${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}
''';

      await Share.share(text, subject: 'Transaction Receipt - $reference');
    } catch (e) {
      print('Error sharing receipt: $e');
      rethrow;
    }
  }

  static Future<void> shareReceiptImage(ui.Image image) async {
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/receipt_image.png');
        await file.writeAsBytes(bytes.buffer.asUint8List());

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Receipt image from MerahPutih',
          subject: 'Transaction Receipt Image',
        );
      }
    } catch (e) {
      print('Error sharing receipt image: $e');
      rethrow;
    }
  }
}
