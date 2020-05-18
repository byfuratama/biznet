import 'package:biznet/providers/auth.dart';
import 'package:biznet/screens/troubleshoot_admin_screen.dart';
import 'package:biznet/screens/troubleshoot_tech_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TroubleshootScreen extends StatelessWidget {
  static const routeName = '/troubleshoot-screen';

  TroubleshootScreen();

  final Widget title = Text('List Troubleshoot');

  @override
  Widget build(BuildContext context) {
    var pegawai = Provider.of<Auth>(context).pegawai;
    return pegawai.posisi != "Admin" ? 
      TroubleshootTechScreen(title: title, pegawai: pegawai)
      : TroubleshootAdminScreen(title: title, pegawai: pegawai);
  }
}
