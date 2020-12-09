import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/item_tops.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemTops> tops;
  bool deleted;

  Product(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.tops,
      this.deleted = false}) {
    images = images ?? [];
    tops = tops ?? [];
  }

  List<dynamic> newImages;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get hasStock {
    return totalStock > 0 && !deleted;
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('products/$id');

  StorageReference get storageRef => storage.ref().child('products').child(id);

  Product.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    name = documentSnapshot['name'] as String;
    description = (documentSnapshot['description'] ?? false) as String;
    deleted = documentSnapshot.data['deleted'] as bool;
    images =
        List<String>.from(documentSnapshot.data['images'] as List<dynamic>);
    tops = (documentSnapshot.data['tops'] as List<dynamic> ?? [])
        .map((top) => ItemTops.fromMap(top as Map<String, dynamic>))
        .toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'tops': exportTopList(),
      'deleted': deleted,
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e) {
          debugPrint('valha ao deletar $image');
        }
      }
    }
    await firestoreRef.updateData({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  List<Map<String, dynamic>> exportTopList() {
    return tops.map((top) => top.toMap()).toList();
  }

  ItemTops _selectedTop;

  ItemTops get selectedTop => _selectedTop;

  num get basePrice {
    num lowest = double.infinity;
    for (final top in tops) {
      if (top.price < lowest) {
        lowest = top.price;
      }
    }
    return lowest;
  }

  set selectedTop(ItemTops value) {
    _selectedTop = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final top in tops) {
      stock += top.stock;
    }

    return stock;
  }



  ItemTops findTop(String name) {
    try {
      return tops.firstWhere((top) => top.name == name);
    } catch (e) {
      return null;
    }
  }

  Product clone() {
    return Product(
        id: id,
        name: name,
        description: description,
        images: List.from(images),
        tops: tops.map((e) => e.clone()).toList(),
        deleted: deleted);
  }

  void delete(){
    firestoreRef.updateData({'deleted': true});
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, tops: $tops, newImages: $newImages, _selectedTop: $_selectedTop}';
  }
}
