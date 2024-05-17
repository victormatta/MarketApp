import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_app/models/order_model.dart';

class OrderCard extends StatefulWidget {
  final OrderModel finalOrder;

  const OrderCard({
    super.key,
    required this.finalOrder
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.money_sharp),
            title: Text("R\$ ${widget.finalOrder.total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm").format(widget.finalOrder.date),
              style: const TextStyle(
                fontSize: 12
              ),
            ),
            trailing: IconButton(
              onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            icon: const Icon(Icons.expand_more))
          ),
          if(_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: widget.finalOrder.products.length * 25 + 10,
              child: ListView(
                children: widget.finalOrder.products.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name, style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      Text("${product.quantity}x R\$ ${product.price}", style: const TextStyle(
                        color: Colors.grey
                      ),)
                    ],
                  );
                },
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}