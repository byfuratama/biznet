import 'package:biznet/providers/auth.dart';
import 'package:biznet/providers/pegawai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../screens/survey_screen.dart';
import '../screens/maintenance_screen.dart';
import '../screens/installation_screen.dart';
import '../screens/troubleshoot_screen.dart';
import '../screens/pegawai_screen.dart';
import '../screens/pegawai_edit_screen.dart';

class MyProfileScreen extends StatelessWidget {
  void selectMenu(BuildContext context, String route, {Object arguments}) {
    Navigator.of(context).pushNamed(route, arguments: arguments).then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  Widget createMenu(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<Auth>(context).userId;
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        // Text(user.toString()),
        if (Provider.of<Auth>(context).pegawai?.posisi == "Supervisor")
        Card(
          color: Colors.green,
          child: InkWell(
            onTap: () => selectMenu(context, PegawaiScreen.routeName),
            child: ListTile(
              leading: Icon(
                Icons.add,
                color: Colors.white,
              ),
              title: Text(
                'Tambah Pegawai',
                style: theme.textTheme.display1.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        Card(
          color: Colors.orangeAccent,
          child: InkWell(
            onTap: () =>
                selectMenu(context, PegawaiEditScreen.routeName, arguments: {
              'uid': user,
            }),
            child: ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: Text(
                'Edit My Information',
                style: theme.textTheme.display1.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        Card(
          color: Colors.red,
          child: InkWell(
            onTap: () => Provider.of<Auth>(context).logout(),
            child: ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: theme.textTheme.display1.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _loadFutures(context) async {
    await Provider.of<Pegawai>(context).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: _loadFutures(context),
      builder: (context, snapshot) => Container(
        color: theme.backgroundColor,
        width: double.infinity,
        height: 600,
        child: Column(
          children: <Widget>[
            AppHeader('My Profile'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: createMenu(context),
            ),
          ],
        ),
      ),
    );
  }
}
