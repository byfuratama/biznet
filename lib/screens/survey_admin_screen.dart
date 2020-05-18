import 'package:biznet/providers/auth.dart';
import 'package:biznet/providers/customer.dart';
import 'package:biznet/providers/equipment.dart';
import 'package:biznet/providers/survey.dart';
import 'package:biznet/screens/survey_edit_screen.dart';
import 'package:biznet/widgets/mini_detail_modal.dart';
import 'package:biznet/widgets/mini_detail_modal_tech.dart';
import 'package:biznet/widgets/numbered_tile.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'installation_edit_screen.dart';

class SurveyAdminScreen extends StatelessWidget {
  final jenis = "Survey";
  final title;
  final pegawai;

  SurveyAdminScreen({this.title, this.pegawai});

  Future<dynamic> _loadFutures(context) async {
    await Provider.of<Customer>(context).fetchAndSet();
    await Provider.of<Equipment>(context).fetchAndSet();
    await Provider.of<Survey>(context).fetchAndSet();
    return Provider.of<Survey>(context).items;
  }


  @override
  Widget build(BuildContext context) {
    bool emptyProvider = Provider.of<Survey>(context).items.length == 0 ||
        Provider.of<Customer>(context).items.length == 0 ||
        Provider.of<Equipment>(context).items.length == 0;
    return Scaffold(
          appBar: AppBar(
            title: title,
          ),
          body: FutureBuilder(
              future: _loadFutures(context),
              builder: (context, snapshot) {
                // final tid = pegawai.id;
                Widget child;
                if (snapshot.hasData) {
                  List<SurveyItem> itemList = snapshot.data;
                  child = _hasData(itemList);
                } else {
                  if (emptyProvider) {
                    child = _noData();
                  } else {
                    final itemList = Provider.of<Survey>(context).items;
                    child = _hasData(itemList);
                  }
                }
                return child;
              })
    );
  }

  void _instalSurvey(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      InstallationEditScreen.routeName,
      arguments: {
        'survey_id' : id
      },
    );
  }

  void _editSurvey(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      SurveyEditScreen.routeName,
      arguments: id,
    );
  }

  Widget _hasData(List<SurveyItem> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          final customer = Provider.of<Customer>(context).findById(item.customer);
          final equipment = Provider.of<Equipment>(context).findById(item.equipment);
          return InkWell(
            onTap: () => _showBottomModal(context, item, customer, equipment),
            child: NumberedTile(
              index + 1,
              [
                customer.nama,
                Formatting.dateDMYHM(item.createdAt),
              ],
              Chip(
                label: Text(item.status),
              ),
            ),
          );
        });
  }

  Widget _noData() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.black26,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading Data..."),
          ],
        ),
      ),
    );
  }

  void _showBottomModal(BuildContext context, SurveyItem item, CustomerItem customer, EquipmentItem equipment) {
    // final customerItem = 
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return MiniDetailModalTech(
            [
              'Customer Name: ${customer.nama}',
              'Customer HP: ${customer.nohp}',
              'Customer Alamat: ${customer.alamat}',
              'Customer Email: ${customer.email}',
              'Customer Paket: ${customer.paket}',
              'Equipment Cable: ${equipment.cable}',
              'Equipment Closure: ${equipment.closure}',
              'Equipment Pigtail: ${equipment.pigtail}',
              'Equipment Splicer: ${equipment.splicer}',
              'Equipment ONT: ${equipment.ont}',
              'Status: ${item.status}',
            ],
            action1: () {
              Navigator.of(context).pop();
              _instalSurvey(context, item.id);
            },
            action1Icon: Icon(Icons.add_to_photos, color: Colors.green,),
            action2: () {
              Navigator.of(context).pop();
              _editSurvey(context, item.id);
            },
            action2Icon: Icon(Icons.edit, color: Colors.amber,),
          );
        });
  }
}
