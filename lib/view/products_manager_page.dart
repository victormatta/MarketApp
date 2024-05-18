import 'package:flutter/material.dart';
import 'package:market_app/components/app_drawer.dart';
import 'package:market_app/components/product_manager_widget.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductManagerPage extends StatelessWidget {
  const ProductManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductListController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Produtos", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.PRODUCTS_FORM);
            },
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: products.itemsCount,
          itemBuilder: (context, index) => ProductManagerWidget(product: products.items[index])
          ),
        ),
    );
  }
}