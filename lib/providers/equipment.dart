import 'dart:convert';

import 'package:biznet/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EquipmentItem {
  final id;
  final cable;
  final closure;
  final pigtail;
  final splicer;
  final ont;
  final createdAt;

  EquipmentItem({
    this.id,
    @required this.cable,
    @required this.closure,
    @required this.pigtail,
    @required this.splicer,
    @required this.ont,
    this.createdAt
  });
}

class Equipment with ChangeNotifier {
  List<EquipmentItem> _items = [];

  static const String _baseUrl = "https://biznet-3624b.firebaseio.com/equipments";

  List<EquipmentItem> get items {
    return [..._items];
  }

  EquipmentItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  EquipmentItem findLast() {
    return _items.last;
  }

  Future<void> fetchAndSet([bool filterByUser = false]) async {
    final url = '$_baseUrl.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<EquipmentItem> loadedProducts = [];
      extractedData.forEach((key, data) {
        loadedProducts.add(EquipmentItem(
          id: key,
          cable: data['cable'],
          closure: data['closure'],
          pigtail: data['pigtail'],
          splicer: data['splicer'],
          ont: data['ont'],
          createdAt: data['createdAt'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(EquipmentItem item) async {
    final url = '$_baseUrl.json';
    try {
      final createdAt = DateTime.now().toString();
      final response = await http.post(
        url,
        body: json.encode({
          'cable': item.cable,
          'closure': item.closure,
          'pigtail': item.pigtail,
          'splicer': item.splicer,
          'ont': item.ont,
          'createdAt': createdAt,
        }),
      );

      final newItem = EquipmentItem(
        id: json.decode(response.body)['name'],
        cable: item.cable,
        closure: item.closure,
        pigtail: item.pigtail,
        splicer: item.splicer,
        ont: item.ont,
        createdAt: createdAt,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, EquipmentItem item) async {
    final itemIndex = _items.indexWhere((prod) => prod.id == id);
    if (itemIndex >= 0) {
      final url = '$_baseUrl/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'cable': item.cable,
          'closure': item.closure,
          'pigtail': item.pigtail,
          'splicer': item.splicer,
          'ont': item.ont,
          'createdAt': item.createdAt,
        }),
      );
      _items[itemIndex] = item;
      notifyListeners();
    } else {
      print('...');
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
      throw HttpException('Could not delete this item');
    }
    existingItem = null;
  }

}
