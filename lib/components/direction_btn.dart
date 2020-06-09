import 'package:flutter/material.dart';
import 'package:qabus/services/localization.dart';

class DirectionBtn extends StatelessWidget {

  final Function onPressed;
  DirectionBtn(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: RawMaterialButton(
        fillColor: Colors.white,
        elevation: 1,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            children: <Widget>[
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 3),
              Text(AppLocalizations.of(context).translate('directions'), style: Theme.of(context).textTheme.caption)
            ],
          ),
        ),
      ),
    );
  }
}