import 'package:flutter/material.dart';
import 'package:storeapp/models/home_manager.dart';
import 'package:storeapp/models/section.dart';
import 'package:storeapp/widgets/add_tile_widget.dart';
import 'package:storeapp/widgets/item_tile.dart';
import 'package:storeapp/widgets/section_header.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList(this.section);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(),
            SizedBox(
              height: 150,
              child: Consumer<Section>(
                builder: (_, section,__){
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeManager.editing
                        ? section.items.length + 1
                        : section.items.length,
                    itemBuilder: (_, index) {
                      if (index < section.items.length)
                        return ItemTile(section.items[index]);
                      else
                        return AddTileWidget();
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      width: 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
