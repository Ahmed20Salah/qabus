import 'package:flutter/material.dart';

class SliderModal{

  final int id;
  final String imageURL;

  SliderModal({
    @required this.id,
    @required this.imageURL,
  }) : assert(id != null), assert(imageURL != null);
  
}