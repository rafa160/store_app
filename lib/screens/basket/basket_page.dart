import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/screens/address/address_page.dart';
import 'package:storeapp/screens/basket/basket_card.dart';
import 'package:storeapp/screens/order/payment_card.dart';
import 'package:storeapp/screens/register/login_card.dart';
import 'package:storeapp/widgets/empty_card.dart';
import 'package:storeapp/widgets/price_card.dart';

class BasketPage extends KFDrawerContent {
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('carrinho', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Consumer<BasketManager>(
          builder: (_, basketManager, __) {
            if(basketManager.user == null){
              return LoginCard();
            }
            if(basketManager.items.isEmpty){
              return EmptyCard(
                iconData: Icons.remove_shopping_cart,
                title: 'Nenhum produto no carrinho!',
              );
            }
            return ListView(
              children: [
                Column(
                  children: basketManager.items.map((prod) => BasketCard(basket: prod,)).toList(),
                ),
                PriceCard(
                  buttontext: 'continuar para entrega',
                  onPressed: basketManager.isBasketValid ? (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddressPage()));
                  } : null,
                )
              ],
            );
          },
        ),
      )
    );
  }
}
