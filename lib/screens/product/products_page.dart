import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/product_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/basket/basket_page.dart';
import 'package:storeapp/screens/custom_drawer.dart';
import 'package:storeapp/screens/product/edit_product.dart';
import 'package:storeapp/screens/product/product_card.dart';
import 'package:storeapp/screens/product/product_widget.dart';
import 'package:storeapp/screens/product/search_dialog.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: const FlexibleSpaceBar(
            title: Text(
              'produtos',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnable){
                  return IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProductScreen(null)));
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 10),
                  child: Center(
                    child: Consumer<ProductManager>(
                      builder: (_, productManager, __) {
                        if (productManager.search.isEmpty) {
                          return SizedBox();
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              final search = await showDialog<String>(
                                  context: context,
                                  builder: (_) =>
                                      SearchDialog(productManager.search));
                              if (search != null) {
                                productManager.search = search;
                              }
                            },
                            child: Text(
                              productManager.search,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height / 14,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(250, 127, 114, 100),
                      borderRadius: BorderRadius.circular(20)),
                  child: Consumer<ProductManager>(
                    builder: (_, productMaganer, __) {
                      if (productMaganer.search.isEmpty) {
                        return IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final search = await showDialog<String>(
                                context: context,
                                builder: (_) =>
                                    SearchDialog(productMaganer.search));
                            if (search != null) {
                              productMaganer.search = search;
                            }
                          },
                        );
                      } else {
                        return IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            productMaganer.search = '';
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.white12,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                  ),
                  Consumer<ProductManager>(
                    builder: (_, productManager, __) {
                      final filteredProducts =
                          productManager.filteredProducts;
                      return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProductWidget(
                                            product:
                                            filteredProducts[index],
                                          )));
                                },
                                child:
                                ProductCard(filteredProducts[index]));
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => BasketPage()));
            },
            child: Icon(Icons.shopping_basket),
          ),
        ),
      ),
    );
  }
}
