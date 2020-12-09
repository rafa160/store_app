import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';


class BasketCard extends StatelessWidget {

  final Basket basket;

  const BasketCard({this.basket});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: basket,
      child: Container(
        margin: EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          shadowColor:Color.fromRGBO(250, 127, 114, 1.0),
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Image.network(basket.product?.images?.first)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        basket.product.name,
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'item: ${basket.top}',
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ), Consumer<Basket>(
                        builder: (_,basket,__){
                          if(basket.hasStock){
                            return Text(
                              'R\$ ${basket.unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            );
                          } else{
                            return  Text(
                              'sem estoque suficiente',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<Basket>(
                  builder: (_,basket,__){
                    return Column(
                      children: [
                        CustomIconButton(
                          iconData: Icons.add,
                          color: Theme.of(context).primaryColor,
                          onTap: basket.increment,
                        ),
                        Text('${basket.qta}', style: TextStyle(fontSize: 20),),
                        CustomIconButton(
                          iconData: Icons.remove,
                          color: basket.qta > 1 ? Theme.of(context).primaryColor : Colors.red,
                          onTap: basket.decrement,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



