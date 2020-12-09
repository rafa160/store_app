import 'package:flutter/material.dart';
import 'package:storeapp/models/item_tops.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';

class EditItemTop extends StatelessWidget {
  final ItemTops top;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  const EditItemTop({Key key,this.top, this.onRemove, this.onMoveUp, this.onMoveDown}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 50,
          child: TextFormField(
            initialValue: top.name,
            decoration: InputDecoration(
              labelText: 'título',
              isDense: true,
            ),
            validator: (name){
              if(name.isEmpty)
                return 'inválido';
              return null;
            },
            onChanged: (name) => top.name = name,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Expanded(
          flex: 25,
          child: TextFormField(
            initialValue: top.stock?.toString(),
            decoration: InputDecoration(
              labelText: 'estogue',
              isDense: true,
            ),
            validator: (stock){
              if(int.tryParse(stock) == null)
                return 'inválido';
              return null;
            },
            onChanged: (stock) => top.stock = int.tryParse(stock),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Expanded(
          flex: 25,
          child: TextFormField(

            initialValue: top.price?.toStringAsFixed(2),
            decoration: InputDecoration(
              prefixText:'R\$',
              labelText: 'preço',
              isDense: true,
            ),
            validator: (price){
              if(num.tryParse(price) == null)
                return 'inválido';
              return null;
            },
            onChanged: (price) => top.price = num.tryParse(price),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        )
      ],
    );
  }
}
