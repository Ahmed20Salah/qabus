import 'package:flutter/material.dart';

class BasicPageContent {
  final String title;
  final String titleAr;
  final String content;
  final String contentAr;

  BasicPageContent({
    @required this.title,
    @required this.content,
    @required this.contentAr,
    @required this.titleAr,
  })  : assert(title != null),
        assert(titleAr != null),
        assert(content != null),
        assert(contentAr != null);
}
