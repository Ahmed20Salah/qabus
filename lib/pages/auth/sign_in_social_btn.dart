import 'package:flutter/material.dart';
import 'package:qabus/components/custom_raised_btn.dart';

class SignInWithSocialBtn extends CustomRaisedBtn {
  SignInWithSocialBtn({
    Color color,
    @required String text,
    Color textColor,
    @required String assetName,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(assetName != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset('assets/images/$assetName'),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                ),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset('assets/images/$assetName'),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
