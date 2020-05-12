import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pegawai.dart';
import '../providers/auth.dart';

class AvatarWUser extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<Auth>(context).userId;
    final user = Provider.of<Pegawai>(context).findByUid(uid);
    final nama = user.nama != null ? user.nama : 'Test';
    final posisi = user.posisi != null ? user.posisi : 'Admin';
    final theme = Theme.of(context);
    return Container(
      // width: double.infinity,
      height: 120,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  nama,
                  style: theme.textTheme.display2
                      .copyWith(color: Colors.white),
                ),
                Text(
                  posisi,
                  style: theme.textTheme.display1
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}