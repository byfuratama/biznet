import 'package:flutter/material.dart';

class InstallationScreen extends StatelessWidget {
  static const routeName = '/installation-screen';
  final Color color = Colors.blue;

  InstallationScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Open"),
                Tab(text: "Closed"),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
