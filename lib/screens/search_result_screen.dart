import 'package:biznet/providers/customer.dart';
import 'package:biznet/providers/equipment.dart';
import 'package:biznet/providers/pegawai.dart';
import 'package:biznet/providers/work_order.dart';
import 'package:biznet/widgets/numbered_tile.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  static const routeName = "/search-result-screen";
  final searchQuery;
  final searchType;
  final searchCategory;
  SearchResultScreen({@required this.searchCategory, @required this.searchQuery, @required this.searchType});

  Future<dynamic> _loadFutures(context) async {
    await Provider.of<Customer>(context).fetchAndSet();
    await Provider.of<Equipment>(context).fetchAndSet();
    await Provider.of<WorkOrder>(context).fetchAndSet();
  }

  List _dataSource(context) {
    if (searchType == 'wo')
      return Provider.of<WorkOrder>(context).items.map((item) {
        var customer = Provider.of<Customer>(context).findById(item.customer);
        return WorkOrderItem(
            id: item.id,
            equipment: item.equipment,
            jenis: item.jenis,
            kodeDp: item.kodeDp,
            level: item.level,
            admin: item.admin,
            closeDate: item.closeDate,
            createDate: item.createDate,
            status: item.status,
            teknisi: item.teknisi,
            customer: customer.nama);
      }).toList();
    if (searchType == 'cust') return Provider.of<Customer>(context).items;
    if (searchType == 'eq') return Provider.of<Equipment>(context).items;
    return null;
  }

  Function _filters(context) {
    // print(searchQuery);
    if (searchCategory == 'id') return (item) => (item.id.toString().toLowerCase().contains(searchQuery.toString().toLowerCase()));
    if (searchCategory == 'name') return (item) => (item.nama.toString().toLowerCase().contains(searchQuery.toString().toLowerCase()));
    // if (searchCategory == 'name') return (item) => (item.nama.toString()).contains(searchQuery);
    return null;
  }

  List _flattenData(List data) {
    if (searchType == 'wo')
      return data.map((item) {
        return [
          'Jenis: ${item.jenis}',
          'Customer: ${item.customer}',
          'Kode DP: ${item.kodeDp}',
          'Level: ${item.level}',
          'Admin: ${item.admin}',
          'Close Date: ${Formatting.dateDMYHM(item.closeDate)}',
          'Create Date: ${Formatting.dateDMYHM(item.createDate)}',
          'Status: ${item.status}',
          'Teknisi: ${item.teknisi}',
        ];
      }).toList();
    if (searchType == 'cust') return data.map((item) {
        return [
          'Nama: ${item.nama}',
          'No DP: ${item.nohp}',
          'Alamat: ${item.alamat}',
          'Email: ${item.email}',
          'Paket: ${item.paket}',
        ];
      }).toList();
    if (searchType == 'eq') return data.map((item) {
        return [
          'Cable: ${item.cable}',
          'Closure: ${item.closure}',
          'Pigtail: ${item.pigtail}',
          'Splicer: ${item.splicer}',
          'ONT: ${item.ont}',
        ];
      }).toList();
    return [];
  }

  @override
  Widget build(BuildContext context) {
    bool emptyProvider = _dataSource(context).length == 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Result"),
      ),
      body: FutureBuilder(
        future: _loadFutures(context),
        builder: (context, snapshot) {
          // print('before filter ${_dataSource(context).length.toString()}');
          final searchedData = _dataSource(context).where(_filters(context)).toList();
          // print('after filter ${searchedData.length}');
          Widget child;
          if (searchedData.length > 0) {
            child = _hasData(searchedData);
          } else {
            if (emptyProvider) {
              child = _noData();
            } else {
              child = Center(child: Text("NO DATA"));
            }
          }
          return child;
        },
      ),
    );
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

  Widget _hasData(List<dynamic> data) {
    final theData = _flattenData(data);
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return NumberedTile(
          index + 1,
          theData[index],
          null,
        );
      },
    );
  }
}
