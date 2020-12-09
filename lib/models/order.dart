import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeapp/models/address/address_pattern.dart';
import 'package:storeapp/models/basket.dart';
import 'package:storeapp/models/basket_manager.dart';

enum Status {
  canceled,
  waiting_confirmation,
  preparing,
  transporting,
  delivered
}

enum Payment {
  credit,
  debit,
}


class Order {
  String orderId;
  List<Basket> basketItems;
  num price;
  String userId;
  PatternAddress patternAddress;
  Timestamp date;
  Payment payment;

  Status status;

  ///uses to create
  Order.fromBasketManager(BasketManager basketManager) {
    basketItems = List.from(basketManager.items);
    price = basketManager.totalPrice;
    userId = basketManager.user.id;
    patternAddress = basketManager.patternAddress;
    status = Status.waiting_confirmation;
  }

  ///used to get it
  Order.fromDocument(DocumentSnapshot documentSnapshot) {
    orderId = documentSnapshot.documentID;
    price = documentSnapshot.data['price'] as num;
    userId = documentSnapshot.data['user'] as String;
    patternAddress = PatternAddress.fromMap(
        documentSnapshot.data['address'] as Map<String, dynamic>);
    date = documentSnapshot.data['date'] as Timestamp;
    basketItems = (documentSnapshot.data['items'] as List<dynamic>).map((e) {
      return Basket.fromMap(e as Map<String, dynamic>);
    }).toList();
    status = Status.values[documentSnapshot.data['status'] as int];
  }

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('orders').document(orderId);

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': basketItems.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': patternAddress.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
    });
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, basketItems: $basketItems, price: $price, userId: $userId, patternAddress: $patternAddress, date: $date, firestore: $firestore}';
  }

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'cancelado';
      case Status.waiting_confirmation:
        return 'aguardando confirmação';
      case Status.preparing:
        return 'em preparação';
      case Status.transporting:
        return 'em transporte';
      case Status.delivered:
        return 'entregue';
      default:
        return '';
    }
  }

  String get paymentMethodText => getPaymentText(payment);

  static String getPaymentText(Payment payment){
    switch(payment){
      case Payment.credit:
        return 'crédito';
      case Payment.debit:
        return 'débito';
      default:
        return '';
    }
  }

  void updateFromDocument(DocumentSnapshot documentSnapshot) {
    status = Status.values[documentSnapshot.data['status'] as int];
  }

  Function() get back {
    return status.index >= Status.preparing.index
        ? () {
            status = Status.values[status.index - 1];
            firestoreRef.updateData({'status': status.index});
          }
        : null;
  }

  Function() get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            firestoreRef.updateData({'status': status.index});
          }
        : null;
  }

  void cancel() {
    status = Status.canceled;
    firestoreRef.updateData({'status': status.index});
  }
}
