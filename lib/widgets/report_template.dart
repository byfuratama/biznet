/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// ignore_for_file: always_specify_types

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateDocument(PdfPageFormat format) async {
  final pw.Document doc = pw.Document();

  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: <pw.Widget>[
                  pw.Text('Laporan ', textScaleFactor: 3),
                  pw.Text('Tanggal ', textScaleFactor: 1.25),
                ])),
            pw.Table.fromTextArray(context: context, data: const <List<String>>[
              <String>['Date', 'PDF Version', 'Acrobat Version'],
              <String>['1993', 'PDF 1.0', 'Acrobat 1'],
              <String>['1994', 'PDF 1.1', 'Acrobat 2'],
              <String>['1996', 'PDF 1.2', 'Acrobat 3'],
              <String>['1999', 'PDF 1.3', 'Acrobat 4'],
              <String>['2001', 'PDF 1.4', 'Acrobat 5'],
              <String>['2003', 'PDF 1.5', 'Acrobat 6'],
              <String>['2005', 'PDF 1.6', 'Acrobat 7'],
              <String>['2006', 'PDF 1.7', 'Acrobat 8'],
              <String>['2008', 'PDF 1.7', 'Acrobat 9'],
              <String>['2009', 'PDF 1.7', 'Acrobat 9.1'],
              <String>['2010', 'PDF 1.7', 'Acrobat X'],
              <String>['2012', 'PDF 1.7', 'Acrobat XI'],
              <String>['2017', 'PDF 2.0', 'Acrobat DC'],
            ]),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));

  return doc.save();
}
