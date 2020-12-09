import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/page_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/admin/admin_orders_page.dart';
import 'package:storeapp/screens/store/my_stores_page.dart';
import 'package:storeapp/screens/admin/users_page.dart';
import 'package:storeapp/screens/home/home.dart';
import 'package:storeapp/screens/order/my_orders_page.dart';
import 'package:storeapp/screens/product/products_page.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(builder: (_, userManager, __) {
        return PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Home(),
            ProductPage(),
            MyOrdersPage(),
            MyStores(),
            if(userManager.adminEnable)
              ...[
                UsersPage(),
                AdminOrdersPage(),
              ]
          ],
        );
      }),
    );
  }
}
