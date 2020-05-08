import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/app_header.dart';
import '../screens/survey_screen.dart';
import '../screens/maintenance_screen.dart';
import '../screens/installation_screen.dart';
import '../screens/troubleshoot_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void selectMenu(BuildContext context, String route) {
    Navigator.of(context)
        .pushNamed(
      route,
    )
        .then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  List _searchCategories = [
    'Work Order ID',
    'Customer ID',
    'Customer Name',
    'Equipment ID',
  ];
  List<DropdownMenuItem<String>> _searchCategoryItems;
  String _currentCategory;

  @override
  void initState() {
    _searchCategoryItems = getDropDownMenuItems();
    _currentCategory = _searchCategoryItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (var i = 0; i < _searchCategories.length; i++) {
      items.add(new DropdownMenuItem(
        value: i.toString(),
        child: Text(_searchCategories[i]),
      ));
    }
    return items;
  }

  Widget createForm(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              border: Border.all(color: theme.primaryColor),
              color: Colors.white),
          child: DropdownButton(
            isExpanded: true,
            value: _currentCategory,
            items: _searchCategoryItems,
            onChanged: changeCategory,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor)),
            fillColor: Colors.white,
            filled: true,
            labelText:
                'Enter ${_searchCategories[int.parse(_currentCategory)]}',
          ),
        ),
        SizedBox(height: 10),
        RaisedButton(
          onPressed: () {},
          color: Colors.blueAccent,
          child: Text('SEARCH', style: TextStyle(color: Colors.white),),
        )
      ],
    );
  }

  void changeCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      width: double.infinity,
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppHeader('Search Category'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: createForm(context),
            ),
          ],
        ),
      ),
    );
  }
}
