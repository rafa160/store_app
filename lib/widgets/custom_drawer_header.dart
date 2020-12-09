import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/register/login_page.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Donuts\n Store', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, ),),
              Padding(
                padding: EdgeInsets.only(top:1),
                child: Text(
                  'Olá, ${userManager.user?.name ?? ''}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1),
                child: GestureDetector(
                  onTap: (){
                    if(userManager.isLoggedIn){
//                      Navigator.push(context,MaterialPageRoute(builder: (_) => HomePage()));
                      userManager.signOut();
                    } else {
                      Navigator.push(context,MaterialPageRoute(builder: (_) => LoginPage()));
                    }

                  },
                  child: Text(
                    userManager.isLoggedIn ? 'sair'
                        : 'entrar ou cadastre-se >',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
