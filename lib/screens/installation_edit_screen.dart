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

class InstallationEditScreen extends StatefulWidget {
  static const routeName = '/installation-edit-screen';
  final data;

  InstallationEditScreen(this.data);

  @override
  _InstallationEditScreenState createState() => _InstallationEditScreenState();
}

class _InstallationEditScreenState extends State<InstallationEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {
    'wo_jenis': 'Installasi',
    'wo_status': 'Open',
    'wo_level': '',
    'wo_create_date': '',
    'wo_close_date': '',
    'wo_kode_dp': '',
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
  };

  String _installationId;
  String _surveyId;
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
    _installationId = widget.data['work_order_id'] ?? null;
    _surveyId = widget.data['survey_id'] ?? null;
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
    await Provider.of<Survey>(context).fetchAndSet().then((_) {
      Survey surveys = Provider.of<Survey>(context, listen: false);
      _items['survey_list'] = surveys.items.toList();
      _surveyList = getDropDownMenuItems(
        'survey_list',
        'Survey :',
        label: (SurveyItem survey) {
          CustomerItem cst = Provider.of<Customer>(context, listen: false)
              .findById(survey.customer);
          return '${cst.nama}, ${Formatting.dateDMY(survey.createdAt)}';
        },
      );
      _formData['survey'] = _surveyList[0].value;
      loadSurveyData();
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
      final String id = _installationId;
      if (id != null && id != '') {
        WorkOrderItem woItem =
            Provider.of<WorkOrder>(context, listen: false).findById(id);
        _woCustomer = Provider.of<Customer>(context, listen: false)
            .findById(woItem.customer);
        _woEquipment = Provider.of<Equipment>(context, listen: false)
            .findById(woItem.equipment);
        _formData['wo_level'] = woItem.level;
        _formData['wo_kode_dp'] = woItem.kodeDp;
        _formData['wo_status'] = woItem.status;
        _formData['wo_create_date'] = woItem.createDate;
        _formData['wo_close_date'] = woItem.closeDate;
        _formControllers['wo_kode_dp'].text = woItem.kodeDp;
        _formControllers['wo_create_date'].text =
            Formatting.dateDMYHM(woItem.createDate);
        _formControllers['wo_close_date'].text =
            Formatting.dateDMYHM(woItem.closeDate);
      }
    });
    _triggerOnce = true;
    super.didChangeDependencies();
  }

  void loadSurveyData() {
    if (_surveyId == null)
      return;
    print('$_surveyId x ${_formData['survey']}');
    final survey = Provider.of<Survey>(context, listen: false)
        .findById(_surveyId ?? _formData['survey']);
    _woCustomer =
        Provider.of<Customer>(context, listen: false).findById(survey.customer);
    _woEquipment = Provider.of<Equipment>(context, listen: false)
        .findById(survey.equipment);
    setState(() {
      _formControllers['cust_nama'].text = _woCustomer.nama;
      _formControllers['cust_nohp'].text = _woCustomer.nohp;
      _formControllers['cust_alamat'].text = _woCustomer.alamat;
      _formControllers['cust_email'].text = _woCustomer.email;
      _formControllers['cust_paket'].text = _woCustomer.paket;
      _formControllers['eq_cable'].text = _woEquipment.cable;
      _formControllers['eq_closure'].text = _woEquipment.closure;
      _formControllers['eq_pigtail'].text = _woEquipment.pigtail;
      _formControllers['eq_splicer'].text = _woEquipment.splicer;
      _formControllers['eq_ont'].text = _woEquipment.ont;
      // print(_formData);
    });
  }

  bool _isLoading = false;
  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    final id = _installationId;
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final adminUid = Provider.of<Auth>(context).userId;
    final admin = Provider.of<Pegawai>(context).findByUid(adminUid);
    if (id != null && id != '') {
      try {
        WorkOrderItem woItem = WorkOrderItem(
          jenis: _formData['wo_jenis'],
          status: _formData['wo_status'],
          createDate: _formData['wo_create_date'],
          closeDate: _formData['wo_close_date'],
          customer: _woCustomer.id,
          equipment: _woEquipment.id,
          survey: _formData['survey'],
          kodeDp: _formData['wo_kode_dp'],
          level: _formData['wo_level'],
          admin: admin.id
        );
        await Provider.of<WorkOrder>(context, listen: false)
            .updateItem(id, woItem);
      } catch (error) {}
    } else {
      try {
        WorkOrderItem woItem = WorkOrderItem(
          jenis: _formData['wo_jenis'],
          status: _formData['wo_status'],
          customer: _woCustomer.id,
          equipment: _woEquipment.id,
          survey: _formData['survey'],
          kodeDp: _formData['wo_kode_dp'],
          level: _formData['wo_level'],
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
        _installationId != null ? "Edit Installation" : "New Installation";
    // print('RENDER RENDER');
    bool isFromSurvey = _surveyId != null;
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
                    // if (isFromSurvey)
                    // ComboBox(_formData['survey'], _surveyList, (val) {
                    //   changeItem(val, 'survey');
                    //   loadSurveyData();
                    // }),
                    SizedBox(height: 25),
                    FormTextBox("Nama Customer", _formData['cust_nama'],
                        (val) => _formData['cust_nama'] = val,
                        controller: _formControllers['cust_nama'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("No HP", _formData['cust_nohp'],
                        (val) => _formData['cust_nohp'] = val,
                        controller: _formControllers['cust_nohp'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("Alamat", _formData['cust_alamat'],
                        (val) => _formData['cust_alamat'] = val,
                        controller: _formControllers['cust_alamat'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("Email", _formData['cust_email'],
                        (val) => _formData['cust_email'] = val,
                        controller: _formControllers['cust_email'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    SizedBox(height: 25),
                    FormTextBox("Kabel", _formData['eq_cable'],
                        (val) => _formData['eq_cable'] = val,
                        controller: _formControllers['eq_cable'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("Closure", _formData['eq_closure'],
                        (val) => _formData['eq_closure'] = val,
                        controller: _formControllers['eq_closure'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("Pigtail", _formData['eq_pigtail'],
                        (val) => _formData['eq_pigtail'] = val,
                        controller: _formControllers['eq_pigtail'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("Splicer", _formData['eq_splicer'],
                        (val) => _formData['eq_splicer'] = val,
                        controller: _formControllers['eq_splicer'],
                        readOnly: isFromSurvey),
                    SizedBox(height: 5),
                    FormTextBox("Ont", _formData['eq_ont'],
                        (val) => _formData['eq_ont'] = val,
                        controller: _formControllers['eq_ont'], readOnly: isFromSurvey),
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
