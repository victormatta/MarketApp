import 'package:flutter/material.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/exceptions/favorite_exception.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/models/product_model.dart';
import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context, listen: false);
    final interface = Provider.of<ProductListController>(context);
    final cart = Provider.of<CartModel>(context, listen: false);
    final msg = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<ProductModel>(
            builder: (context, product, _) => IconButton(
                onPressed: () async {
                  try {
                    await interface.toggleFavorite(product);
                    // interface.items;
                  } on FavoriteException catch (error) {
                    msg.showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      ),
                    );
                  }
                },
                icon: Icon(product.isFavorite!
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.deepOrange),
          ),
          title: Text(product.title, textAlign: TextAlign.center),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Colors.deepOrange,
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Produto adicionado com sucesso!"),
                duration: const Duration(seconds: 1),
                action: SnackBarAction(
                    label: "DESFAZER",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
              ));
            },
          ),
          backgroundColor: Colors.black54,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
