import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:storeapp/models/address/address_pattern.dart';

class ExportAddressDialog extends StatelessWidget {

  final PatternAddress patternAddress;

  final ScreenshotController screenshotController = ScreenshotController();

  ExportAddressDialog(this.patternAddress);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(8,16,8,0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      title: Text('endereço de entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          child: Text('${patternAddress.street}, ${patternAddress.number} ${patternAddress.complement}\n'
              '${patternAddress.district}\n'
              '${patternAddress?.city}/${patternAddress.state}\n'
              '${patternAddress.zipCode}',),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await screenshotController.capture();
            await GallerySaver.saveImage(file.path);
          },
          child: Text('exportar endereço', style: TextStyle(color: Theme.of(context).primaryColor),),
        )
      ],
    );
  }
}
