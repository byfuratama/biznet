import 'package:biznet/providers/auth.dart';
import 'package:biznet/screens/installation_admin_screen.dart';
import 'package:biznet/screens/installation_tech_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstallationScreen extends StatelessWidget {
  static const routeName = '/installation-screen';

  InstallationScreen();

  final Widget title = Text('List Installation');

  @override
  Widget build(BuildContext context) {
    var pegawai = Provider.of<Auth>(context).pegawai;
    return pegawai.posisi != "Admin" ? 
      InstallationTechScreen(title: title, pegawai: pegawai)
      : InstallationAdminScreen(title: title, pegawai: pegawai);
  }
}
