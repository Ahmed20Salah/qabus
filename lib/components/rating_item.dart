import 'package:flutter/material.dart';

class RatingItem extends StatelessWidget {
  final double rating;
  RatingItem(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFFFDD00),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Text('$rating / 5'),
    );
  }
}
