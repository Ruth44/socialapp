import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final Color clr;
  final Function onPressed;
  final String txt;
  RoundedButton(this.clr,this.txt,this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: clr,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text( txt,
              style: TextStyle(
                color: Colors.white,
              ),
            )
        ),
      ),
    );
  }
}