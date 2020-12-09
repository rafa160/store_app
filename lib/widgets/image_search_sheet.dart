import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSearchSheet extends StatelessWidget {

  final Function(File) imageSelected;

  final ImagePicker imagePicker = ImagePicker();

  ImageSearchSheet({this.imageSelected});

  Future<void> editImage(String path, BuildContext context) async {
    final File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Editar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',
        )
    );
    if(croppedFile != null){
      imageSelected(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatButton(
            onPressed: () async {
              final PickedFile file =
                  await imagePicker.getImage(source: ImageSource.camera);
              editImage(file.path, context);
            },
            child: Text('camera'),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: FlatButton(
              onPressed: () async {
                final PickedFile file =
                    await imagePicker.getImage(source: ImageSource.gallery);
                editImage(file.path, context);
              },
              child: Text('galeria'),
            ),
          ),
        ],
      ),
    );
  }
}
