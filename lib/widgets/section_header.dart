import 'package:flutter/material.dart';
import 'package:storeapp/models/home_manager.dart';
import 'package:storeapp/models/section.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';

class SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();
    if (homeManager.editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: InputDecoration(
                      hintText: 'título',
                      isDense: true,
                      border: InputBorder.none),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(
                iconData: Icons.remove,
                color: Colors.white,
                onTap: () {
                  homeManager.removeSection(section);
                },
              ),
            ],
          ),
          if (section.error != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                section.error,
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name ?? "",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      );
    }
  }
}
