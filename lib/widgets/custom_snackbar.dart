import 'package:flutter/material.dart';

class CustomSnackBar extends StatefulWidget {

  final Icon icon;
  final String label;

  const CustomSnackBar({Key key, this.icon, this.label});

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        children: [
          widget.icon,
          Text(
            widget.label
          )
        ],
      ),
    );
  }
}
