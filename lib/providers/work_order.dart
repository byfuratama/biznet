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
    this.createDate,
    this.closeDate,
  });

  String get idn {
    return id.toString().codeUnits.fold('',(value, element) => '$value${element%10}').substring(5,12);
  }
}

class WorkOrder with ChangeNotifier {
  List<WorkOrderItem> _items = [];

  static const String _baseUrl = "https://biznet-3624b.firebaseio.com/workorders";

  List<WorkOrderItem> get items {
    return [..._items];
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
        ));
      });
      _items = loadedProducts;
      notifyListeners();
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
