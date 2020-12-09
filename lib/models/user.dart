import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:storeapp/models/address/address_pattern.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  bool admin = false;
  bool courrier = false;
  PatternAddress patternAddress;

  User({this.email, this.password, this.name, this.id});

  User.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    name = documentSnapshot.data['name'] as String;
    email = documentSnapshot.data['email'] as String;
    if(documentSnapshot.data.containsKey('address')){
      patternAddress = PatternAddress.fromMap(documentSnapshot.data['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef =>
      Firestore.instance.document('users/$id');

  CollectionReference get basketReference => firestoreRef.collection('basket');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {'name': name,
      'email': email,
      if(patternAddress != null)
        'address': patternAddress.toMap(),
    };
  }

  void setAddress(PatternAddress address){
    this.patternAddress = address;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    tokensReference.document(token).setData({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }
}
