import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket_manager.dart';

class PriceCard extends StatelessWidget {

  final String buttontext;
  final VoidCallback onPressed;

  const PriceCard({Key key, this.buttontext, this.onPressed});

  @override
  Widget build(BuildContext context) {

    final basketManager = context.watch<BasketManager>();
    final productsPrice = basketManager.productsPrice;
    final deliveryPrice = basketManager.deliveryPrice;
    final totalPrice = basketManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'resumo do pedido',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('subtotal'),
                Text('R\$ ${productsPrice.toStringAsFixed(2)}')
              ],
            ),
            SizedBox(height: 12,),
            if(deliveryPrice != null)
              ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('entrega'),
                    Text('R\$ ${deliveryPrice.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
              ],
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('total', style: TextStyle(fontWeight: FontWeight.w500),),
                Text('R\$ ${totalPrice.toStringAsFixed(2)}')
              ],
            ),
            SizedBox(height: 12,),
            SizedBox(
              height: 45,
              child: RaisedButton(
                onPressed: onPressed,
                disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                child: Text(buttontext),
              ),
            ),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
