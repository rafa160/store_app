import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:storeapp/models/order_manager.dart';
import 'package:storeapp/screens/custom_drawer.dart';
import 'package:storeapp/screens/order/order_tile.dart';
import 'package:storeapp/screens/register/login_card.dart';
import 'package:storeapp/widgets/empty_card.dart';


class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'meus pedidos',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Consumer<OrdersManager>(
          builder: (_, ordersManager, __){
            if(ordersManager.user == null){
              return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.white12,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      )
                  ),
                  child: LoginCard());
            } if(ordersManager.orders.isEmpty){
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.white12,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                    )
                ),
                child: EmptyCard(
                  title: 'nenhuma compra realizada',
                  iconData: Icons.border_clear,
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.white12,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
              child: ListView.builder(
                  itemCount: ordersManager.orders.length,
                  itemBuilder: (_,index){
                    return OrderTile(ordersManager.orders.reversed.toList()[index]);
                  }

              ),
            );
          },
        ),
      )
    );
  }
}
