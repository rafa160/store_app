import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/basket.dart';
import 'package:storeapp/models/order.dart';
import 'package:storeapp/models/user.dart';

class OrdersManager extends ChangeNotifier {
  User user;

  List<Order> orders = [];
  List<Payment> paymentMethod = [Payment.credit];
  Payment _payment;
  final Firestore firestore = Firestore.instance;

  StreamSubscription _streamSubscription;

  Payment get payment => _payment;

  set payment(Payment value){
    _payment = value;
    notifyListeners();
  }

  void updateUser(User user) {
    this.user = user;
    orders.clear();
    _streamSubscription?.cancel();
    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
   _streamSubscription = firestore
        .collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots().listen((event) {
          orders.clear();
          for(final doc in event.documents){
            orders.add(Order.fromDocument(doc));
          }
          notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

  void setPaymentMethodFilter({Payment payment, bool enable}){
    if(enable){
      paymentMethod.add(payment);
    } else {
      paymentMethod.remove(payment);
    }
    notifyListeners();
  }
}
