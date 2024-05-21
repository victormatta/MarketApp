import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_app/models/product_model.dart';
// import 'package:market_app/services/dummy_data.dart';

class ProductListController with ChangeNotifier {
  final _url =
      'https://market-devictor-default-rtdb.firebaseio.com/products.json';
  final List<ProductModel> _items = [];
  bool _showFavoriteOnly = false;

  List<ProductModel> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite!).toList();
    }
    return [..._items];
  }

  Future<void> getProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse(_url));
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      final Map<String, dynamic> productMap =
          productData as Map<String, dynamic>;
      final String description = productMap['description'];
      final String imageUrl = productMap['imageUrl'];
      final bool isFavorite = productMap['isFavorite'];
      final String name = productMap['name'];
      final double price = productMap['price'];

      _items.add(
        ProductModel(
          id: productId,
          title: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  Future<void> addProductFromData(Map<String, Object> data) async {
    final newProduct = ProductModel(
        id: Random().nextDouble().toString(),
        title: data["title"] as String,
        description: data["description"] as String,
        price: data["price"] as double,
        imageUrl: data["imageUrl"] as String);

    await addProduct(newProduct);
  }

  Future<void> addProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          "name": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)["name"];
    _items.add(
      ProductModel(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ),
    );
    notifyListeners();

    await getProducts();
  }

  Future<void> editProductFromData(Map<String, Object> data) async {
    int productIndex = _items.indexWhere((prod) => prod.id == data["id"]);

    if (productIndex >= 0) {
      _items[productIndex] = ProductModel(
          id: data["id"] as String,
          title: data["title"] as String,
          description: data["description"] as String,
          price: data["price"] as double,
          imageUrl: data["imageUrl"] as String);
    }
    notifyListeners();
  }

  void removeProduct(ProductModel productId) {
    // _items.remove(productId);
    int productIndex = _items.indexWhere((p) => p.id == productId.id);

    if (productIndex >= 0) {
      _items.removeWhere((p) => p.id == productId.id);
      notifyListeners();
    }
  }
}
