import 'dart:convert';

import 'package:biznet/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SurveyItem {
  final id;
  final status;
  final equipment;
  final customer;

  SurveyItem({
    @required this.id,
    @required this.status,
    @required this.equipment,
    @required this.customer,
  });
}

class Survey with ChangeNotifier {
  List<SurveyItem> _items = [];
  final String authToken;
  final String userId;
  Survey(this.authToken, this.userId, this._items);

  static const String _baseUrl = "https://biznet-3624b.firebaseio.com/surveys";

  List<SurveyItem> get items {
    return [..._items];
  }

  SurveyItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSet([bool filterByUser = false]) async {
    final url = '$_baseUrl.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<SurveyItem> loadedProducts = [];
      extractedData.forEach((key, data) {
        loadedProducts.add(SurveyItem(
          id: key,
          status: data['status'],
          equipment: data['equipment'],
          customer: data['customer'],
        ));
      });
      _items = loadedProducts;
      print(_items);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(SurveyItem item) async {
    final url = '$_baseUrl.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'status': item.status,
          'equipment': item.equipment,
          'customer': item.customer,
        }),
      );

      final newItem = SurveyItem(
        id: json.decode(response.body)['name'],
        status: item.status,
        equipment: item.equipment,
        customer: item.customer,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, SurveyItem item) async {
    final itemIndex = _items.indexWhere((prod) => prod.id == id);
    if (itemIndex >= 0) {
      final url = '$_baseUrl/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'status': item.status,
          'equipment': item.equipment,
          'customer': item.customer,
        }),
      );
      _items[itemIndex] = item;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = '$_baseUrl/$id.json';
    final existingItemIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

}
