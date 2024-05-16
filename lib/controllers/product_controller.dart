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

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    _items.add(product);
    notifyListeners();

  }


}