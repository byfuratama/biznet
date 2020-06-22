import 'dart:convert';

import 'package:biznet/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PegawaiItem {
  final id;
  final uid;
  final nama;
  final posisi;
  final noHp;
  final foto;
  final createdAt;

  PegawaiItem({
    this.id,
    this.uid,
    @required this.nama,
    @required this.posisi,
    @required this.noHp,
    @required this.foto,
    this.createdAt
  });
}

class Pegawai with ChangeNotifier {
  List<PegawaiItem> _items = [];

  static const String _baseUrl = "https://biznet-3624b.firebaseio.com/pegawais";

  List<PegawaiItem> get items {
    return [..._items];
  }

  PegawaiItem dummy() {
    return PegawaiItem(
      foto: '', uid: 'tzb0UKsdppNJaMEUiDisS8FUMrK2', nama: 'Memuat...', noHp: '08112345678', posisi: 'Memuat...'
    );
  }

  PegawaiItem findById(String id) {
    if (id == null) return dummy();
    final item = _items.firstWhere((item) => item.id == id);
    return item == null ? dummy() : item;
  }

  PegawaiItem findByUid(String uid) {
    if (_items.length == 0) return dummy();
    return _items.firstWhere((item) => item.uid == uid);
  }

  PegawaiItem findLast() {
    return _items.last;
  }

  Future<void> fetchAndSet([bool filterByUser = false]) async {
    final url = '$_baseUrl.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<PegawaiItem> loadedProducts = [];
      extractedData.forEach((key, data) {
        loadedProducts.add(PegawaiItem(
          id: key,
          uid: data['uid'],
          nama: data['nama'],
          posisi: data['posisi'],
          noHp: data['noHp'],
          foto: data['foto'],
          createdAt: data['createdAt'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(PegawaiItem item) async {
    final url = '$_baseUrl.json';
    try {
      final createdAt = DateTime.now().toString();
      final response = await http.post(
        url,
        body: json.encode({
          'uid': item.uid,
          'nama': item.nama,
          'posisi': item.posisi,
          'noHp': item.noHp,
          'foto': item.foto,
          'createdAt': createdAt,
        }),
      );

      final newItem = PegawaiItem(
        id: json.decode(response.body)['name'],
        uid: item.uid,
        nama: item.nama,
        posisi: item.posisi,
        noHp: item.noHp,
        foto: item.foto,
        createdAt: createdAt,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(PegawaiItem item, {String id, String uid}) async {
    final itemIndex = _items.indexWhere((item) => item.id == id || item.uid == uid);
    id = _items[itemIndex].id;
    if (itemIndex >= 0) {
      final url = '$_baseUrl/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'nama': item.nama,
          'noHp': item.noHp,
          'foto': item.foto,
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
    final existingItemIndex = _items.indexWhere((item) => item.id == id);
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
