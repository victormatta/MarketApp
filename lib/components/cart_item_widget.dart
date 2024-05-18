import 'package:flutter/material.dart';
import 'package:market_app/models/cart_item_model.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exclusão de Itens"),
            content: const Text("Tem certeza que deseja excluir ?"),
            actions: [
              TextButton(
                child: const Text("Sim"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                ),
              TextButton(
                child: const Text("Não"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },)
            ],
          ),
          );
      },
      onDismissed: (_) {
        Provider.of<CartModel>(context, listen: false).removeItem(cartItem.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Padding(padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text("${cartItem.price}", style: const TextStyle(color: Colors.white)
              ,),
            ),
            ),
          ),
          title: Text(cartItem.name, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}"),
          trailing: Text("${cartItem.quantity}x", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
          ),
        ),
      ),
    );
  }
}