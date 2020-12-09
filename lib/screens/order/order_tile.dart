import 'package:flutter/material.dart';
import 'package:storeapp/models/order.dart';
import 'package:storeapp/screens/order/order_product_tile.dart';
import 'package:storeapp/widgets/cancel_order_dialog.dart';
import 'package:storeapp/widgets/export_address_dialog.dart';
import 'package:storeapp/widgets/text_icon_custom_bottun.dart';

class OrderTile extends StatelessWidget {

  final Order order;
  final bool showControls;

  const OrderTile(this.order, {this.showControls = false});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.formattedId, style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),),
                Text('R\$ ${order.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black26, fontSize: 14),)
              ],
            ),
              Text(order.statusText, style: TextStyle(fontWeight: FontWeight.w600, color:  order.status == Status.canceled ? Colors.red : primaryColor),),
          ],
        ),
        children: [
          Column(
            children: order.basketItems.map((e){
              return OrderProductTile(e);
            }).toList(),
          ),
          if(showControls && order.status != Status.canceled)
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               TextIconCustomButton(
                 iconData: Icons.clear,
                 color: Colors.red,
                 text: 'cancelar',
                 onTap: (){
                   showDialog(
                       context: context,
                     builder: (_) => CancelOrderDialog(order)
                   );
                 },
               ),
                TextIconCustomButton(
                  iconData: Icons.arrow_back,
                  text: 'recuar',
                  color: Colors.blue,
                  onTap: order.back,
                ),
                TextIconCustomButton(
                  iconData: Icons.arrow_forward,
                  color: Colors.blue,
                  text: 'avançar',
                  onTap: order.advance,
                ),
                TextIconCustomButton(
                  iconData: Icons.map,
                  text: 'endereço',
                  color: Colors.green,
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_) => ExportAddressDialog(order.patternAddress)
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
