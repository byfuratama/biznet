import 'package:biznet/providers/auth.dart';
import 'package:biznet/screens/survey_admin_screen.dart';
import 'package:biznet/screens/survey_tech_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveyScreen extends StatelessWidget {
  static const routeName = '/survey-screen';

  SurveyScreen();

  final Widget title = Text('List Survey');

  @override
  Widget build(BuildContext context) {
    var pegawai = Provider.of<Auth>(context).pegawai;
    return pegawai.posisi != "Admin" ? 
      SurveyTechScreen(title: title, pegawai: pegawai)
      : SurveyAdminScreen(title: title, pegawai: pegawai);
  }
}
