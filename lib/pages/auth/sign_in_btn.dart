import 'package:flutter/material.dart';
import 'package:qabus/components/custom_raised_btn.dart';

class SignInBtn extends CustomRaisedBtn {
  SignInBtn({
    Color color,
    @required String text,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: textColor,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
