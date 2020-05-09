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

import './screens/survey_edit_screen.dart';

import 'package:intl/intl.dart';

import './providers/auth.dart';
// import './providers/products.dart';
// import './providers/cart.dart';
// import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Intl.defaultLocale = 'id-ID';
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            primaryColor: Color.fromARGB(255, 0, 0, 125),
            cardColor: Color.fromARGB(255, 0, 0, 250),
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
            var routes = <String, WidgetBuilder>{
              SurveyEditScreen.routeName: (ctx) => SurveyEditScreen(settings.arguments),
            };
            WidgetBuilder builder = routes[settings.name];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
          home: !auth.isAuth ? TabsScreen() : LoginScreen(),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),

            SurveyScreen.routeName: (ctx) => SurveyScreen(),
            TroubleshootScreen.routeName: (ctx) => TroubleshootScreen(),
            InstallationScreen.routeName: (ctx) => InstallationScreen(),
            MaintenanceScreen.routeName: (ctx) => MaintenanceScreen(),

            // SurveyEditScreen.routeName: (ctx) => SurveyEditScreen(),

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
