import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/utilities.dart';
import '../providers/survey.dart';
import '../providers/customer.dart';
import '../providers/equipment.dart';
import '../providers/pegawai.dart';
import '../providers/auth.dart';
import '../providers/work_order.dart';

class TroubleshootEditScreen extends StatefulWidget {
  static const routeName = '/troubleshoot-edit-screen';
  final dataId;

  TroubleshootEditScreen(this.dataId);

  @override
  _TroubleshootEditScreenState createState() => _TroubleshootEditScreenState();
}

class _TroubleshootEditScreenState extends State<TroubleshootEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {
    'wo_jenis': 'Troubleshoot',
    'wo_status': 'Open',
    'wo_level': '',
    'wo_create_date': '',
    'wo_close_date': '',
    'wo_kode_dp': '',
    'wo_kendala': '',
    'wo_password': '',
    'survey': '',
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
    'teknisi': '',
    'admin': '',
    'customer': '',
  };

  Map<String, TextEditingController> _formControllers;

  Map<String, List> _items = {
    'level_list': ['Urgent', 'High', 'Low'],
    'status_list': ['Open', 'Close'],
    'customer_list': [''],
    'equipment_list': [''],
    'survey_list': [''],
    'pegawai_list': [''],
  };

  void changeItem(String selectedItems, String fd) {
    setState(() {
      _formData[fd] = selectedItems;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(
      String list, String append,
      {Function label}) {
    List<DropdownMenuItem<String>> items = new List();
    for (var i = 0; i < _items[list].length; i++) {
      final itemVal =
          _items[list][i] is String ? _items[list][i] : _items[list][i].id;
      final itemLabel =
          _items[list][i] is String ? _items[list][i] : label(_items[list][i]);
      items.add(new DropdownMenuItem(
        value: itemVal,
        child: Text('$append $itemLabel'),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _levelList;
  List<DropdownMenuItem<String>> _statusList;
  List<DropdownMenuItem<String>> _customerList;
  List<DropdownMenuItem<String>> _equipmentList;
  List<DropdownMenuItem<String>> _surveyList;
  List<DropdownMenuItem<String>> _pegawaiList;

  @override
  void initState() {
    _levelList = getDropDownMenuItems('level_list', 'Level');
    _formData['wo_level'] = _levelList[0].value;
    _statusList = getDropDownMenuItems('status_list', 'Status');
    _formData['wo_status'] = _statusList[0].value;
    _formControllers = {
      'wo_kode_dp': TextEditingController(),
      'wo_create_date': TextEditingController(),
      'wo_close_date': TextEditingController(),
      'wo_kendala': TextEditingController(),
      'wo_password': TextEditingController(),
      'cust_nama': TextEditingController(),
      'cust_nohp': TextEditingController(),
      'cust_alamat': TextEditingController(),
      'cust_email': TextEditingController(),
      'cust_paket': TextEditingController(),
      'eq_cable': TextEditingController(),
      'eq_closure': TextEditingController(),
      'eq_pigtail': TextEditingController(),
      'eq_splicer': TextEditingController(),
      'eq_ont': TextEditingController(),
      'teknisi': TextEditingController(),
      'admin': TextEditingController(),
    };
    super.initState();
  }

  @override
  void dispose() {
    _formControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> loadProvider() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([
      Provider.of<Customer>(context).fetchAndSet(),
      Provider.of<Equipment>(context).fetchAndSet(),
    ]);
    await Provider.of<Customer>(context).fetchAndSet().then((_) {
      Customer customers = Provider.of<Customer>(context, listen: false);
      _items['customer_list'] = customers.items.toList();
      _customerList = getDropDownMenuItems(
        'customer_list',
        'Customer :',
        label: (CustomerItem cust) {
          return '${cust.nama}';
        },
      );
      _formData['customer'] = _customerList[0].value;
      loadCustomerData();
    });
    // Pegawai pegawais = Provider.of<Pegawai>(context, listen: false);
    // _items['pegawai_list'] = pegawais.items.map((item) => '${item.id}').toList();
    // _pegawaiList = getDropDownMenuItems('pegawai_list', 'Pegawai :');
    setState(() {
      _isLoading = false;
    });
  }

  bool _triggerOnce = false;
  CustomerItem _woCustomer;
  EquipmentItem _woEquipment;
  @override
  void didChangeDependencies() {
    if (_triggerOnce) return;
    loadProvider().then((_) {
      final String id = widget.dataId;
      if (id != null && id != '') {
        WorkOrderItem woItem =
            Provider.of<WorkOrder>(context, listen: false).findById(id);
        _woCustomer = Provider.of<Customer>(context, listen: false)
            .findById(woItem.customer);
        _woEquipment = Provider.of<Equipment>(context, listen: false)
            .findById(woItem.equipment);
        print(woItem.kodeDp);
        _formData['wo_level'] = woItem.level;
        _formData['wo_kode_dp'] = woItem.kodeDp;
        _formData['wo_status'] = woItem.status;
        _formData['wo_create_date'] = woItem.createDate;
        _formData['wo_close_date'] = woItem.closeDate;
        _formData['wo_kendala'] = woItem.kendala;
        _formData['wo_password'] = woItem.password;
        _formControllers['wo_kode_dp'].text = woItem.kodeDp;
        _formControllers['wo_create_date'].text =
            Formatting.dateDMYHM(woItem.createDate);
        _formControllers['wo_close_date'].text =
            Formatting.dateDMYHM(woItem.closeDate);
        _formControllers['eq_cable'].text = _woEquipment.cable;
        _formControllers['eq_closure'].text = _woEquipment.closure;
        _formControllers['eq_pigtail'].text = _woEquipment.pigtail;
        _formControllers['eq_splicer'].text = _woEquipment.splicer;
        _formControllers['eq_ont'].text = _woEquipment.ont;
      }
    });
    _triggerOnce = true;
    super.didChangeDependencies();
  }

  void loadCustomerData() {
    _woCustomer = Provider.of<Customer>(context, listen: false)
        .findById(_formData['customer']);
    setState(() {
      _formControllers['cust_nama'].text = _woCustomer.nama;
      _formControllers['cust_nohp'].text = _woCustomer.nohp;
      _formControllers['cust_alamat'].text = _woCustomer.alamat;
      _formControllers['cust_email'].text = _woCustomer.email;
      _formControllers['cust_paket'].text = _woCustomer.paket;
    });
  }

  bool _isLoading = false;
  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    final id = widget.dataId;
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final adminUid = Provider.of<Auth>(context).userId;
    final admin = Provider.of<Pegawai>(context).findByUid(adminUid);
    EquipmentItem woEq = EquipmentItem(
      cable: _formData['eq_cable'],
      closure: _formData['eq_closure'],
      pigtail: _formData['eq_pigtail'],
      splicer: _formData['eq_splicer'],
      ont: _formData['eq_ont'],
    );
    await Provider.of<Equipment>(context).addItem(woEq);
    final equipment = Provider.of<Equipment>(context).findLast();
    if (id != null && id != '') {
      try {
        WorkOrderItem woItem = WorkOrderItem(
          jenis: _formData['wo_jenis'],
          status: _formData['wo_status'],
          createDate: _formData['wo_create_date'],
          closeDate: _formData['wo_close_date'],
          kodeDp: _formData['wo_kode_dp'],
          level: _formData['wo_level'],
          kendala: _formData['wo_kendala'],
          password: _formData['wo_password'],
          customer: _woCustomer.id,
          equipment: equipment.id,
          admin: admin.id
        );
        await Provider.of<WorkOrder>(context, listen: false)
            .updateItem(id, woItem);
        await Provider.of<Equipment>(context, listen: false).deleteItem(_woEquipment.id);
      } catch (error) {}
    } else {
      try {
        WorkOrderItem woItem = WorkOrderItem(
          jenis: _formData['wo_jenis'],
          status: _formData['wo_status'],
          createDate: _formData['wo_create_date'],
          closeDate: _formData['wo_close_date'],
          kodeDp: _formData['wo_kode_dp'],
          level: _formData['wo_level'],
          kendala: _formData['wo_kendala'],
          password: _formData['wo_password'],
          customer: _woCustomer.id,
          equipment: equipment.id,
          admin: admin.id
        );
        await Provider.of<WorkOrder>(context, listen: false).addItem(woItem);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong. ${error.toString()}'),
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
    String title =
        widget.dataId != '' ? "Edit Troubleshoot" : "New Troubleshoot";
    // print('RENDER RENDER');
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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    ComboBox(_formData['wo_level'], _levelList,
                        (val) => changeItem(val, 'wo_level')),
                    SizedBox(height: 5),
                    ComboBox(_formData['wo_status'], _statusList,
                        (val) => changeItem(val, 'wo_status')),
                    SizedBox(height: 5),
                    FormTextBox(
                      "Kode DP",
                      _formData['wo_kode_dp'],
                      (val) => _formData['wo_kode_dp'] = val,
                      controller: _formControllers['wo_kode_dp'],
                    ),
                    SizedBox(height: 5),
                    FormTextBox(
                      "Kendala",
                      _formData['wo_kendala'],
                      (val) => _formData['wo_kendala'] = val,
                      controller: _formControllers['wo_kendala'],
                    ),
                    SizedBox(height: 5),
                    FormTextBox(
                      "Password Dial",
                      _formData['wo_password'],
                      (val) => _formData['wo_password'] = val,
                      controller: _formControllers['wo_password'],
                    ),
                    SizedBox(height: 5),
                    DateTimeBox(
                        "Tanggal & Jam Create",
                        _formData['wo_create_date'],
                        _formControllers['wo_create_date'],
                        (val) => changeItem(val, 'wo_create_date')),
                    SizedBox(height: 5),
                    DateTimeBox(
                        "Tanggal & Jam Closed",
                        _formData['wo_close_date'],
                        _formControllers['wo_close_date'],
                        (val) => changeItem(val, 'wo_close_date')),
                    SizedBox(height: 25),
                    ComboBox(_formData['customer'], _customerList, (val) {
                      changeItem(val, 'customer');
                      loadCustomerData();
                    }),
                    SizedBox(height: 5),
                    FormTextBox("Nama Customer", _formData['cust_nama'],
                        (val) => _formData['cust_nama'] = val,
                        controller: _formControllers['cust_nama'],
                        readOnly: true),
                    SizedBox(height: 5),
                    FormTextBox("No HP", _formData['cust_nohp'],
                        (val) => _formData['cust_nohp'] = val,
                        controller: _formControllers['cust_nohp'],
                        readOnly: true),
                    SizedBox(height: 5),
                    FormTextBox("Alamat", _formData['cust_alamat'],
                        (val) => _formData['cust_alamat'] = val,
                        controller: _formControllers['cust_alamat'],
                        readOnly: true),
                    SizedBox(height: 5),
                    FormTextBox("Email", _formData['cust_email'],
                        (val) => _formData['cust_email'] = val,
                        controller: _formControllers['cust_email'],
                        readOnly: true),
                    SizedBox(height: 25),
                    FormTextBox("Kabel", _formData['eq_cable'],
                        (val) => _formData['eq_cable'] = val,
                        controller: _formControllers['eq_cable'],
                        readOnly: false),
                    SizedBox(height: 5),
                    FormTextBox("Closure", _formData['eq_closure'],
                        (val) => _formData['eq_closure'] = val,
                        controller: _formControllers['eq_closure'],
                        readOnly: false),
                    SizedBox(height: 5),
                    FormTextBox("Pigtail", _formData['eq_pigtail'],
                        (val) => _formData['eq_pigtail'] = val,
                        controller: _formControllers['eq_pigtail'],
                        readOnly: false),
                    SizedBox(height: 5),
                    FormTextBox("Splicer", _formData['eq_splicer'],
                        (val) => _formData['eq_splicer'] = val,
                        controller: _formControllers['eq_splicer'],
                        readOnly: false),
                    SizedBox(height: 5),
                    FormTextBox("Ont", _formData['eq_ont'],
                        (val) => _formData['eq_ont'] = val,
                        controller: _formControllers['eq_ont'], readOnly: false),
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
