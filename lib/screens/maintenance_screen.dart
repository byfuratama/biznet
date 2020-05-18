import 'package:biznet/providers/auth.dart';
import 'package:biznet/screens/maintenance_admin_screen.dart';
import 'package:biznet/screens/maintenance_tech_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaintenanceScreen extends StatelessWidget {
  static const routeName = '/maintenance-screen';

  MaintenanceScreen();

  final Widget title = Text('List Maintenance');

  @override
  Widget build(BuildContext context) {
    var pegawai = Provider.of<Auth>(context).pegawai;
    return pegawai.posisi != "Admin" ? 
      MaintenanceTechScreen(title: title, pegawai: pegawai)
      : MaintenanceAdminScreen(title: title, pegawai: pegawai);
  }
}
