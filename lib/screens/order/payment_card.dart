import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket.dart';
import 'package:storeapp/models/order.dart';
import 'package:storeapp/models/order_manager.dart';

class PaymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<OrdersManager>(
          builder: (_,orderManager, __) {
            return Container(
              height: MediaQuery.of(context).size.height / 6.5,
                child: Column(
                  children: Payment.values.map((e) {
                    return CheckboxListTile(
                      title: Text(Order.getPaymentText(e)),
                      value: orderManager.paymentMethod.contains(e),
                      activeColor: Colors.black87,
                      onChanged: (v){
                        orderManager.setPaymentMethodFilter(
                          payment: e,
                          enable: v,
                        );
                      },
                    );
                  }).toList()
                ),
            );
          },
        ),
      ),
    );
  }
}
