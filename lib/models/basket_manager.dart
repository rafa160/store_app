import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:storeapp/models/address/address_pattern.dart';
import 'package:storeapp/models/basket.dart';
import 'package:storeapp/models/product.dart';
import 'package:storeapp/models/user.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/services/cep_api.dart';

class BasketManager extends ChangeNotifier {
  List<Basket> items = [];


  User user;
  PatternAddress patternAddress;


  final Firestore firestore = Firestore.instance;

  num productsPrice = 0.0;
  num deliveryPrice;
  bool _loading = false;

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);
  bool get loading => _loading;
  bool get isAddressValid => patternAddress != null && deliveryPrice != null;


  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();
    productsPrice = 0.0;
    removeAddress();
    if (user != null) {
      _loadBasketItems();
      _loadAddress();
    }
  }

  Future<void> _loadBasketItems() async {
    final QuerySnapshot basketSnap = await user.basketReference.getDocuments();

    items = basketSnap.documents
        .map((doc) => Basket.fromDocument(doc)..addListener(_onItemUpdated))
        .toList();
  }

  Future<void> _loadAddress() async {
    if(user.patternAddress != null && await calculateDelivery(user.patternAddress.latitude, user.patternAddress.longitude)){
      patternAddress = user.patternAddress;
      notifyListeners();
    }
  }

  void addtoBasket(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final basket = Basket.fromProduct(product);
      basket.addListener(_onItemUpdated);
      items.add(basket);
      user.basketReference
          .add(basket.toBasketItemMap())
          .then((doc) => basket.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeFromBasket(Basket basket) {
    items.removeWhere((prod) => prod.id == basket.id);
    user.basketReference.document(basket.id).delete();
    basket.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final basket = items[i];
      if (basket.qta == 0) {
        removeFromBasket(basket);
        i--;
        continue;
      }
      productsPrice += basket.totalPrice;
      _updateBasketProduct(basket);
    }
    notifyListeners();
  }

  void _updateBasketProduct(Basket basket) {
    if (basket.id != null)
      user.basketReference
          .document(basket.id)
          .updateData(basket.toBasketItemMap());
  }

  bool get isBasketValid {
    for (final basketProd in items) {
      if (!basketProd.hasStock) return false;
    }
    return true;
  }

  //// Address

  Future<void> getAddress(String cep) async {

    loading = true;

    final cepService = CepApi();
    try {
      final address = await cepService.getAddressFromCep(cep);
      if (address != null) {
        patternAddress = PatternAddress(
            street: address.logradouro,
            district: address.bairro,
            zipCode: address.cep,
            city: address.cidade.nome,
            state: address.estado.sigla,
            latitude: address.latitude,
            longitude: address.longitude);
      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP inválido');
    }

  }

  Future<void> setAddress(PatternAddress patternAddress) async {
    loading = true;
    this.patternAddress = patternAddress;

    if (await calculateDelivery(patternAddress.latitude, patternAddress.longitude)) {
      user.setAddress(patternAddress);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega');
    }
  }

  void removeAddress() {
    patternAddress = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double latitude, double longitude) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final maxKm = doc.data['maxkm'] as num;
    final baseRun = doc.data['baserun'] as num;
    final km = doc.data['km'] as num;

    double distance = await Geolocator()
        .distanceBetween(latStore, longStore, latitude, longitude);

    distance /= 1000.0;

    if (distance > maxKm) {
      return false;
    }

    deliveryPrice = baseRun + distance * km;

    if (distance <= maxKm) {
    } else {}

    return true;
  }

  void clear(){
    for(final basketProduct in items){
      user.basketReference.document(basketProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }


}
