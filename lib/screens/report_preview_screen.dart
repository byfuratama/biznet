import 'package:biznet/providers/customer.dart';
import 'package:biznet/providers/equipment.dart';
import 'package:biznet/providers/work_order.dart';
import 'package:biznet/widgets/report_previewer.dart';
import 'package:biznet/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class ReportPreviewScreen extends StatefulWidget {
  static const routeName = '/report-preview-screen';
  final reportType;
  final reportMethod;

  ReportPreviewScreen({this.reportType, this.reportMethod});

  @override
  _ReportPreviewScreenState createState() => _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends State<ReportPreviewScreen> {
  List _items;

  Future<void> _init() async {
    _items = widget.reportType == 'wo' ? Provider.of<WorkOrder>(context).items : Provider.of<Equipment>(context).items;
    if (_items.length == 0) {
      await Provider.of<WorkOrder>(context).fetchAndSet();
      await Provider.of<Customer>(context).fetchAndSet();
      await Provider.of<Equipment>(context).fetchAndSet();
    }
  }

  Function _showDatePicker(context, onConfirm, defaultVal) {
    return () {
      DatePicker.showPicker(context,
          pickerModel: DatePickerModel(
            maxTime: DateTime.now(),
            minTime: DateTime(2020),
            currentTime: defaultVal ?? DateTime.now(),
          ),
          onConfirm: onConfirm);
    };
  }

  List _filterData(context, queryDate) {
    final isDaily = widget.reportMethod == 'daily';
    final isWO = widget.reportType == 'wo';
    List items = widget.reportType == 'wo' ? Provider.of<WorkOrder>(context).items : Provider.of<Equipment>(context).items;
    final filterFunc = (String strDate) {
      if (strDate == null || strDate == '') return false;
      DateTime itemDate = DateTime.parse(strDate);
      if (isDaily) {
        return itemDate.day == queryDate.day && itemDate.month == queryDate.month && itemDate.year == queryDate.year;
      } else {
        return itemDate.month == queryDate.month && itemDate.year == queryDate.year;
      }
    };

    final Function mapWO = (WorkOrderItem item) {
      print('$item');
      CustomerItem cust = Provider.of<Customer>(context).findById(item.customer);
      EquipmentItem eq = Provider.of<Equipment>(context).findById(item.equipment);
      return <String>[item.idn, Formatting.dateDMY(item.closeDate), cust.idn, cust.nama, cust.alamat, cust.paket, eq.idn];
    };
    final Function mapEq = (EquipmentItem item) {
      return <String>[item.idn, item.cable, item.closure, item.pigtail, item.splicer, item.ont];
    };

    final its = items
        .where((item) {
          return isWO ? filterFunc(item.createDate) : filterFunc(item.createdAt);
        })
        .map((item) => isWO ? mapWO(item) : mapEq(item))
        .toList();
    // print(its);
    return its;
  }

  String get _getTitle {
    final method = widget.reportMethod == 'daily' ? 'Harian' : 'Bulanan';
    final type = widget.reportType == 'wo' ? 'Work Order' : 'Equipment';
    return 'Laporan $type $method';
  }

  List get _reportColumn {
    final isWO = widget.reportType == 'wo';
    if (isWO)
      return ['WO ID', 'Finish Date', 'Cust ID', 'Nama', 'Alamat', 'Paket', 'Equipment ID'];
    else
      return ['Equipment ID', 'Cable', 'Closure', 'Pigtail', 'Splicer', 'ONT'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) => _items.length > 0
          ? ReportPreviewer(
              reportTitle: _getTitle,
              reportDateTitle: (DateTime date) => widget.reportMethod == 'daily' ? Formatting.dateDMY(date): Formatting.dateMY(date),
              reportFilter: (DateTime date) => _filterData(context, date),
              reportColumn: _reportColumn,
              datePicker: (onConfirm, defaultVal) => _showDatePicker(context, onConfirm, defaultVal),
            )
          : Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: Text(
                "NO DATA YET",
                style: Theme.of(context).textTheme.display1,
              )),
            ),
    );
  }
}
