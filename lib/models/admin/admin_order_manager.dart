import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/order.dart';
import 'package:storeapp/models/user.dart';


class AdminOrdersManager extends ChangeNotifier {
  List<Order> _orders = [];

  User userFilter;
  List<Status> statusFilter = [Status.waiting_confirmation];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _streamSubscription;

  List<Order> get filteredOrders{
    List<Order> output = _orders.reversed.toList();

    if(userFilter != null){
      output = output.where((element) => element.userId == userFilter.id).toList();
    }

    return output = output.where((element) => statusFilter.contains(element.status)).toList();

  }

  void updateAdmin(bool adminEnable) {
    _orders.clear();
    _streamSubscription?.cancel();
    if (adminEnable) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _streamSubscription = firestore
        .collection('orders')
        .snapshots().listen((event) {
      for(final change in event.documentChanges){
        switch(change.type){
          case DocumentChangeType.added:
            _orders.add(Order.fromDocument(change.document));
            break;
          case DocumentChangeType.modified:
            final modifiedOrder = _orders.firstWhere((o) => o.orderId == change.document.documentID);
            modifiedOrder.updateFromDocument(change.document);
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
      notifyListeners();
    });
  }

  void setUserFilter(User user){
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enable}){
    if(enable){
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}
