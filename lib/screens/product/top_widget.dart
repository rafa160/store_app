import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/item_tops.dart';
import 'package:storeapp/models/product.dart';
import 'package:provider/provider.dart';

class TopWidget extends StatelessWidget {

  final ItemTops top;

  const TopWidget({this.top});

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = top == product.selectedTop;

    Color color;

    if (!top.hasStock)
      color = Colors.red.withAlpha(50);
    else if (selected)
      color = Theme
          .of(context)
          .primaryColor;
    else
      color = Colors.grey;

    return GestureDetector(
      onTap: () {
        if (top.hasStock) {
          product.selectedTop = top;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: color,
            )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(top.name, style: TextStyle(color: Colors.white),),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('R\$ ${top.price.toStringAsFixed(2)}',
                style: TextStyle(color: color),),
            )
          ],
        ),
      ),
    );
  }
}
