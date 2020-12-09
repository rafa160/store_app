import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/address/address_pattern.dart';
import 'package:storeapp/models/basket_manager.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';

class CepInputField extends StatefulWidget {

  final PatternAddress patternAddress;

  const CepInputField(this.patternAddress);

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {

  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final basketManager = context.watch<BasketManager>();

    final primaryColor = Theme.of(context).primaryColor;

    if(widget.patternAddress.zipCode == null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !basketManager.loading,
            controller: cepController,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '55.123-453',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            validator: (cep){
              if(cep.isEmpty)
                return 'campo obrigatório';
              else if(cep.length != 10)
                return 'cep inválido';
              else
                return null;
            },
          ),
          if(basketManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed:!basketManager.loading ? () async {
              if(Form.of(context).validate()){
                try{
                 await context.read<BasketManager>().getAddress(cepController.text);
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
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
            child: Text('buscar CEP', style: TextStyle(color: Colors.white),),
          )
        ],
      );
    } else {
       return Row(
         children: [
           Expanded(
             child: Text('CEP: ${widget.patternAddress.zipCode}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
             ),
           ),
           CustomIconButton(
             iconData: Icons.edit,
             color: Theme.of(context).primaryColor,
             onTap: (){
               context.read<BasketManager>().removeAddress();

             },
           ),
         ],
       );
    }
  }
}
