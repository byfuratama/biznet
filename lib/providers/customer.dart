import 'dart:convert';

import 'package:biznet/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CustomerItem {
  final id;
  final nama;
  final nohp;
  final alamat;
  final email;
  final paket;
  final createdAt;

  CustomerItem({
    this.id,
    @required this.nama,
    @required this.nohp,
    @required this.alamat,
    @required this.email,
    @required this.paket,
    this.createdAt
  });

  String get idn {
    return id.toString().codeUnits.fold('',(value, element) => '$value${element%10}').substring(5,12);
  }
}

class Customer with ChangeNotifier {
  List<CustomerItem> _items = [];

  static const String _baseUrl = "https://biznet-3624b.firebaseio.com/customers";

  List<CustomerItem> get items {
    return [..._items];
  }

  CustomerItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  CustomerItem findLast() {
    return _items.last;
  }

  Future<void> fetchAndSet([bool filterByUser = false]) async {
    final url = '$_baseUrl.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<CustomerItem> loadedProducts = [];
      extractedData.forEach((key, data) {
        loadedProducts.add(CustomerItem(
          id: key,
          nama: data['nama'],
          nohp: data['nohp'],
          alamat: data['alamat'],
          email: data['email'],
          paket: data['paket'],
          createdAt: data['createdAt'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(CustomerItem item) async {
    final url = '$_baseUrl.json';
    try {
      final createdAt = DateTime.now().toString();
      final response = await http.post(
        url,
        body: json.encode({
          'nama': item.nama,
          'nohp': item.nohp,
          'alamat': item.alamat,
          'email': item.email,
          'paket': item.paket,
          'createdAt': createdAt,
        }),
      );

      final newItem = CustomerItem(
        id: json.decode(response.body)['name'],
        nama: item.nama,
        nohp: item.nohp,
        alamat: item.alamat,
        email: item.email,
        paket: item.paket,
        createdAt: createdAt,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, CustomerItem item) async {
    final itemIndex = _items.indexWhere((prod) => prod.id == id);
    if (itemIndex >= 0) {
      final url = '$_baseUrl/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'nama': item.nama,
          'nohp': item.nohp,
          'alamat': item.alamat,
          'email': item.email,
          'paket': item.paket,
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
