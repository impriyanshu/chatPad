import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  CustomButton({

    this.child,
    this.color,
    this.borderRadius : 150,
    this.height: 50,
    this.onPressed,

  });


  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: RaisedButton(
        child: child,
        onPressed: onPressed,
        disabledColor: color,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),

      ),
    );
  }
}
