import 'package:flutter/material.dart';

class Category {
  final String title;
  final Color color;
  final String image;
  final String titleArb;
  final int id;

  Category({
    @required this.title,
    this.color = const Color(0xFFB8234F),
    @required this.image,
    @required this.titleArb,
    @required this.id,
  })  : assert(title != null),
        assert(image != null),
        assert(titleArb != null),
        assert(id != null);
}
