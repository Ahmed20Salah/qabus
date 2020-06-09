import 'package:flutter/material.dart';

class NewsCategory {
  final int id;
  final String name;
  final String nameAr;

  NewsCategory({
    @required this.id,
    @required this.name,
    @required this.nameAr,
  })  : assert(id != null),
        assert(name != null),
        assert(nameAr != null);
}
