import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/user.dart';
import 'package:storeapp/models/user_manager.dart';

class AdminUsersManager  extends ChangeNotifier{

  final Firestore firestore = Firestore.instance;
  List<User> users =[];

  List<String> get names => users.map((e) => e.name).toList();

  StreamSubscription _subscription;

  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminEnable){
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription = firestore.collection('users').snapshots().listen((value){
      users = value.documents.map((e) => User.fromDocument(e)).toList();
      users.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}


