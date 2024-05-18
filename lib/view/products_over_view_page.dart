import 'package:flutter/material.dart';
import 'package:market_app/components/app_drawer.dart';
import 'package:market_app/components/badgee.dart';
import 'package:market_app/components/product_grid.dart';
import 'package:market_app/controllers/product_controller.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/utils/routes.dart';
import 'package:provider/provider.dart';
// import 'package:market_app/components/product_item.dart';
// import 'package:market_app/controllers/product_controller.dart';
// import 'package:market_app/models/product_model.dart';
// import 'package:provider/provider.dart';
// import 'package:market_app/services/dummy_data.dart';

enum FilterType {
  Favorite,
  All

}

class ProductsOverViewPage extends StatelessWidget {
  // final List<ProductModel> loadedProducts = dummyProducts;

  const ProductsOverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (_) => [
            const PopupMenuItem(
              value: FilterType.Favorite,
              child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterType.All,
                child: Text('Todos'),
                )
          ],
          onSelected: (FilterType selectedValue) {
            if (selectedValue == FilterType.Favorite) {
              provider.showFavoriteOnly();
            } else {
              provider.showAll();
            }
          },
          ),
          Consumer<CartModel>(
            child: IconButton(onPressed: () {
              Navigator.of(context).pushNamed(Routes.CART);
            },
              icon: const Icon(Icons.shopping_cart, color: Colors.white)
              ),
            builder: (context, cart, child) => Bagdee(
              value: cart.itemCount.toString(),
              color: Colors.red,
              child: child!,
            ),
          )
        ],
        backgroundColor: Colors.purple,
      ),
      drawer: const AppDrawer(),
      body: const ProductGrid(),
    );
  }
}