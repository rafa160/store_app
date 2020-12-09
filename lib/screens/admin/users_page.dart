import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/admin/admin_order_manager.dart';
import 'package:storeapp/models/admin/admin_user_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/admin/admin_orders_page.dart';
import 'package:storeapp/screens/custom_drawer.dart';
import 'package:storeapp/screens/home/home.dart';


class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      if (userManager.adminEnable) {
        return SafeArea(
          child: Scaffold(
            drawer: CustomDrawer(),
            backgroundColor: Color.fromARGB(255, 211, 118,130),
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'usúarios',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Consumer<AdminUsersManager>(
              builder: (_, adminUsersManager, __) {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.white12,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      )
                  ),
                  child: AlphabetListScrollView(
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(adminUsersManager.users[index].name, style: TextStyle(color: Colors.white),),
                        subtitle: Text(adminUsersManager.users[index].email),
                        onTap: (){
                          context.read<AdminOrdersManager>().setUserFilter(
                            adminUsersManager.users[index]
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (_) => AdminOrdersPage()));
                        },
                      );
                    },
                    indexedHeight: (index) => 80,
                    strList: adminUsersManager.names,
                    showPreview: true,
                    highlightTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));
              },
            ),
          ),
          body: Center(
            child: Text('você não tem acesso a essa pagina :('),
          ),
        );
      }
    });
  }
}
