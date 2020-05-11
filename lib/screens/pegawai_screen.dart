import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../widgets/numbered_tile.dart';
import '../widgets/mini_detail_modal.dart';
import './pegawai_edit_screen.dart';

import '../providers/survey.dart';
import '../providers/customer.dart';
import '../providers/equipment.dart';
import '../providers/pegawai.dart';

class PegawaiScreen extends StatefulWidget {
  static const routeName = '/pegawai-screen';

  PegawaiScreen();

  @override
  _PegawaiScreenState createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  
  bool _triggerOnce = false;
  @override
  void didChangeDependencies() {
    if (_triggerOnce) {
      return;
    }
    Provider.of<Pegawai>(context).fetchAndSet();
    _triggerOnce = true;
    super.didChangeDependencies();
  }

  void _selectMenu(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      PegawaiEditScreen.routeName,
      arguments: id,
    );
  }

  void _showBottomModal(BuildContext context, PegawaiItem item) {
    // final customerItem = 
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return MiniDetailModal(
            [
              'Nama Pegawai: ${item.nama}',
              'Nomor HP: ${item.noHp}',
              'Posisi Pegawai: ${item.posisi}',
              'Foto Pegawai: ${item.foto}',
            ],
            () {
              Navigator.of(context).pop();
              _selectMenu(context, item.id);
            },
            () {
              Provider.of<Pegawai>(context).deleteItem(item.id).then((_) {
                Navigator.of(context).pop();
              });
            },
          );
        });
  }

  Future<void> _refreshItems(context) async {
    Provider.of<Pegawai>(context).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id-ID', null);
    final pegawaiItems = Provider.of<Pegawai>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('List Pegawai'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _selectMenu(context, ''),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshItems(context),
        child: Container(
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              var pegawai = pegawaiItems.items[index];
              return InkWell(
                onTap: () => _showBottomModal(context, pegawai),
                child: NumberedTile(
                  index + 1,
                  [
                    pegawai.nama,
                    pegawai.posisi,
                  ],
                  Chip(
                    label: Text(pegawai.foto),
                  ),
                ),
              );
            },
            itemCount: pegawaiItems.items.length,
          ),
        ),
      ),
    );
  }
}
