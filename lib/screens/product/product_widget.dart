import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/models/product.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/basket/basket_page.dart';
import 'package:storeapp/screens/product/edit_product.dart';
import 'package:storeapp/screens/product/top_widget.dart';
import 'package:storeapp/screens/register/login_page.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({this.product});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 211, 118, 130),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            product.name,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnable && !product.deleted) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProductScreen(product)));
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height / 3.5),
                      height: 600,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              topLeft: Radius.circular(24))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Image(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(product.images.first),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Center(
                                child: Text(
                              product.description,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54),
                            )),
                          ),
                          if(product.deleted)
                            Text('indisponível')
                          else
                            ...[
                              Padding(
                                  padding: EdgeInsets.only(bottom: 20,left: 10,right: 10),
                                  child: Text(
                                    'escolha sua cobertura',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black54),
                                  )),
                              Wrap(
                                  spacing: 12,
                                  runSpacing: 15,
                                  children: product.tops.map((prod) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 5, right:5 ),
                                      child: TopWidget(
                                        top: prod,
                                      ),
                                    );
                                  }).toList()),
                            ],
                          if (product.hasStock)
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.1,left: 10, right: 10),
                              child: Consumer2<UserManager, Product>(
                                builder: (_, userManager, product, __) {
                                  return SizedBox(
                                    height: 45,
                                    child: RaisedButton(
                                      onPressed: product.selectedTop != null
                                          ? () {
                                              if (userManager.isLoggedIn) {
                                                //todo add acrrinho
                                                context
                                                    .read<BasketManager>()
                                                    .addtoBasket(product);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            BasketPage()));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            LoginPage()));
                                              }
                                            }
                                          : null,
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
//                                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                                      child: Text(userManager.isLoggedIn
                                          ? 'adicionar ao carrinho'
                                          : ' entre para comprar'),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
