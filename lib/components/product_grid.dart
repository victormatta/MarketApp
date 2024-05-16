import 'package:flutter/material.dart';
import 'package:market_app/components/product_item.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/models/product_model.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductListController>(context);
    final List<ProductModel> loadedProduct = controller.items;
    
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProduct.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        ), 
      itemBuilder: (context, index) => Center(
        child: ChangeNotifierProvider.value(
          value: loadedProduct[index],
          child: const ProductItem(),
        ),
        ),
      );
  }
}