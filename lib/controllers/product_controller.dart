import 'dart:math';

import 'package:flutter/material.dart';
import 'package:market_app/models/product_model.dart';
import 'package:market_app/services/dummy_data.dart';

class ProductListController with ChangeNotifier {
  final List<ProductModel> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<ProductModel> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite!).toList();
    }
    return [..._items];
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

  void addProductFromData(Map<String, Object> data) {
    final newProduct = ProductModel(
      id: Random().nextDouble().toString(),
      title: data["title"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      imageUrl: data["imageUrl"] as String
      );
      addProduct(newProduct);
      notifyListeners();

  }

  void addProduct(ProductModel product) {
    _items.add(product);
    notifyListeners();

  }

  void editProductFromData(Map<String, Object> data) {
    final productIndex = _items.indexWhere((prod) => prod.id == data["id"]);

    if(productIndex >= 0) {
      _items[productIndex] = ProductModel(
        id: data["id"] as String,
        title: data["title"] as String,
        description: data["description"] as String,
        price: data["price"] as double,
        imageUrl: data["imageUrl"] as String
        );
    }
    notifyListeners();

  }

  void removeProduct(ProductModel productId) {
    _items.remove(productId);
    notifyListeners();

  }

}