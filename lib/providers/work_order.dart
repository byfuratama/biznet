import 'dart:convert';

import 'package:biznet/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WorkOrderItem {
  final id;
  final jenis;
  final level;
  final createDate;
  final closeDate;
  final kodeDp;
  final survey;
  final customer;
  final equipment;
  final teknisi;
  final admin;
  final status;
  final kendala;
  final keterangan;
  final password;

  WorkOrderItem({
    this.id,
    @required this.jenis,
    @required this.level,
    @required this.kodeDp,
    this.survey,
    @required this.customer,
    @required this.equipment,
    this.teknisi,
    this.admin,
    this.status,
    this.password,
    this.kendala,
    this.createDate,
    this.closeDate,
    this.keterangan,
  });

  String get idn {
    return id.toString().codeUnits.fold('',(value, element) => '$value${element%10}').substring(5,12);
  }
  String get custIdn {
    if (customer == "") return "";
    return customer.toString().codeUnits.fold('',(value, element) => '$value${element%10}').substring(5,12);
  }
}

class WorkOrder with ChangeNotifier {
  List<WorkOrderItem> _items = [];

  static const String _baseUrl = "https://biznet-3624b.firebaseio.com/workorders";

  List<WorkOrderItem> get items {
    return [..._items];
  }

  WorkOrderItem get emptyWo {
    return WorkOrderItem(
      id : "",
      jenis : "",
      level : "",
      createDate : "",
      closeDate : "",
      kodeDp : "",
      survey : "",
      customer : "",
      equipment : "",
      teknisi : "",
      admin : "",
      status : "",
      kendala : "",
      password : "",
    );
  }

  int level2Int(String level) {
    if (level == 'Urgent') return 3;
    if (level == 'High') return 2;
    if (level == 'Low') return 1;
    return 0;
  }

  String int2Level(int level) {
    if (level == 3) return 'Urgent';
    if (level == 2) return 'High';
    if (level == 1) return 'Low';
    return '0';
  }

  WorkOrderItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  WorkOrderItem findByEqId(String id) {
    final wo = _items.firstWhere((item) => item.equipment == id, orElse: () => null );
    return wo ?? emptyWo;
  }

  WorkOrderItem findLast() {
    return _items.last;
  }

  Future<void> fetchAndSet([bool filterByUser = false]) async {
    final url = '$_baseUrl.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<WorkOrderItem> loadedProducts = [];
      extractedData.forEach((key, data) {
        loadedProducts.add(WorkOrderItem(
          id: key,
          jenis: data['jenis'],
          level: int2Level(data['level']),
          createDate: data['createDate'],
          closeDate: data['closeDate'],
          kodeDp: data['kodeDp'],
          survey: data['survey'],
          customer: data['customer'],
          equipment: data['equipment'],
          teknisi: data['teknisi'],
          admin: data['admin'],
          status: data['status'],
          kendala: data['kendala'],
          password: data['password'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<List> fetchWorkOrder() async {
    try {
      await fetchAndSet();
      return _items;
    } catch (error) {
      throw error;
    }
  }

  Future<List> fetchWorkOrderWithJenisBy(String jenis) async {
    try {
      await fetchAndSet();
      return _items.where((item) => item.jenis == jenis).toList();
    } catch (error) {
      throw error;
    }
  }

  List<WorkOrderItem> filterWorkOrderWithJenisBy(String jenis) {
    return _items.where((item) => item.jenis == jenis).toList();
  }

  Future<void> addItem(WorkOrderItem item) async {
    final url = '$_baseUrl.json';
    try {
      final createdAt = DateTime.now().toString();
      final response = await http.post(
        url,
        body: json.encode({
          'jenis': item.jenis,
          'level': level2Int(item.level),
          'createDate': createdAt,
          'kodeDp': item.kodeDp,
          'survey': item.survey,
          'customer': item.customer,
          'equipment': item.equipment,
          'teknisi': item.teknisi,
          'admin': item.admin,
          'status': item.status,
          'kendala': item.kendala,
          'password': item.password,
        }),
      );

      final newItem = WorkOrderItem(
        id: json.decode(response.body)['name'],
        jenis: item.jenis,
        level: item.level,
        createDate: item.createDate,
        closeDate: item.closeDate,
        kodeDp: item.kodeDp,
        survey: item.survey,
        customer: item.customer,
        equipment: item.equipment,
        teknisi: item.teknisi,
        admin: item.admin,
        status: item.status,
        kendala: item.kendala,
        password: item.password,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, WorkOrderItem item) async {
    final itemIndex = _items.indexWhere((prod) => prod.id == id);
    if (itemIndex >= 0) {
      final url = '$_baseUrl/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'jenis': item.jenis,
          'level': level2Int(item.level),
          'createDate': item.createDate,
          'closeDate': item.closeDate,
          'kodeDp': item.kodeDp,
          'survey': item.survey,
          'customer': item.customer,
          'equipment': item.equipment,
          'teknisi': item.teknisi,
          'admin': item.admin,
          'status': item.status,
          'kendala': item.kendala,
        }),
      );
      _items[itemIndex] = item;
      notifyListeners();
    } else {
      print('... ${item.id}');
    }
  }

  Future<void> deleteItem(String id) async {
    final url = '$_baseUrl/$id.json';
    final existingItemIndex = _items.indexWhere((prod) => prod.id == id);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Could not delete this WorkOrder');
    }
    existingItem = null;
  }

}
