import 'package:flutter/material.dart';
import '../widgets/utilities.dart';

class SurveyEditScreen extends StatefulWidget {
  static const routeName = '/survey-edit-screen';
  final dataId;

  SurveyEditScreen(this.dataId);

  @override
  _SurveyEditScreenState createState() => _SurveyEditScreenState();
}

class _SurveyEditScreenState extends State<SurveyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {
    'cust_nama': '',
    'cust_nohp': '',
    'cust_alamat': '',
    'cust_email': '',
    'cust_paket': '',
    'eq_cable': '',
    'eq_closure': '',
    'eq_pigtail': '',
    'eq_splicer': '',
    'eq_ont': '',
    'surv_status': '',
  };

  Map<String, List> _items = {
    'paket_list': ['Home', 'Metronet', 'Dedicated', 'Hospitality'],
    'status_list': ['Open Net', 'Off Net'],
  };

  void changeItem(String selectedItems, String fd) {
    setState(() {
      _formData[fd] = selectedItems;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(
      String list, String append) {
    List<DropdownMenuItem<String>> items = new List();
    for (var i = 0; i < _items[list].length; i++) {
      items.add(new DropdownMenuItem(
        value: _items[list][i],
        child: Text('$append ${_items[list][i]}'),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _paketList;
  List<DropdownMenuItem<String>> _statusList;

  @override
  void initState() {
    _paketList = getDropDownMenuItems('paket_list', 'Paket');
    _formData['cust_paket'] = _paketList[0].value;
    _statusList = getDropDownMenuItems('status_list', 'Status');
    _formData['surv_status'] = _statusList[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.dataId != '' ? "Edit Survey" : "New Survey";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _formKey.currentState.save();
                print(_formData);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormTextBox(
                    "Nama Customer", (val) => _formData['cust_nama'] = val),
                SizedBox(height: 5),
                FormTextBox("No HP", (val) => _formData['cust_nohp'] = val),
                SizedBox(height: 5),
                FormTextBox("Alamat", (val) => _formData['cust_alamat'] = val),
                SizedBox(height: 5),
                FormTextBox("Email", (val) => _formData['cust_email'] = val),
                SizedBox(height: 5),
                ComboBox(_formData['cust_paket'], _paketList,
                    (val) => changeItem(val, 'cust_paket')),
                SizedBox(height: 25),
                FormTextBox("Kabel", (val) => _formData['eq_cable'] = val),
                SizedBox(height: 5),
                FormTextBox("Closure", (val) => _formData['eq_closure'] = val),
                SizedBox(height: 5),
                FormTextBox("Pigtail", (val) => _formData['eq_pigtail'] = val),
                SizedBox(height: 5),
                FormTextBox("Splicer", (val) => _formData['eq_splicer'] = val),
                SizedBox(height: 5),
                FormTextBox("Ont", (val) => _formData['eq_ont'] = val),
                SizedBox(height: 25),
                ComboBox(_formData['surv_status'], _statusList,
                    (val) => changeItem(val, 'surv_status')),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
