import 'package:flutter/material.dart';

class OfferTag {
  final int id;
  final String name;
  final String nameAr;

  OfferTag({@required this.id, @required this.name, @required this.nameAr})
      : assert(id != null),
        assert(name != null),
        assert(nameAr != null);
}
