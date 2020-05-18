import 'package:biznet/providers/auth.dart';
import 'package:biznet/providers/customer.dart';
import 'package:biznet/providers/equipment.dart';
import 'package:biznet/providers/pegawai.dart';
import 'package:biznet/providers/work_order.dart';
import 'package:biznet/widgets/mini_detail_modal.dart';
import 'package:biznet/widgets/mini_detail_modal_tech.dart';
import 'package:biznet/widgets/numbered_tile.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TroubleshootTechScreen extends StatelessWidget {
  final jenis = "Troubleshoot";
  final title;
  final pegawai;

  TroubleshootTechScreen({this.title, this.pegawai});

  Future<dynamic> _loadFutures(context) async {
    await Provider.of<Pegawai>(context).fetchAndSet();
    await Provider.of<Customer>(context).fetchAndSet();
    await Provider.of<Equipment>(context).fetchAndSet();
    return Provider.of<WorkOrder>(context).fetchWorkOrderWithJenisBy(jenis);
  }

  Future<void> _acquireWO(BuildContext context, WorkOrderItem wo) async {
    WorkOrderItem nwo = WorkOrderItem(
      createDate: wo.createDate,
      customer: wo.customer,
      equipment: wo.equipment,
      jenis: wo.jenis,
      kodeDp: wo.kodeDp,
      level: wo.level,
      admin: wo.admin,
      closeDate: wo.closeDate,
      status: wo.status,
      survey: wo.survey,
      teknisi: pegawai.id,
    );
    await Provider.of<WorkOrder>(context).updateItem(wo.id, nwo);
  }

  Future<void> _doneWO(BuildContext context, WorkOrderItem wo) async {
    WorkOrderItem nwo = WorkOrderItem(
      createDate: wo.createDate,
      customer: wo.customer,
      equipment: wo.equipment,
      jenis: wo.jenis,
      kodeDp: wo.kodeDp,
      level: wo.level,
      admin: wo.admin,
      closeDate: DateTime.now().toString(),
      status: "Close",
      survey: wo.survey,
      teknisi: wo.teknisi,
    );
    await Provider.of<WorkOrder>(context).updateItem(wo.id, nwo);
  }

  List<WorkOrderItem> _filterOnProgress(itemList, uid) {
    return itemList.where((item) => item.teknisi == uid && item.status == 'Open').toList();
  }

  List<WorkOrderItem> _filterAvailable(itemList, uid) {
    return itemList.where((item) => item.teknisi == null && item.status == 'Open').toList();
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
            title: title,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "On Progress"),
                Tab(text: "Available"),
              ],
            ),
          ),
          body: FutureBuilder(
              future: _loadFutures(context),
              builder: (context, snapshot) {
                final uid = Provider.of<Auth>(context).userId;
                final tid = Provider.of<Pegawai>(context).findByUid(uid).id;
                Widget onProgress;
                Widget available;
                if (snapshot.hasData) {
                  List<WorkOrderItem> itemList = snapshot.data;
                  onProgress = _hasData(_filterOnProgress(itemList, pegawai.id), _showBottomModalOnProgress);
                  available = _hasData(_filterAvailable(itemList, pegawai.id), _showBottomModalAvailable);
                } else {
                  if (emptyProvider) {
                    onProgress = _noData();
                    available = _noData();
                  } else {
                    final itemList = Provider.of<WorkOrder>(context).filterWorkOrderWithJenisBy(jenis);
                    onProgress = _hasData(_filterOnProgress(itemList, tid), _showBottomModalOnProgress);
                    available = _hasData(_filterAvailable(itemList, tid), _showBottomModalAvailable);
                  }
                }
                return TabBarView(children: [
                  onProgress,
                  available,
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
            onTap: () => modal(context, item, customer, equipment, teknisi, admin),
            child: NumberedTile(
              index + 1,
              [
                customer.nama,
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

  void _showBottomModalAvailable(
    BuildContext context,
    WorkOrderItem item,
    CustomerItem customer,
    EquipmentItem equipment,
    PegawaiItem teknisi,
    PegawaiItem admin,
  ) {
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
              Navigator.of(context).pop();
              _acquireWO(context, item);
            },
            action1Icon: Icon(Icons.add),
          );
        });
  }

  void _showBottomModalOnProgress(
    BuildContext context,
    WorkOrderItem item,
    CustomerItem customer,
    EquipmentItem equipment,
    PegawaiItem teknisi,
    PegawaiItem admin,
  ) {
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
              Navigator.of(context).pop();
              _doneWO(context, item);
            },
            action1Icon: Icon(Icons.check),
          );
        });
  }
}
