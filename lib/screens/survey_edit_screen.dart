import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/utilities.dart';
import '../providers/survey.dart';
import '../providers/customer.dart';
import '../providers/equipment.dart';

class SurveyEditScreen extends StatefulWidget {
  static const routeName = '/survey-edit-screen';
  final dataId;

  SurveyEditScreen(this.dataId);

  @override
  _SurveyEditScreenState createState() => _SurveyEditScreenState();
}

class _SurveyEditScreenState extends State<SurveyEditScreen> {
  final _form = GlobalKey<FormState>();
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
    'status_list': ['On Net', 'Off Net'],
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
  SurveyItem _editedItem;

  @override
  void initState() {
    _paketList = getDropDownMenuItems('paket_list', 'Paket');
    _formData['cust_paket'] = _paketList[0].value;
    _statusList = getDropDownMenuItems('status_list', 'Status');
    _formData['surv_status'] = _statusList[0].value;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final String id = widget.dataId;
    if (id != null && id != '') {
      SurveyItem svItem = Provider.of<Survey>(context, listen: false).findById(id);
      CustomerItem custItem = Provider.of<Customer>(context, listen: false).findById(svItem.customer);
      EquipmentItem eqItem = Provider.of<Equipment>(context, listen: false).findById(svItem.equipment);
      _formData['cust_nama'] = custItem.nama;
      _formData['cust_nohp'] = custItem.nohp;
      _formData['cust_alamat'] = custItem.alamat;
      _formData['cust_email'] = custItem.email;
      _formData['cust_paket'] = custItem.paket;
      _formData['eq_cable'] = eqItem.cable;
      _formData['eq_closure'] = eqItem.closure;
      _formData['eq_pigtail'] = eqItem.pigtail;
      _formData['eq_splicer'] = eqItem.splicer;
      _formData['eq_ont'] = eqItem.ont;
      _formData['surv_status'] = svItem.status;
    }
    super.didChangeDependencies();
  }

  bool _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    final id = widget.dataId;
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    CustomerItem custItem = CustomerItem(
      nama: _formData['cust_nama'],
      nohp: _formData['cust_nohp'],
      alamat: _formData['cust_alamat'],
      email: _formData['cust_email'],
      paket: _formData['cust_paket'],
    );
    EquipmentItem eqItem = EquipmentItem(
      cable: _formData['eq_cable'],
      closure: _formData['eq_closure'],
      pigtail: _formData['eq_pigtail'],
      splicer: _formData['eq_splicer'],
      ont: _formData['eq_ont'],
    );
    if (id != null && id != '') {
      try {
        await Provider.of<Customer>(context, listen: false).addItem(custItem);
        await Provider.of<Equipment>(context, listen: false).addItem(eqItem);
        var cust = Provider.of<Customer>(context, listen: false).findLast();
        var eq = Provider.of<Equipment>(context, listen: false).findLast();
        SurveyItem svItem = SurveyItem(
          customer: cust.id,
          equipment: eq.id,
          status: _formData['surv_status'],
        );
        await Provider.of<Survey>(context, listen: false).updateItem(id, svItem);
      } catch (error) {

      }
    } else {
      try {
        await Provider.of<Customer>(context, listen: false).addItem(custItem);
        await Provider.of<Equipment>(context, listen: false).addItem(eqItem);
        var cust = Provider.of<Customer>(context, listen: false).findLast();
        var eq = Provider.of<Equipment>(context, listen: false).findLast();
        SurveyItem svItem = SurveyItem(
          customer: cust.id,
          equipment: eq.id,
          status: _formData['surv_status'],
        );
        await Provider.of<Survey>(context, listen: false).addItem(svItem);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
            onPressed: _saveForm,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    FormTextBox("Nama Customer", _formData['cust_nama'],
                        (val) => _formData['cust_nama'] = val),
                    SizedBox(height: 5),
                    FormTextBox("No HP", _formData['cust_nohp'],
                        (val) => _formData['cust_nohp'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Alamat", _formData['cust_alamat'],
                        (val) => _formData['cust_alamat'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Email", _formData['cust_email'],
                        (val) => _formData['cust_email'] = val),
                    SizedBox(height: 5),
                    ComboBox(_formData['cust_paket'], _paketList,
                        (val) => changeItem(val, 'cust_paket')),
                    SizedBox(height: 25),
                    FormTextBox("Kabel", _formData['eq_cable'],
                        (val) => _formData['eq_cable'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Closure", _formData['eq_closure'],
                        (val) => _formData['eq_closure'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Pigtail", _formData['eq_pigtail'],
                        (val) => _formData['eq_pigtail'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Splicer", _formData['eq_splicer'],
                        (val) => _formData['eq_splicer'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Ont", _formData['eq_ont'],
                        (val) => _formData['eq_ont'] = val),
                    SizedBox(height: 25),
                    ComboBox(_formData['surv_status'], _statusList,
                        (val) => changeItem(val, 'surv_status')),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Stack(
              children: [
                new Opacity(
                  opacity: 0.3,
                  child: ModalBarrier(dismissible: false, color: Colors.grey),
                ),
                new Center(
                  child: new CircularProgressIndicator(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
