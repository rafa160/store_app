import 'dart:io';

import 'package:flutter/material.dart';
import 'package:storeapp/models/section.dart';
import 'package:storeapp/models/section_item.dart';
import 'package:storeapp/widgets/image_search_sheet.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final section = context.watch<Section>();

    void onImageSelected(File file){
      section.addItem(SectionItem(image: file));
      Navigator.of(context).pop();
    }
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: (){
          showBottomSheet(context: context, builder: (context) => ImageSearchSheet(imageSelected: onImageSelected));
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }
}
