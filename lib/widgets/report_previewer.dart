import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// import 'calendar.dart';
// import 'document.dart';
// import 'invoice.dart';
// import 'report.dart';
// import 'resume.dart';

class ReportPreviewer extends StatefulWidget {
  final reportTitle;
  final reportDateTitle;
  final reportFilter;
  final reportColumn;
  final datePicker;

  ReportPreviewer({
    this.reportTitle = 'Laporan',
    this.reportDateTitle = '<Tanggal>',
    @required this.reportFilter,
    @required this.reportColumn,
    @required this.datePicker,
  });

  @override
  ReportPreviewerState createState() {
    return ReportPreviewerState();
  }
}

class ReportPreviewerState extends State<ReportPreviewer> with SingleTickerProviderStateMixin {
  PrintingInfo printingInfo;
  var _filterDate = DateTime.now();
  var _reportBuilder;

  @override
  void initState() {
    super.initState();
    _reportBuilder = _generateDocument;
    _init();
  }

  Future<void> _init() async {
    final PrintingInfo info = await Printing.info();

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final Uint8List bytes = await build(pageFormat);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  }

  String get _getTitle {
    return widget.reportDateTitle(_filterDate);
  }

  List get _items {
    return widget.reportFilter(_filterDate);
  }

  List<List<String>> _drawPDF() {
    print(_items);
    return <List<String>>[
      <String>[...widget.reportColumn],
      ..._items.map((e) => <String>[...e]),
    ];
  }

  Function get _changeDate {
    return (newDate) {
      setState(() {
        _reportBuilder = null;
        _filterDate = newDate;
      });
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        setState(() {
          _reportBuilder = _generateDocument;
        });
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(_getTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.date_range,
                color: Theme.of(context).accentColor,
              ),
              onPressed: widget.datePicker(_changeDate, _filterDate),
            )
          ],
        ),
        body: _reportBuilder != null
            ? PdfPreview(
                allowSharing: false,
                maxPageWidth: 700,
                build: _reportBuilder,
                actions: actions,
                onPrinted: _showPrintedToast,
                onShared: _showSharedToast,
              )
            : null);
  }

  Future<Uint8List> _generateDocument(PdfPageFormat format) async {
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
                    pw.Text(widget.reportTitle, textScaleFactor: 2),
                    pw.Text(_getTitle, textScaleFactor: 1.25),
                  ])),
              pw.Table.fromTextArray(context: context, data: _drawPDF()),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
            ]));

    return doc.save();
  }
}
