import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:storeapp/models/store/store.dart';
import 'package:storeapp/widgets/custom_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard(this.store);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    Color colorForStatus(StoreStatus status) {
      switch (status) {
        case StoreStatus.closed:
          return Colors.red;
        case StoreStatus.closing:
          return Colors.yellow;
        case StoreStatus.open:
          return Colors.green;
        default:
          return Colors.red;
      }
    }


    void showError() {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('dispositivo não possui esta função'),
            backgroundColor: Colors.red,
          )
      );
    }

    Future<void> openPhone() async {
      if ((await canLaunch('tel:${store.cleanPhone}')))
        launch('tel:${store.cleanPhone}');
      else
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('dispositivo não possui esta função'),
              backgroundColor: Colors.red,
            )
        );
    }

    Future<void> openMap() async {
      try {
        final maps = await MapLauncher.installedMaps;
        showModalBottomSheet(context: context,
            builder: (_) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for(final map in maps)
                      ListTile(
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          width: 30,
                          height: 30,
                        ),
                        onTap: (){
                          map.showMarker(
                              coords: Coords(store.patternAddress.latitude, store.patternAddress.longitude),
                              title: store.name,
                              description: store.addressText
                          );
                          Navigator.of(context).pop();
                        },
                      )
                  ],
                ),
              );
            });
      } catch (e){
        return showError();
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Container(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  store.image,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(20))),
                    child: Text(
                      store.storeStatusText,
                      style: TextStyle(
                          color: colorForStatus(store.status),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        store.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                      Text(
                        store.addressText,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: primaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        store.openingText,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: primaryColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      iconData: Icons.map,
                      color: primaryColor,
                      onTap: openMap,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: primaryColor,
                      onTap: openPhone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
