import 'package:flutter/material.dart';
import 'package:storeapp/models/basket.dart';
import 'package:storeapp/screens/product/product_widget.dart';

class OrderProductTile extends StatelessWidget {

  final Basket basket;

  const OrderProductTile(this.basket);

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductWidget(product: basket.product,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(basket.product.images.first),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basket.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    basket.top,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black26,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'R\$ ${(basket.fixedPrice ?? basket.unitPrice).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              basket.qta.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: primaryColor,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
