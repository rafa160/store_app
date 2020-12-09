import 'package:flutter/material.dart';
import 'package:storeapp/models/item_tops.dart';
import 'package:storeapp/models/product.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';
import 'package:storeapp/widgets/edit_item_top.dart';

class TopsForm extends StatelessWidget {
  final Product product;

  const TopsForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemTops>>(
      initialValue: product.tops,
      validator: (tops) {
        if (tops.isEmpty) return 'insira um item.';
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'top, sabor, tipo, etc...',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.white,
                  onTap: () {
                    state.value.add(ItemTops());
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
                children: state.value.map((top) {
              return EditItemTop(
                key: ObjectKey(top),
                top: top,
                onRemove: () {
                  state.value.remove(top);
                  state.didChange(state.value);
                },
                onMoveUp: top != state.value.first
                    ? () {
                        final index = state.value.indexOf(top);
                        state.value.remove(top);
                        state.value.insert(index - 1, top);
                        state.didChange(state.value);
                      }
                    : null,
                onMoveDown: top != state.value.last
                    ? () {
                        final index = state.value.indexOf(top);
                        state.value.remove(top);
                        state.value.insert(index + 1, top);
                        state.didChange(state.value);
                      }
                    : null,
              );
            }).toList()),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        );
      },
    );
  }
}
