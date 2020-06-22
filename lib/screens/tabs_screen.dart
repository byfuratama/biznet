import 'package:biznet/providers/auth.dart';
import 'package:biznet/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './dummy_screen.dart';
import './home_screen.dart';
import './report_screen.dart';
import './my_profile_screen.dart';
import './search_screen.dart';

import '../providers/pegawai.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': HomeScreen(),
        'title': 'Home',
        'icon': Icons.home,
        'hide_if' : [],
      },
      {
        'page': ReportScreen(),
        'title': 'Report',
        'icon': Icons.receipt,
        'hide_if' : ['Sales'],
      },
      {
        'page': SearchScreen(),
        'title': 'Search',
        'icon': Icons.search,
        'hide_if' : [],
      },
      {
        'page': MyProfileScreen(),
        'title': 'My Profile',
        'icon': Icons.person,
        'hide_if' : [],
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  List<Map<String, Object>> get getPages {
    var pegawai = Provider.of<Auth>(context).pegawai?.posisi;
    return _pages.where((f) => (f['hide_if'] as List).contains(pegawai) == false).toList();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Pegawai>(context).fetchAndSet();
    return Scaffold(
      appBar: AppBar(
        title: Text(getPages[_selectedPageIndex]['title']),
      ),
      // drawer: MainDrawer(),
      body: getPages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: getPages
            .map(
              (page) => BottomNavigationBarItem(
                backgroundColor: Theme.of(context).accentColor,
                icon: Icon(page['icon']),
                title: Text(page['title']),
              ),
            )
            .toList(),
      ),
    );
  }
}
