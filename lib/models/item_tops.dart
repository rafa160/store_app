class ItemTops {
  String name;
  num price;
  int stock;

  ItemTops({this.name, this.price, this.stock});

  ItemTops.fromMap(Map<String, dynamic> map) {
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
  }

  bool get hasStock => stock > 0;

  ItemTops clone(){
    return ItemTops(
      name: name,
      price: price,
      stock: stock
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'price': price,
      'stock': stock
    };
  }

  @override
  String toString() {
    return 'ItemTops{name: $name, price: $price, stock: $stock}';
  }
}
