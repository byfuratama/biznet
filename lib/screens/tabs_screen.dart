import 'package:flutter/material.dart';
import './dummy_screen.dart';
import './home_screen.dart';
import './report_screen.dart';
import './my_profile_screen.dart';
import './search_screen.dart';

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
      },
      {
        'page': ReportScreen(),
        'title': 'Report',
        'icon': Icons.receipt,
      },
      {
        'page': SearchScreen(),
        'title': 'Search',
        'icon': Icons.search,
      },
      {
        'page': MyProfileScreen(),
        'title': 'My Profile',
        'icon': Icons.person,
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      // drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: _pages
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
