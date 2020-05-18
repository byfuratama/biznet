import 'package:biznet/screens/search_result_screen.dart';
import 'package:flutter/material.dart';
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
  List _searchType = [
    'Work Order',
    'Customer',
    'Equipment',
  ];
  List<DropdownMenuItem<String>> _searchCategoryItems;
  String _currentCategory;
  List<DropdownMenuItem<String>> _searchTypeItems;
  String _currentType;

  @override
  void initState() {
    _searchCategoryItems = getCategoryMenuItems();
    _currentCategory = _searchCategoryItems[0].value;
    _searchTypeItems = getTypeMenuItems();
    _currentType = _searchTypeItems[0].value;
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> getCategoryMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (var i = 0; i < _searchCategories.length; i++) {
      items.add(new DropdownMenuItem(
        value: i.toString(),
        child: Text(_searchCategories[i]),
      ));
    }
    items.map((e) => print(e.toString()));
    return items;
  }

  List<DropdownMenuItem<String>> getTypeMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (var i = 0; i < _searchType.length; i++) {
      items.add(new DropdownMenuItem(
        value: i.toString(),
        child: Text(_searchType[i]),
      ));
    }
    return items;
  }

  void _searchResult() {
    final types = ['wo','cust','eq'];
    final cats = ['id','name'];
    Navigator.of(context).pushNamed(
      SearchResultScreen.routeName,
      arguments: {
        'search_type' : types[int.parse( _currentType)],
        'search_category' : cats[int.parse( _currentCategory)],
        'search_query' : _searchController.text
      }
    );
  }

  Widget createForm(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        ComboBox(_currentType, _searchTypeItems, changeType),
        SizedBox(height: 10),
        ComboBox(_currentCategory, _searchCategoryItems, changeCategory),
        SizedBox(height: 10),
        TextBox(
          'Enter ${_searchCategories[int.parse(_currentCategory)]}',
          _searchController,
          (String val) => _searchQuery = val,
        ),
        SizedBox(height: 10),
        RaisedButton(
          onPressed: () => _searchResult(),
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

  void changeType(String selectedType) {
    setState(() {
      _currentType = selectedType;
      if (_currentType == '0')
        _searchCategories = ["Work Order ID"];
      else if (_currentType == '1')
        _searchCategories = ["Customer ID", "Customer Name"];
      else if (_currentType == '2') _searchCategories = ["Equipment ID"];
      _searchCategoryItems.clear();
      _searchCategoryItems = getCategoryMenuItems();
      _currentCategory = _searchCategoryItems[0].value;
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
