import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderListModel with ChangeNotifier {
  final _baseUrl = 'https://market-devictor-default-rtdb.firebaseio.com/orders';
  final List<OrderModel> _items = [];

  List<OrderModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> createOrder(CartModel cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode({
        "total": cart.totalAmount,
        "date": date.toIso8601String(),
        "products": cart.items.values
            .map(
              (cartItem) => {
                "id": cartItem.id,
                "productId": cartItem.productId,
                "name": cartItem.name,
                "quantity": cartItem.quantity,
                "price": cartItem.price,
              },
            )
            .toList(),
      }),
    );

    final id = jsonDecode(response.body)["name"];
    _items.insert(
      0,
      OrderModel(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
