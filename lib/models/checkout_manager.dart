import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/models/order.dart';
import 'package:storeapp/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  BasketManager basketManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateBasket(BasketManager basketManager) {
    this.basketManager = basketManager;
  }

  Future<void> checkout({Function onStockFail, Function onSuccess}) async {
    loading = true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }
    // TODO process the payment

    final orderId = await _getOrderId();

    final order = Order.fromBasketManager(basketManager);
    order.orderId = orderId.toString();

    await order.save();

    basketManager.clear();

    onSuccess(order);
    loading = false;
  }

  ///* use the method to create a unique transaction to make the
  ///orders using that its pretty sure u will never have double
  /// orders cause when it sees igual they will start the transaction again///

  Future<int> _getOrderId() async {
    ///get the ref document
    final ref = firestore.document('aux/ordercounter');

    try {
      ///create the transaction
      final result = await firestore.runTransaction((transaction) async {
        /// used to read and write a unique value in the database
        /// gets the doc using the reference and increment the reference id after get it

        final doc = await transaction.get(ref);
        final orderId = doc.data['current'] as int;
        await transaction.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      }, timeout: const Duration(seconds: 10));
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('falha ao gerar número do pedido, tentar novamente.');
    }
  }

  Future<void> _decrementStock() async {
    /// ler o estoque primeiro

    return firestore.runTransaction((transaction) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final basketProduct in basketManager.items) {
        Product product;

        ///check if the ids have 'tops' diferents in the same obj
        if (productsToUpdate
            .any((element) => element.id == basketProduct.productId)) {
          product = productsToUpdate
              .firstWhere((element) => element.id == basketProduct.productId);
        } else {
          ///gets the productId in the firebase .
          final doc = await transaction
              .get(firestore.document('products/${basketProduct.productId}'));
          product = Product.fromDocument(doc);
        }

        basketProduct.product = product;

        final top = product.findTop(basketProduct.top);
        if (top.stock - basketProduct.qta < 0) {
          // retornar falha
          productsWithoutStock.add(product);
        } else {
          top.stock -= basketProduct.qta;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque');
      }

      //salvar o estoque no banco
      for (final product in productsToUpdate) {
        transaction.update(firestore.document('products/${product.id}'),
            {'tops': product.exportTopList()});
      }
    });

    //se tiver estoque decrementar localmente
  }


}
