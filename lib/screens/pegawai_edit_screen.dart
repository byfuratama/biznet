import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/utilities.dart';
import '../providers/pegawai.dart';
import '../providers/auth.dart';

class PegawaiEditScreen extends StatefulWidget {
  static const routeName = '/pegawai-edit-screen';
  final dataArgs;

  PegawaiEditScreen(this.dataArgs);

  @override
  _PegawaiEditScreenState createState() => _PegawaiEditScreenState();
}

class _PegawaiEditScreenState extends State<PegawaiEditScreen> {
  final _form = GlobalKey<FormState>();
  Map<String, String> _formData = {
    'email': '',
    'password': '',
    'pegawai_uid': '',
    'pegawai_nama': '',
    'pegawai_posisi': '',
    'pegawai_no_hp': '',
    'pegawai_foto': '',
  };

  Map<String, List> _items = {
    'posisi_list': ['Admin', 'Teknisi', 'Supervisor'],
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

  List<DropdownMenuItem<String>> _posisiList;
  @override
  void initState() {
    _posisiList = getDropDownMenuItems('posisi_list', 'Posisi');
    _formData['pegawai_posisi'] = _posisiList[0].value;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final String id = widget.dataArgs['id'];
    final String uid = widget.dataArgs['uid'];
    print('ouch ${widget.dataArgs}');
    if ((id != null && id != '') || (uid != null && uid != '')) {
      PegawaiItem pgwItem = id != null && id != ''
          ? Provider.of<Pegawai>(context, listen: false).findById(id)
          : Provider.of<Pegawai>(context, listen: false).findByUid(uid);
      _formData['pegawai_nama'] = pgwItem.nama;
      _formData['pegawai_posisi'] = pgwItem.posisi;
      _formData['pegawai_no_hp'] = pgwItem.noHp;
      _formData['pegawai_foto'] = pgwItem.foto;
    }
    super.didChangeDependencies();
  }

  bool _isLoading = false;
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    final String id = widget.dataArgs['id'];
    final String uid = widget.dataArgs['uid'];
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if ((id != null && id != '') || (uid != null && uid != '')) {
      try {
        PegawaiItem pgwItem = PegawaiItem(
          nama: _formData['pegawai_nama'],
          posisi: _formData['pegawai_posisi'],
          noHp: _formData['pegawai_no_hp'],
          foto: _formData['pegawai_foto'],
        );
        await Provider.of<Pegawai>(context, listen: false)
            .updateItem(pgwItem, id: uid, uid: uid);
      } catch (error) {}
    } else {
      try {
        final uid =
            await Provider.of<Auth>(context, listen: false).registerUser(
          _formData['email'],
          _formData['password'],
        );
        PegawaiItem pgwItem = PegawaiItem(
          uid: uid,
          nama: _formData['pegawai_nama'],
          posisi: _formData['pegawai_posisi'],
          noHp: _formData['pegawai_no_hp'],
          foto: _formData['pegawai_foto'],
        );
        await Provider.of<Pegawai>(context, listen: false).addItem(pgwItem);
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
    bool editMode = widget.dataArgs['uid'] != '';
    String title = editMode ? "Edit Pegawai" : "New Pegawai";
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
                    if (!editMode)
                      Column(
                        children: <Widget>[
                          FormTextBox("Email", _formData['email'],
                              (val) => _formData['email'] = val),
                          SizedBox(height: 5),
                          FormTextBox(
                            "Password",
                            _formData['password'],
                            (val) => _formData['password'] = val,
                            obscureText: true,
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    FormTextBox("Nama Pegawai", _formData['pegawai_nama'],
                        (val) => _formData['pegawai_nama'] = val),
                    if (!editMode) SizedBox(height: 5),
                    if (!editMode) ComboBox(_formData['pegawai_posisi'], _posisiList,
                        (val) => changeItem(val, 'pegawai_posisi')),
                    SizedBox(height: 5),
                    FormTextBox("No HP", _formData['pegawai_no_hp'],
                        (val) => _formData['pegawai_no_hp'] = val),
                    SizedBox(height: 5),
                    FormTextBox("Foto", _formData['pegawai_foto'],
                        (val) => _formData['pegawai_foto'] = val),
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
