import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingScreen extends StatelessWidget {
  static const routeName = "/printing-screen";
  final arguments;

  PrintingScreen(this.arguments);

  @override
  Widget build(BuildContext context) {
    const title = 'Printing Demo';

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.print),
          onPressed: _printDocument,
        ),
      ),
    );
  }

  void _printDocument() {
    Printing.layoutPdf(
      onLayout: (pageFormat) {
        final doc = pw.Document();

        doc.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Center(
              child: pw.Text('Hello World! $arguments'),
            ),
          ),
        );

        return doc.save();
      },
    );
  }
}
