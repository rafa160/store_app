import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:storeapp/models/home_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/basket/basket_page.dart';
import 'package:storeapp/screens/custom_drawer.dart';
import 'package:storeapp/screens/home/section_list.dart';
import 'package:storeapp/widgets/add_section_widget.dart';
import 'package:storeapp/widgets/section_staggered.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.white12,
                    ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text(
                      'Store',
                      style: TextStyle(color: Colors.white),
                    ),
                    centerTitle: true,
                  ),
                  snap: true,
                  floating: true,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.shopping_basket),
                      color: Colors.white,
                      onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (_) => BasketPage())),
                    ),
                    Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager,__){
                        if(userManager.adminEnable && !homeManager.loading) {
                          if(homeManager.editing) {
                            return PopupMenuButton(
                              onSelected: (e){
                                if(e == 'salvar'){
                                  homeManager.saveEditing();
                                } else {
                                  homeManager.discardEditing();
                                }
                              },
                              itemBuilder: (_){
                                return ['salvar', 'descartar'].map((e){
                                  return PopupMenuItem(
                                    child: Text(e),
                                    value: e,
                                  );
                                }).toList();
                              },
                            );
                          } else {
                            return IconButton(
                              icon: Icon(Icons.mode_edit),
                              onPressed: homeManager.enterEditing,
                            );
                          }
                        } else return Container();
                      },
                    )
                  ],
                ),
                Consumer<HomeManager>(
                  builder: (_, homeManager,__){

                    if(homeManager.loading){
                      return SliverToBoxAdapter(
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }

                    final List<Widget> children = homeManager.sections.map<Widget>((section){
                      switch(section.type){
                        case 'List':
                          return SectionList(section);
                        case 'Staggered':
                          return SectionStaggered(section);
                        default:
                          return Container();
                      }
                    }).toList();

                    if(homeManager.editing)
                      children.add(AddSectionWidget());

                    return SliverList(
                      delegate: SliverChildListDelegate(
                          children
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
