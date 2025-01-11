import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

import '../database/table/seat_allotment_db.dart';

Future<void> generateAndSharePdf() async {
  SeatAllotment seatAllotment = SeatAllotment();
  List<Map<String, dynamic>> data = await seatAllotment.getUserData();

  final pdf = pw.Document();
  final headers = data.isNotEmpty ? data.first.keys.toList() : [];
  final rows = data.map((row) => row.values.toList()).toList();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Table.fromTextArray(
        headers: headers,
        data: rows,
        border: pw.TableBorder.all(),
        cellAlignment: pw.Alignment.center,
      ),
    ),
  );

  final outputDir = await getExternalStorageDirectory();
  final file = File('${outputDir?.path}/seat_allotment_data.pdf');

  await file.writeAsBytes(await pdf.save());

  // Convert File to XFile
  final xFile = XFile(file.path);

  // Share the PDF file
  await Share.shareXFiles([xFile], text: 'Here is the seat allotment data.');
}
