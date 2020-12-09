import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/product_manager.dart';

class SelectProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('vincular produto'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: productManager.allProducts.length,
              itemBuilder: (_, index){
              final product = productManager.allProducts[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.network(product.images.first),
                  title: Text(product.name),
                  subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                  onTap:() {
                    Navigator.of(context).pop(product);
                  },
                );
              }
          );
        },
      ),
    );
  }
}
