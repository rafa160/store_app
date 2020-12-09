import 'dart:io';

import 'package:flutter/material.dart';
import 'package:storeapp/models/home_manager.dart';
import 'package:storeapp/models/product.dart';
import 'package:storeapp/models/product_manager.dart';
import 'package:storeapp/models/section.dart';
import 'package:storeapp/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/screens/product/product_widget.dart';
import 'package:storeapp/screens/product/select_product.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductById(item.product);
          if (product != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProductWidget(
                          product: product,
                        )));
          }
        }
      },
      onLongPress: homeManager.editing ? (){
        showDialog(
          context: context,
          builder: (_){
            final product = context.read<ProductManager>().findProductById(item.product);
            return AlertDialog(
              title: Text('editar item'),
              content: product != null ? 
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(product.images.first),
                    title: Text(product.name),
                    subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                    
                  )
                  : null,
              actions: [
                FlatButton(
                  onPressed: (){
                    context.read<Section>().removeItem(item);
                    Navigator.of(context).pop();
                  },
                  child: Text('excluir'),
                  textColor: Colors.red,
                ),
                FlatButton(
                  onPressed: () async {
                    if(product != null){
                      item.product = null;
                    } else {
                     final Product product = await Navigator.push(context,MaterialPageRoute(builder: (_) => SelectProduct())) as Product;
                     item.product = product?.id;
                    }
                    Navigator.of(context).pop();
                  },
                  child: product != null ? Text('desvincular') : Text('vincular'),
                  textColor: product != null ? Colors.redAccent : Colors.blueAccent,
                ),
              ],
            );
          }
        );
      } : null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.image as String,
              fit: BoxFit.cover,
          ) : Image.file(item.image as File, fit: BoxFit.cover,)
        ),
      ),
    );
  }
}
