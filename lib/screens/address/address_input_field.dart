import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:storeapp/models/address/address_pattern.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/validators/validators.dart';
import 'package:provider/provider.dart';

class AddressInputFormField extends StatelessWidget {
  final PatternAddress patternAddress;

  Validator validator = Validator();

  AddressInputFormField(this.patternAddress);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final basketManager = context.watch<BasketManager>();
    if (patternAddress.zipCode != null && basketManager.deliveryPrice == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !basketManager.loading,
            initialValue: patternAddress.street,
            decoration: InputDecoration(
                isDense: true, labelText: 'Rua', hintText: 'Rua das Flores'),
            validator: validator.emptyValidator,
            onSaved: (t) => patternAddress.street = t,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: !basketManager.loading,
                  initialValue: patternAddress.number,
                  decoration: InputDecoration(
                      isDense: true, labelText: 'número', hintText: '123'),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: validator.emptyValidator,
                  onSaved: (t) => patternAddress.number = t,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !basketManager.loading,
                  initialValue: patternAddress.complement,
                  decoration: InputDecoration(
                      isDense: true,
                      labelText: 'complemento',
                      hintText: 'opcional'),
                  onSaved: (t) => patternAddress.complement = t,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !basketManager.loading,
            initialValue: patternAddress.district,
            decoration: InputDecoration(
                isDense: true, labelText: 'Bairro', hintText: 'Aldeota'),
            validator: validator.emptyValidator,
            onSaved: (t) => patternAddress.district = t,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: patternAddress.city,
                  enabled: false,
                  decoration: InputDecoration(
                      isDense: true,
                      labelText: 'cidade',
                      hintText: 'Fortaleza'),
                  validator: validator.emptyValidator,
                  onSaved: (t) => patternAddress.city = t,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: false,
                  initialValue: patternAddress.state,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      isDense: true, labelText: 'UF', hintText: 'CE'),
                  maxLength: 2,
                  validator: validator.emptyValidator,
                  onSaved: (t) => patternAddress.state = t,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if(basketManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed:!basketManager.loading ? () async {
              if(Form.of(context).validate()){
                Form.of(context).save();
                try {
                  await context.read<BasketManager>().setAddress(patternAddress);
                } catch(e){
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('$e', style: TextStyle(color: Colors.white, fontSize: 16),),
                    )
                  );
                }
              }
            } : null,
            child: Text('calcular frete'),
            textColor: Colors.white,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
          ),
        ],
      );
    } else  if(patternAddress.zipCode != null){
      return
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
              '${patternAddress.street}, ${patternAddress.number}\n${patternAddress.district}\n${patternAddress.city} - ${patternAddress.state}'),
        );
    } else {
      return Container();
    }
  }
}
