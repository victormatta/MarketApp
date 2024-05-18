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
                  showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Exclusão de produtos"),
                      content: const Text("Tem certeza que deseja excluir esse produto ?"),
                      actions: [
                        TextButton(
                          child: const Text("Sim"),
                          onPressed: () {
                            Provider.of<ProductListController>(context, listen: false).removeProduct(product);
                            Navigator.of(context).pop(true);
                          },
                          ),
                        TextButton(
                          child: const Text("Não"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          ),
                      ],
                    ),
                    );
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