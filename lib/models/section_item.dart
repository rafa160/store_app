class SectionItem {
  dynamic image;
  String product;

  SectionItem({this.image, this.product});

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    product = map['product'] as String;
  }

  SectionItem clone(){
    return SectionItem(
      image: image,
      product: product
    );
  }

  @override
  String toString() {
    return 'SectionItem{image: $image}';
  }

  Map<String, dynamic> toMap(){
    return {
      'image': image,
      'product': product
    };
  }
}
