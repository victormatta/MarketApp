import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_app/exceptions/favorite_exception.dart';
import 'package:market_app/exceptions/http_exception.dart';
import 'package:market_app/models/product_model.dart';
// import 'package:market_app/services/dummy_data.dart';

class ProductListController with ChangeNotifier {
  final _baseUrl =
      'https://market-devictor-default-rtdb.firebaseio.com/products';
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

    final response = await http.get(Uri.parse('$_baseUrl.json'));
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      final Map<String, dynamic> productMap =
          productData as Map<String, dynamic>;
      final String description = productMap['description'];
      final String imageUrl = productMap['imageUrl'];
      final bool isFavorite = productMap['isFavorite'] ?? false;
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
      Uri.parse('$_baseUrl.json'),
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
      final updatedProduct = ProductModel(
          id: data["id"] as String,
          title: data["title"] as String,
          description: data["description"] as String,
          price: data["price"] as double,
          imageUrl: data["imageUrl"] as String,
          isFavorite: data["isFavorite"] as bool? ?? false);

      final response = await http.patch(
        Uri.parse('$_baseUrl/${data["id"]}.json'),
        body: jsonEncode(
          {
            "name": data["title"],
            "description": data["description"],
            "price": data["price"],
            "imageUrl": data["imageUrl"],
            "isFavorite": data["isFavorite"],
          },
        ),
      );

      if (response.statusCode >= 400) {
        // Lidar com erro se necessário
        return;
      }

      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> removeProduct(ProductModel product) async {
    int productIndex = _items.indexWhere((prod) => prod.id == product.id);

    if (productIndex >= 0) {
      final product = _items[productIndex];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('$_baseUrl/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(productIndex, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possível deleter o produto.',
            statusCode: response.statusCode);
      }
    }
  }

  void _toggleFavorite(ProductModel product) {
    product.isFavorite = !product.isFavorite!;
    notifyListeners();
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final productIndex = _items.indexWhere((prod) => prod.id == product.id);

    if (productIndex >= 0) {
      _toggleFavorite(product);

      final response = await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json'),
        body: jsonEncode(
          {"isFavorite": product.isFavorite},
        ),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite(product);
        throw FavoriteException(
          msg: 'Não foi possível adicionar o produto aos favoritos.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
