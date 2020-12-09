import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/store/store_manager.dart';
import 'package:storeapp/screens/custom_drawer.dart';
import 'package:storeapp/screens/store/store_card.dart';

class MyStores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'lojas',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Consumer<StoreManager>(
          builder: (_,storeManager,__){
            if(storeManager.stores.isEmpty){
              /// TODO placeholder de loading
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      Colors.white
                  ),
                  strokeWidth: 5,
                )
              );
            }
            return ListView.builder(
              itemCount: storeManager.stores.length,
                itemBuilder: (_, index){
                  return StoreCard(storeManager.stores[index]);
                }
            );
          },
        ),
      )
    );
  }
}
