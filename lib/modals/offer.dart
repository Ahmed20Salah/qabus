import 'package:flutter/material.dart';

class Offer {
  final String companyId;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final String imageURL;
  final DateTime startDate;
  final DateTime endDate;

  Offer(
      {@required this.companyId,
      @required this.description,
      @required this.descriptionAr,
      @required this.endDate,
      @required this.imageURL,
      @required this.startDate,
      @required this.title,
      @required this.titleAr})
      : assert(companyId != null),
        assert(description != null),
        assert(descriptionAr != null),
        assert(endDate != null),
        assert(imageURL != null),
        assert(startDate != null),
        assert(title != null),
        assert(titleAr != null);
}
