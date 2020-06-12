import 'package:flutter/material.dart';

class News {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final String summery;
  final String summeryAr;
  final String imageURL;
  final String author;
  final int category;
  final String date;

  News({
    @required this.author,
    @required this.category,
    @required this.description,
    @required this.descriptionAr,
    @required this.id,
    @required this.imageURL,
    @required this.summery,
    @required this.summeryAr,
    @required this.title,
    @required this.titleAr,
    @required this.date
  })  : assert(author != null),
        assert(category != null),
        assert(description != null),
        assert(descriptionAr != null),
        assert(id != null),
        assert(imageURL != null),
        assert(summery != null),
        assert(summeryAr != null),
        assert(title != null),
        assert(date != null),
        assert(titleAr != null);
}

