import 'package:flutter/material.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/models/order_list_model.dart';
import 'package:market_app/utils/routes.dart';
import 'package:market_app/view/cart_page.dart';
import 'package:market_app/view/orders_page.dart';
import 'package:market_app/view/product_edit_page.dart';
import 'package:market_app/view/product_form_page.dart';
import 'package:market_app/view/products_manager_page.dart';
import 'package:market_app/view/products_over_view_page.dart';
import 'package:market_app/view/product_detail_page.dart';
import 'package:provider/provider.dart';

void main () => runApp(const MarketApp());

class MarketApp extends StatelessWidget {
  const MarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductListController()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => OrderListModel())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Lato'
        ),
        // home: const ProductsOverViewPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.HOME: (context) => const ProductsOverViewPage(),
          Routes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
          Routes.CART: (context) => (const CartPage()),
          Routes.ORDERS: (context) => (const OrdersPage()),
          Routes.PRODUCTS_MANAGER: (context) => (const ProductManagerPage()),
          Routes.PRODUCTS_FORM: (context) => (const ProductFormPage()),
          Routes.PRODUCTS_EDIT: (context) => (const ProductEditPage()),
        },
      ),
    );
  }
}