import 'dart:math';

import 'package:flutter/material.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/models/order_model.dart';

class OrderListModel with ChangeNotifier {
  final List<OrderModel> _items = [];

  List<OrderModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void createOrder(CartModel cart) {
    _items.insert(0,
    OrderModel(
      id: Random().nextDouble().toString(),
      total: cart.totalAmount,
      products: cart.items.values.toList(),
      date: DateTime.now()
    )
    );
    notifyListeners();

  }

}