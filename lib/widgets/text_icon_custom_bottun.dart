import 'package:flutter/material.dart';

class TextIconCustomButton extends StatelessWidget {

  final String text;
  final IconData iconData;
  final VoidCallback onTap;
  final Size size;
  final Color color;
  const TextIconCustomButton({Key key, this.text, this.iconData, this.onTap, this.size, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(top: 2, left: 10, right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(iconData, color: color, size: 16,),
              SizedBox(
                height: 5,
              ),
              Text(text, style: TextStyle(color: color, fontSize: 14),),
            ],
        ),
      ),
    );
  }
}
