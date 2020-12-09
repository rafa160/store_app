import 'package:flutter/material.dart';
import 'package:storeapp/models/home_manager.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            textColor: Colors.white,
            child: Text('adicionar lista'),
            onPressed: (){
              homeManager.addSection(Section(type: 'List'));
            },
          ),
        ),
        Expanded(
          child: FlatButton(
            textColor: Colors.white,
            child: Text('adicionar grade'),
            onPressed: (){
              homeManager.addSection(Section(type: 'Staggered'));
            },
          ),
        ),
      ],
    );
  }
}
