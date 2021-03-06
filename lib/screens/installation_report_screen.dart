import 'package:biznet/providers/auth.dart';
import 'package:biznet/providers/customer.dart';
import 'package:biznet/providers/equipment.dart';
import 'package:biznet/providers/pegawai.dart';
import 'package:biznet/providers/work_order.dart';
import 'package:biznet/screens/printing_screen.dart';
import 'package:biznet/widgets/mini_detail_modal_tech.dart';
import 'package:biznet/widgets/numbered_tile.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstallationReportScreen extends StatelessWidget {
  static const routeName = '/installation-report-screen';
  final jenis = "Installasi";
  final title;
  final pegawai;

  InstallationReportScreen({this.title, this.pegawai});

  Future<dynamic> _loadFutures(context) async {
    await Provider.of<Pegawai>(context).fetchAndSet();
    await Provider.of<Customer>(context).fetchAndSet();
    await Provider.of<Equipment>(context).fetchAndSet();
    return Provider.of<WorkOrder>(context).fetchWorkOrderWithJenisBy(jenis);
  }

  List<WorkOrderItem> _filterOpen(itemList, uid) {
    return itemList.where((item) => item.teknisi == uid && item.status == 'Open').toList();
  }

  List<WorkOrderItem> _filterClosed(itemList, uid) {
    return itemList.where((item) => item.teknisi == uid && item.status == 'Close').toList();
  }

  @override
  Widget build(BuildContext context) {
    bool emptyProvider = Provider.of<Pegawai>(context).items.length == 0 ||
        Provider.of<Customer>(context).items.length == 0 ||
        Provider.of<Equipment>(context).items.length == 0 ||
        Provider.of<WorkOrder>(context).items.length == 0;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Installation Work Order Report'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Open"),
                Tab(text: "Closed"),
              ],
            ),
          ),
          body: FutureBuilder(
              future: _loadFutures(context),
              builder: (context, snapshot) {
                final uid = Provider.of<Auth>(context).userId;
                final tid = Provider.of<Pegawai>(context).findByUid(uid).id;
                Widget openWO;
                Widget closedWO;
                if (snapshot.hasData) {
                  List<WorkOrderItem> itemList = snapshot.data;
                  openWO = _hasData(_filterOpen(itemList, pegawai.id), _showBottomModal);
                  closedWO = _hasData(_filterClosed(itemList, pegawai.id), _showBottomModal);
                } else {
                  if (emptyProvider) {
                    openWO = _noData();
                    closedWO = _noData();
                  } else {
                    final itemList = Provider.of<WorkOrder>(context).filterWorkOrderWithJenisBy(jenis);
                    openWO = _hasData(_filterOpen(itemList, tid), _showBottomModal);
                    closedWO = _hasData(_filterClosed(itemList, tid), _showBottomModal);
                  }
                }
                return TabBarView(children: [
                  openWO,
                  closedWO,
                ]);
              }),
        ));
  }

  Widget _hasData(List<WorkOrderItem> data, modal) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          final customer = Provider.of<Customer>(context).findById(item.customer);
          final equipment = Provider.of<Equipment>(context).findById(item.equipment);
          final admin = Provider.of<Pegawai>(context).findById(item.admin);
          final teknisi = Provider.of<Pegawai>(context).findById(item.teknisi);
          return InkWell(
            onTap: () => _showBottomModal(context, item, customer, equipment, admin, teknisi),
            child: NumberedTile(
              index + 1,
              [
                customer.nama,
                item.id,
                customer.alamat,
                Formatting.dateDMYHM(item.createDate),
              ],
              Chip(
                label: Text(item.level),
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

  void _selectMenu(BuildContext context, Object id) {
    Navigator.of(context).pushNamed(
      PrintingScreen.routeName,
      arguments: {
        'work_order_id': id
      },
    );
  }

  void _showBottomModal(BuildContext context, WorkOrderItem item, CustomerItem customer, EquipmentItem equipment, PegawaiItem teknisi, PegawaiItem admin,) {
    // final customerItem = 
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return MiniDetailModalTech(
            [
              'Work Order Jenis: ${item.jenis}',
              'Work Order Level: ${item.level}',
              'Work Order Create: ${item.createDate}',
              'Work Order Close: ${item.closeDate}',
              'Work Order Status: ${item.status}',
              'Work Order Kode DP: ${item.kodeDp}',
              'Customer: ${customer.nama}',
              'Equipment: ${equipment.cable}, ${equipment.closure}, ${equipment.pigtail}, ${equipment.splicer}, ${equipment.ont}',
              'Teknisi: ${teknisi?.nama ?? "Belum Ada"}',
              'Admin: ${admin?.nama ?? "Belum Ada"}',
            ],
            action1: () {
              _selectMenu(context, item.id);
            },
            action1Icon: Icon(Icons.picture_as_pdf),
          );
        });
  }

}
