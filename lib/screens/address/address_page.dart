import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/models/order_manager.dart';
import 'package:storeapp/screens/address/address_card.dart';
import 'package:storeapp/screens/checkout/checkout_page.dart';
import 'package:storeapp/screens/order/payment_card.dart';
import 'package:storeapp/widgets/price_card.dart';

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text('entrega', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(),
          // Consumer<OrdersManager>(
          //   builder: (_,ordersManager,__){
          //     final filteredPayment = ordersManager.
          //     return PaymentCard();
          //   },),
          Consumer<BasketManager>(
            builder: (_, basketManager, __){
              return  PriceCard(
                buttontext: 'continuar para pagamento',
                onPressed: basketManager.isAddressValid ? (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage()));
                } : null,
              );

            },
          ),
        ],
      ),
    );
  }
}
