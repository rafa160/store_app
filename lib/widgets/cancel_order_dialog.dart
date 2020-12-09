import 'package:flutter/material.dart';
import 'package:storeapp/models/order.dart';

class CancelOrderDialog extends StatelessWidget {

  final Order order;

  const CancelOrderDialog(this.order);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      title: Text('cancelar ${order.formattedId}?'),
      content: Text('essa ação não poderá ser desfeita!'),
      actions: [
        FlatButton(
          onPressed: (){
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: Text('cancelar pedido'),
        )
      ],
    );
  }
}
