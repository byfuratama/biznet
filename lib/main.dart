import 'package:biznet/screens/printing_screen.dart';
import 'package:biznet/screens/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/login_screen.dart';
import './screens/tabs_screen.dart';
import './screens/dummy_screen.dart';

import './screens/survey_screen.dart';
import './screens/maintenance_screen.dart';
import './screens/installation_screen.dart';
import './screens/troubleshoot_screen.dart';
import './screens/survey_report_screen.dart';
import './screens/maintenance_report_screen.dart';
import './screens/installation_report_screen.dart';
import './screens/troubleshoot_report_screen.dart';
import './screens/pegawai_screen.dart';

import './screens/survey_edit_screen.dart';
import './screens/installation_edit_screen.dart';
import './screens/troubleshoot_edit_screen.dart';
import './screens/maintenance_edit_screen.dart';
import './screens/pegawai_edit_screen.dart';

import 'package:intl/intl.dart';

import './providers/auth.dart';
import './providers/survey.dart';
import './providers/customer.dart';
import './providers/equipment.dart';
import './providers/work_order.dart';
import './providers/pegawai.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Intl.defaultLocale = 'id-ID';
    initializeDateFormatting('id-ID', null);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Survey(),
        ),
        ChangeNotifierProvider.value(
          value: Customer(),
        ),
        ChangeNotifierProvider.value(
          value: Equipment(),
        ),
        ChangeNotifierProvider.value(
          value: WorkOrder(),
        ),
        ChangeNotifierProvider.value(
          value: Pegawai(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            primaryColor: Color.fromARGB(255, 0, 0, 125),
            cardColor: Color.fromARGB(125, 111, 111, 255),
            backgroundColor: Color.fromARGB(30, 0, 0, 255),
            accentColor: Colors.white,
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                  display1: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  display2: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
          ),
          onGenerateRoute: (settings) {
            final args = settings.arguments as Map;
            var routes = <String, WidgetBuilder>{
              SurveyEditScreen.routeName: (ctx) => SurveyEditScreen(settings.arguments),
              PegawaiEditScreen.routeName: (ctx) => PegawaiEditScreen(settings.arguments),
              InstallationEditScreen.routeName: (ctx) => InstallationEditScreen(settings.arguments),
              MaintenanceEditScreen.routeName: (ctx) => MaintenanceEditScreen(settings.arguments),
              TroubleshootEditScreen.routeName: (ctx) => TroubleshootEditScreen(settings.arguments),
              SearchResultScreen.routeName: (ctx) => SearchResultScreen(
                searchCategory: args['search_category'],
                searchType: args['search_type'],
                searchQuery: args['search_query'],
              ),
              PrintingScreen.routeName: (ctx) => PrintingScreen(settings.arguments),
            };
            WidgetBuilder builder = routes[settings.name];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
          home: auth.isAuth ? TabsScreen() : LoginScreen(),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),

            SurveyScreen.routeName: (ctx) => SurveyScreen(),
            TroubleshootScreen.routeName: (ctx) => TroubleshootScreen(),
            InstallationScreen.routeName: (ctx) => InstallationScreen(),
            MaintenanceScreen.routeName: (ctx) => MaintenanceScreen(),
            PegawaiScreen.routeName: (ctx) => PegawaiScreen(),

            SurveyReportScreen.routeName: (ctx) => SurveyReportScreen(),
            TroubleshootReportScreen.routeName: (ctx) =>
                TroubleshootReportScreen(),
            InstallationReportScreen.routeName: (ctx) =>
                InstallationReportScreen(),
            MaintenanceReportScreen.routeName: (ctx) =>
                MaintenanceReportScreen(),
            // OrdersScreen.routeName: (ctx) => OrdersScreen(),
            // UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            // EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
