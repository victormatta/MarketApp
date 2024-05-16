import 'package:flutter/material.dart';
import 'package:market_app/components/app_drawer.dart';
import 'package:market_app/components/order_card.dart';
import 'package:market_app/models/order_list_model.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final finalOrder = Provider.of<OrderListModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Meus Pedidos", style: TextStyle(
            color: Colors.white,
          ),
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const AppDrawer(),
      body: Expanded(
        child: ListView.builder(
          itemCount: finalOrder.itemsCount,
          itemBuilder: (context, index) => OrderCard(finalOrder: finalOrder.items[index]),
          ),
      ),
    );
  }
}