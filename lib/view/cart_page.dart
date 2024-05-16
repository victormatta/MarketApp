import 'package:flutter/material.dart';
import 'package:market_app/components/app_drawer.dart';
import 'package:market_app/components/cart_item_widget.dart';
import 'package:market_app/models/cart_model.dart';
import 'package:market_app/models/order_list_model.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartInfo = Provider.of<CartModel>(context);
    final items = cartInfo.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("R\$ ${cartInfo.totalAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text('COMPRAR', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                      onPressed: () {
                        Provider.of<OrderListModel>(context, listen: false).createOrder(cartInfo);
                        cartInfo.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child:
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => CartItemWidget(cartItem: items[index])
            ),
          ),
        ],
      ),
    );
  }
}


// Chip(
//                     backgroundColor: Colors.purple,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//                     label: const Text('R\$1000,00', style: TextStyle(color: Colors.white),),
//                     ),