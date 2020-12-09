import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:storeapp/models/admin/admin_order_manager.dart';
import 'package:storeapp/models/order.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/custom_drawer.dart';
import 'package:storeapp/screens/home/home.dart';

import 'package:storeapp/screens/order/order_tile.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';
import 'package:storeapp/widgets/empty_card.dart';

class AdminOrdersPage extends StatelessWidget {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      if (userManager.adminEnable) {
        return SafeArea(
          child: Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'controle de pedidos',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Consumer<AdminOrdersManager>(
              builder: (_, ordersManager, __) {
                final filteredOrders = ordersManager.filteredOrders;

                return SlidingUpPanel(
                  controller: panelController,
                  body: Column(
                    children: [
                      if (ordersManager.userFilter != null)
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'pedidos de  ${ordersManager.userFilter.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                              ),
                              CustomIconButton(
                                iconData: Icons.close,
                                color: Colors.white,
                                onTap: () {
                                  ordersManager.setUserFilter(null);
                                },
                              )
                            ],
                          ),
                        ),
                      if (filteredOrders.isEmpty)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.white12,
                                  ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: EmptyCard(
                              title: 'nenhuma venda realizada',
                              iconData: Icons.border_clear,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black,
                                      Colors.white12,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: ListView.builder(
                                itemCount: filteredOrders.length,
                                itemBuilder: (_, index) {
                                  return OrderTile(
                                    filteredOrders[index],
                                    showControls: true,
                                  );
                                }),
                          ),
                        ),
                    ],
                  ),
                  minHeight: 40,
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  panel: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (panelController.isPanelClosed) {
                                panelController.open();
                              } else {
                                panelController.close();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24.0),
                                    topRight: Radius.circular(24.0)),
                              ),
                              padding: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  'filtros',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: Status.values.map((s) {
                                return CheckboxListTile(
                                  title: Text(Order.getStatusText(s)),
                                  dense: true,
                                  value: ordersManager.statusFilter.contains(s),
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (v) {
                                    ordersManager.setStatusFilter(
                                      status: s,
                                      enable: v,
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )),
                  renderPanelSheet: false,
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
