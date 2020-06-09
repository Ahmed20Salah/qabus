import 'package:flutter/material.dart';
import 'package:qabus/services/localization.dart';

class HomePageSearchBtn extends StatelessWidget {

  final Function onPressed;
  HomePageSearchBtn(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: RawMaterialButton(
        fillColor: Colors.white,
        elevation: 5,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 18,
                color: Color(0xFF7A7A7A),
              ),
              SizedBox(width: 5),
              Text(
                AppLocalizations.of(context).translate('searchText'),
                style: Theme.of(context).textTheme.overline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
