import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/address/address_pattern.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/screens/address/address_input_field.dart';

import 'package:storeapp/widgets/cep_input_field.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<BasketManager>(
          builder: (_, basketManager, __) {
            final address = basketManager.patternAddress ?? PatternAddress();
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'endereço de entrega',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  CepInputField(address),
                  AddressInputFormField(address),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
