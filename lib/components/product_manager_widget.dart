import 'package:flutter/material.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/models/product_model.dart';
import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductManagerWidget extends StatelessWidget {
  final ProductModel product;

  const ProductManagerWidget({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
          ),
          title: Text(product.title),
          trailing: SizedBox(
            width: 80,
            child: Row(
              children: [
                IconButton(
                icon: const Icon(Icons.edit, color: Colors.purple),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.PRODUCTS_EDIT,
                  arguments: product
                  );
                },
                ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Provider.of<ProductListController>(context, listen: false).removeProduct(product);
                },
                ),
              ],
            ),
          )
        ),
        const Divider()
      ],
    );
  }
}