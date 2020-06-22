import 'package:biznet/providers/auth.dart';
import 'package:biznet/screens/history_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history-screen';

  HistoryScreen();

  final Widget title = Text('History');

  @override
  Widget build(BuildContext context) {
    var pegawai = Provider.of<Auth>(context).pegawai;
    return HistoryViewScreen(title: title, pegawai: pegawai);
  }
}
