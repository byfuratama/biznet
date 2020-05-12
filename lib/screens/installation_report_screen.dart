import 'package:flutter/material.dart';

class InstallationReportScreen extends StatelessWidget {
  static const routeName = '/installation-report-screen';
  final Color color = Colors.blue;

  final List<Map<String, Object>> dummy = [{}];

  InstallationReportScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Open Order"),
                Tab(text: "Closed Order"),
              ],
            ),
            title: Text('Installation Work Order List Report'),
            backgroundColor: theme.primaryColor,
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(index.toString()),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('<NAMA>'),
                          Text('<No Order>'),
                          Text('<Alamat>'),
                          Text('<Tanggal Jam>'),
                        ],
                      ),
                      trailing: Chip(
                        backgroundColor: Colors.red,
                        label: Text(
                          'High',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 15,
              ),
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(index.toString()),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('<NAMA>'),
                          Text('<No Order>'),
                          Text('<Alamat>'),
                          Text('<Tanggal Jam>'),
                        ],
                      ),
                      trailing: Chip(
                        backgroundColor: Colors.amber,
                        label: Text(
                          'Medium',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 15,
              ),
            ],
          ),
        ));
  }
}

