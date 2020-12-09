
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:storeapp/models/store/store.dart';

class StoreManager extends ChangeNotifier {
  List<Store> stores = [];
  final Firestore firestore = Firestore.instance;

  Timer _timer;

  StoreManager() {
    _loadStoreList();
    _startTime();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').getDocuments();
    stores = snapshot.documents.map((e) => Store.fromDocument(e)).toList();
    notifyListeners();
  }

  void _startTime() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for(final store in stores)
      store.updateStatus();
    notifyListeners();

  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
