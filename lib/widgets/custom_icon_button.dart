import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const CustomIconButton({this.iconData, this.color, this.onTap,this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              iconData,
              color:  onTap != null ? color : Colors.grey[600],
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
