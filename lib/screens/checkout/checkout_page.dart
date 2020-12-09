import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/models/checkout_manager.dart';
import 'package:storeapp/models/order_manager.dart';
import 'package:storeapp/screens/basket/basket_page.dart';
import 'package:storeapp/screens/checkout/confirmation_page.dart';
import 'package:storeapp/screens/order/payment_card.dart';

import 'package:storeapp/widgets/price_card.dart';

class CheckoutPage extends StatelessWidget {

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<BasketManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, basketManager, checkoutManager) => checkoutManager..updateBasket(basketManager),
      lazy: false,
      child: Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          elevation: 0,
          title: Text('pagamento', style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __){

            /// todo placeHolders?????? to loading?
            if(checkoutManager.loading){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            }

            return ListView(
              children: [
                Consumer<OrdersManager>(
                  builder: (_,ordersManager,__){
                    return PaymentCard();
                  },),
                PriceCard(
                  buttontext: 'finalizar pedido',
                  onPressed: (){
                    checkoutManager.checkout(
                      onStockFail: (e){
                        key.currentState.showSnackBar(
                          SnackBar(
                            content: Text('não a estoque suficiente'),
                            backgroundColor: Colors.red,
                          )
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BasketPage()));
                        // Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      onSuccess: (order){
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmationPage(order: order,)));

                      }
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
