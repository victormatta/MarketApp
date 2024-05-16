import 'package:flutter/material.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/models/product_model.dart';
import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {

  const ProductItem({
    super.key
    });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context, listen: false);
    final interface = Provider.of<ProductListController>(context);
    final cart = Provider.of<CartModel>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<ProductModel>(
            builder: (context, product, _) => IconButton(
              onPressed: () {
                product.toggleFavorite();
                interface.items;

              },
              icon: Icon(product.isFavorite! ? Icons.favorite : Icons.favorite_border),
              color: Colors.deepOrange
            ),
          ),
          title: Text(product.title, textAlign: TextAlign.center),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              print(cart.itemCount);
            },
            icon: const Icon(Icons.shopping_cart),
            color: Colors.deepOrange
          ),
          backgroundColor: Colors.black54,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.PRODUCT_DETAIL,
            arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
          fit: BoxFit.cover
          ),
        ),
        ),
    );
  }
}