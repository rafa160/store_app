import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/admin/admin_order_manager.dart';
import 'package:storeapp/models/admin/admin_user_manager.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/models/home_manager.dart';
import 'package:storeapp/models/order_manager.dart';
import 'package:storeapp/models/product_manager.dart';
import 'package:storeapp/models/store/store_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/home/base_page.dart';
import 'package:storeapp/widgets/ClassBuilder.dart';

void main() {
  ClassBuilder.registerClasses();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ProductManager(),
        ),
        ChangeNotifierProxyProvider<UserManager,BasketManager>(
          create: (_) => BasketManager(),
          lazy: false,
          update: (_,userManager, basketManager) =>
          basketManager..updateUser(userManager),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoreManager(),
          lazy: true,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager)=> adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager)=> adminOrdersManager..updateAdmin(userManager.adminEnable),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager)=> ordersManager..updateUser(userManager.user),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Store',
          theme: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Color.fromRGBO(250, 127, 114, 1.0),
          ),
          home:BaseScreen()),
    );
  }
}
