import 'package:flutter/material.dart';
import 'package:market_app/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {

  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel specificProduct = ModalRoute.of(context)?.settings.arguments as ProductModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(specificProduct.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                specificProduct.imageUrl,
                fit: BoxFit.cover
              ),
            ),
            const SizedBox(height: 10),
            Text("R\$ ${specificProduct.price}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20
            ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(specificProduct.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}