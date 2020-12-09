import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/item_tops.dart';
import 'package:storeapp/models/product.dart';


class Basket  extends ChangeNotifier{
  String id;
  String productId;
  int qta;
  String top;
  num fixedPrice;
  Product _product;

  Product get product => _product;

  set product(Product value){
    _product = value;
    notifyListeners();
  }


  final Firestore firestore = Firestore.instance;

  Basket.fromProduct(this._product) {
    productId = product.id;
    qta = 1;
    top = product.selectedTop.name;
  }

  Basket.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    productId = documentSnapshot.data['pid'] as String;
    qta = documentSnapshot.data['quantity'] as int;
    top = documentSnapshot.data['top'] as String;
    firestore
        .document('products/$productId')
        .get()
        .then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  Basket.fromMap(Map<String, dynamic> map){
    productId = map['pid'] as String;
    qta = map['quantity'] as int;
    top = map['top'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestore
        .document('products/$productId')
        .get()
        .then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  ItemTops get itemTop {
    if (product == null) return null;
    return product.findTop(top);
  }

  num get unitPrice {
    if(product == null) return 0;
    return itemTop?.price ?? 0;
  }

  num get totalPrice => unitPrice * qta;

  Map<String, dynamic> toBasketItemMap(){
    return {
      'pid': productId,
      'quantity': qta,
      'top': top,
    };
  }

  Map<String, dynamic> toOrderItemMap(){
    return {
      'pid': productId,
      'quantity': qta,
      'top': top,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }

  bool stackable(Product product){
    return product.id == productId && product.selectedTop.name == top;
  }

  void increment(){
    qta++;
    notifyListeners();
  }

  void decrement(){
    qta--;
    notifyListeners();
  }

  bool get hasStock {
    if(product != null && product.deleted) return false;

    final top = itemTop;
    if(top == null) return false;
    return top.stock >= qta;
  }

}
