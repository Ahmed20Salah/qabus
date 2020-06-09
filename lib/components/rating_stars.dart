import 'package:flutter/material.dart';

enum STAR { EMPTY, HALF, FULL }

class RatingStars extends StatelessWidget {

  final double rate;

  RatingStars(this.rate);

  Icon _buildStarIcon(STAR star) {
    IconData icon;
    switch(star) {
      case STAR.EMPTY: 
      icon = Icons.star_border; break;
      case STAR.FULL: 
      icon = Icons.star; break;
      case STAR.HALF: 
      icon = Icons.star_half; break;
    }
    return Icon(icon, size: 20, color: Color(0xFFFFDD00),);
  }

  List<Widget> _buildStars() {
    List<Widget> stars = [];
    int fullStars = rate.floor();
    int halfStars = 0;
    if(rate / fullStars != 1) {
      halfStars = 1;
    }
    int emptyStars = 5 - (halfStars + fullStars);
    stars.addAll(List.filled(fullStars, _buildStarIcon(STAR.FULL)));
    if(halfStars > 0) {
      stars.add( _buildStarIcon(STAR.HALF));
    }
    stars.addAll(List.filled(emptyStars,  _buildStarIcon(STAR.EMPTY)));

    return stars;
  }



  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildStars(),
    );
  }
}