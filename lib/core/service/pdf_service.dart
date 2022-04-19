import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/payment.dart';
import 'package:growthpad/core/model/society.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/util/assets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfService {
  static Future<void> generateInvoice({
    required Society society,
    required Member user,
    required Maintenance maintenance,
    required Payment payment,
    required void Function(bool status, String message, File? file) onResult,
  }) async {
    try {
      final pdf = Document();

      final head = await header();
      pdf.addPage(
        MultiPage(
            header: (context) => head,
            build: (context) => [
                  SizedBox(height: 24),
                  title(society),
                  payer(user),
                  SizedBox(height: 24),
                  titleText('Payment Id :', payment.id),
                  titleText('Payment Date :', DateConverter.timeToString(payment.paymentTime, output: 'dd MMM yyyy')),
                  titleText('Payment Time :', DateConverter.timeToString(payment.paymentTime, output: 'hh:mm a')),
                  titleText('Maintenance :', '${maintenance.month} ${maintenance.year}'),
                  titleText('Amount :', 'Rs. ${payment.amount}'),
                  titleText('Late Penalty :', payment.penalty ? 'Yes' : 'No'),
                ],
            footer: (context) => Text('This is a computer generated copy and does not require signature.')),
      );

      // await saveDocument(name: DateTime.now().millisecondsSinceEpoch.toString(), document: pdf);
      final file = await saveDocument(name: DateTime.now().millisecondsSinceEpoch.toString() + '.pdf', document: pdf);
      onResult(true, 'success', file);
    } catch (e) {
      Log.console('PdfService.generateInvoice.error: $e');
      onResult(false, 'Error', null);
    }
  }

  static Future<Widget> header() async {
    final ByteData bytes = await rootBundle.load(Assets.growthpadLogo);
    final Uint8List byteList = bytes.buffer.asUint8List();

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image(MemoryImage(byteList), height: 40, width: 40),
        ),
        Text(
          'Growth',
          style: TextStyle(fontSize: 26, color: const PdfColor.fromInt(0xFF19A463), fontWeight: FontWeight.bold),
        ),
        Text(
          'Pad',
          style: TextStyle(fontSize: 26, color: const PdfColor.fromInt(0xFF363E4B), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget title(Society society) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          society.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          society.address,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ]),
    );
  }

  static Widget payer(Member user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          user.name,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          '${user.block}  ${user.houseNo}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ]),
    );
  }

  static Widget titleText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
          Spacer(),
          Text(
            text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Future<File> saveDocument({required String name, required Document document}) async {
    final bytes = await document.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }
}
