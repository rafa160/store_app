import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/product.dart';
import 'package:storeapp/models/product_manager.dart';
import 'package:storeapp/widgets/images_form.dart';
import 'package:storeapp/widgets/tops_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final bool editing;

  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text(editing ? 'editar' : 'criar'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            if(editing)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  context.read<ProductManager>().delete(product);
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      initialValue: product.name,
                      decoration: InputDecoration(
                          hintText: 'título', border: InputBorder.none),
                      validator: (name) {
                        if (name.isEmpty) return 'título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${product.basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 5) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    TopsForm(product),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: 45,
                            child: RaisedButton(
                              color: Colors.blueGrey,
                              disabledColor: Colors.blueGrey.withAlpha(100),
                              textColor: Colors.white,
                              onPressed: !product.loading
                                  ? () async {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        print(product.toString());
                                       await  product.save();

                                       context.read<ProductManager>().update(product);

                                       Navigator.of(context).pop();
                                      } else {}
                                    }
                                  : null,
                              child: product.loading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                      strokeWidth: 5,
                                    )
                                  : Text('salvar'),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
