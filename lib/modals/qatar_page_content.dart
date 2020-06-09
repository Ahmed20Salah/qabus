import 'package:flutter/material.dart';

class QatarPageContent {
  final String title;
  final String titleAr;
  final String content;
  final String contentAr;
    final String summery;
  final String summeryAr;
  final String image;

  QatarPageContent({
    @required this.title,
    @required this.content,
    @required this.contentAr,
    @required this.titleAr,
    @required this.summery,
    @required this.summeryAr,
    @required this.image,
  })  : assert(title != null),
        assert(titleAr != null),
        assert(content != null),
        assert(contentAr != null),
        assert(summery != null),
        assert(image != null),
        assert(summeryAr != null);
}