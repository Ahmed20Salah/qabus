import 'package:flutter/material.dart';

class SubCategory {
  final String title;
  final Color color;
  final String image;
  final String titleArb;
  final int id;
  final int parentID;
  bool _isSelected = false;

  SubCategory({
    @required this.title,
    this.color = const Color(0xFFB8234F),
    @required this.image,
    @required this.titleArb,
    @required this.id,
    @required this.parentID,
  })  : assert(title != null),
        assert(image != null),
        assert(titleArb != null),
        assert(parentID != null),
        assert(id != null);


  void toggleSelect(bool value) {
    this._isSelected = value;
  }

  bool get isSelected => this._isSelected;


}