import 'package:flutter/material.dart';
import 'dart:convert';

import '../widgets/app_header.dart';
import '../widgets/utilities.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController;
  String _searchQuery;

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
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        ComboBox(_currentCategory, _searchCategoryItems, changeCategory),
        SizedBox(height: 10),
        TextBox(
          'Enter ${_searchCategories[int.parse(_currentCategory)]}',
          _searchController,
          (String val) => _searchQuery = val,
        ),
        SizedBox(height: 10),
        RaisedButton(
          onPressed: () => print(_searchQuery),
          color: Colors.blueAccent,
          child: Text(
            'SEARCH',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  void changeCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
      _searchController.text = '';
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
