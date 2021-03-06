import 'package:biznet/providers/auth.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../widgets/numbered_tile.dart';
import '../widgets/mini_detail_modal.dart';
import './maintenance_edit_screen.dart';

import '../providers/work_order.dart';
import '../providers/customer.dart';
import '../providers/equipment.dart';
import '../providers/pegawai.dart';

class MaintenanceAdminScreen extends StatefulWidget {
  final title;
  final pegawai;

  MaintenanceAdminScreen({this.title, this.pegawai});

  @override
  _MaintenanceAdminScreenState createState() => _MaintenanceAdminScreenState();
}

class _MaintenanceAdminScreenState extends State<MaintenanceAdminScreen> {
  bool _triggerOnce = false;
  @override
  void didChangeDependencies() {
    if (_triggerOnce) {
      return;
    }
    Provider.of<WorkOrder>(context).fetchAndSet();
    Provider.of<Customer>(context).fetchAndSet();
    Provider.of<Equipment>(context).fetchAndSet();
    Provider.of<Pegawai>(context).fetchAndSet();
    _triggerOnce = true;
    super.didChangeDependencies();
  }

  void _selectMenu(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      MaintenanceEditScreen.routeName,
      arguments: id,
    );
  }

  void _showBottomModal(
      BuildContext context,
      WorkOrderItem item,
      CustomerItem customer,
      EquipmentItem equipment,
      PegawaiItem teknisi,
      PegawaiItem admin) {
    
    var pegawai = Provider.of<Auth>(context).pegawai?.posisi;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return MiniDetailModal(
            [
              'Work Order Jenis: ${item.jenis}',
              'Work Order Level: ${item.level}',
              'Work Order Create: ${item.createDate}',
              'Work Order Close: ${item.closeDate}',
              'Work Order Status: ${item.status}',
              'Work Order Kode DP: ${item.kodeDp}',
              'Customer: ${customer.nama}',
              'Equipment: ${equipment.cable}, ${equipment.closure}, ${equipment.pigtail}, ${equipment.splicer}, ${equipment.ont}',
              'Teknisi: ${teknisi?.nama}',
              'Admin: ${admin?.nama}',
            ],
            pegawai == "Admin Branch" ? () {
              Navigator.of(context).pop();
              _selectMenu(context, item.id);
            } : null,
            pegawai == "Admin Branch" ? () {
              Provider.of<WorkOrder>(context).deleteItem(item.id).then((_) {
                Navigator.of(context).pop();
              });
            } : null,
          );
        });
  }

  Future<void> _refreshItems(context) async {
    Provider.of<WorkOrder>(context).fetchAndSet();
    Provider.of<Customer>(context).fetchAndSet();
    Provider.of<Equipment>(context).fetchAndSet();
    Provider.of<Pegawai>(context).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final workOrderItems = Provider.of<WorkOrder>(context)
        .items
        .where((item) => item.jenis == 'Maintenance')
        .toList();
    var pegawai = Provider.of<Auth>(context).pegawai?.posisi;
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: 
          pegawai == "Admin Branch" ?
          <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _selectMenu(context, null),
          ),
        ] : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshItems(context),
        child: !_triggerOnce
            ? CircularProgressIndicator()
            : Container(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    var workOrder = workOrderItems[index];
                    var customer = Provider.of<Customer>(context)
                        .findById(workOrder.customer);
                    var equipment = Provider.of<Equipment>(context)
                        .findById(workOrder.equipment);
                    var teknisi = Provider.of<Pegawai>(context)
                        .findById(workOrder.teknisi);
                    var admin =
                        Provider.of<Pegawai>(context).findById(workOrder.admin);
                    return InkWell(
                      onTap: () => _showBottomModal(context, workOrder,
                          customer, equipment, teknisi, admin),
                      child: NumberedTile(
                        index + 1,
                        [
                          customer.nama,
                          Formatting.dateDMYHM(workOrder.createDate),
                        ],
                        Chip(
                          label: Text(workOrder.level),
                        ),
                      ),
                    );
                  },
                  itemCount: workOrderItems.length,
                ),
              ),
      ),
    );
  }
}
