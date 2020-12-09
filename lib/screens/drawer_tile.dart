import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/page_manager.dart';

class DrawerTile extends StatelessWidget {

  const DrawerTile({this.iconData, this.title, this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page);
        debugPrint('toquei $page');
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: currentPage == page ? Theme.of(context).primaryColor : Colors.white,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color:  currentPage == page ? Theme.of(context).primaryColor : Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}