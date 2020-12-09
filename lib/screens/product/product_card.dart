import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/product.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return product.totalStock > 0
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 160,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.black87
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 0,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 140,
                      width: 200,
                      child: ClipOval(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: product.images.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 0,
                  child: SizedBox(
                    height: 130,
                    width: size.width - 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            product.description,
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomRight: Radius.circular(40))),
                          child: Text(
                            '\R\$ ${product.basePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : _prodOutOfStock(context);
  }

  Widget _prodOutOfStock(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 160,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.red,
            ),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(22)),
            ),
          ),
          Positioned(
            top: 3,
            right: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 140,
                width: 200,
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: product.images.first,
                    fit: BoxFit.cover,
                  ),
                ),
            ),
          ),
          Positioned(
            top: 15,
            left: 0,
            child: SizedBox(
              height: 130,
              width: size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      product.description,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomRight: Radius.circular(40))),
                    child: Text(
                      'produto indisponível',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
