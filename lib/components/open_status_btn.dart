import 'package:flutter/material.dart';

class OpenStatusBtn extends StatelessWidget {
  final Function onPressed;
  final String openStatus;
  OpenStatusBtn(this.onPressed, this.openStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(left: 15, bottom: 15),
      child: RawMaterialButton(
        splashColor: Color(0xFF05AA7F),
        fillColor: Color(0xFF06D6A0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            children: <Widget>[
              Text(
                '●',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1,
                ),
              ),
              SizedBox(width: 5),
              Text(
                openStatus,
                style: Theme.of(context).textTheme.overline.copyWith(
                      color: Colors.white,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
