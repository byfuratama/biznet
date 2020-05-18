import 'package:biznet/providers/customer.dart';
import 'package:biznet/providers/equipment.dart';
import 'package:biznet/providers/survey.dart';
import 'package:biznet/screens/survey_edit_screen.dart';
import 'package:biznet/widgets/mini_detail_modal.dart';
import 'package:biznet/widgets/numbered_tile.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveyTechScreen extends StatefulWidget {
  final pegawai;
  final title;

  SurveyTechScreen({this.pegawai, this.title});

  @override
  _SurveyTechScreenState createState() => _SurveyTechScreenState();
}

class _SurveyTechScreenState extends State<SurveyTechScreen> {
  bool _triggerOnce = false;
  @override
  void didChangeDependencies() {
    if (_triggerOnce) {
      return;
    }
    Provider.of<Survey>(context).fetchAndSet();
    Provider.of<Customer>(context).fetchAndSet();
    Provider.of<Equipment>(context).fetchAndSet();
    _triggerOnce = true;
    super.didChangeDependencies();
  }

  void _selectMenu(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      SurveyEditScreen.routeName,
      arguments: id,
    );
  }

  void _showBottomModal(BuildContext context, SurveyItem item, CustomerItem customer, EquipmentItem equipment) {
    // final customerItem = 
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return MiniDetailModal(
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
            () {
              Navigator.of(context).pop();
              _selectMenu(context, item.id);
            },
            () {
              Provider.of<Survey>(context).deleteItem(item.id).then((_) {
                Navigator.of(context).pop();
              });
            },
          );
        });
  }

  Future<void> _refreshItems(context) async {
    Provider.of<Survey>(context).fetchAndSet();
    Provider.of<Customer>(context).fetchAndSet();
    Provider.of<Equipment>(context).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final surveyItems = Provider.of<Survey>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('List Survey'),
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
              var survey = surveyItems.items[index];
              var customer = Provider.of<Customer>(context).findById(survey.customer);
              var equipment = Provider.of<Equipment>(context).findById(survey.equipment);
              return InkWell(
                onTap: () => _showBottomModal(context, survey, customer, equipment),
                child: NumberedTile(
                  index + 1,
                  [
                    customer.nama,
                    Formatting.dateDMY(survey.createdAt)
                  ],
                  Chip(
                    label: Text(survey.status),
                  ),
                ),
              );
            },
            itemCount: surveyItems.items.length,
          ),
        ),
      ),
    );
  }
}
