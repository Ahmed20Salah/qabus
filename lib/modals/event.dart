import 'package:flutter/material.dart';

class Event {
  final int id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final DateTime startDate;
  final DateTime endDate;
  final double amount;
  final String phone;
  final String email;
  final String imageURL;
  final String category;
  final double lat;
  final double lng;
  final String address;
  final String addressAr;


  Event({
    @required this.address,
    @required this.addressAr,
    @required this.amount,
    @required this.category,
    @required this.description,
    @required this.descriptionAr,
    @required this.email,
    @required this.endDate,
    @required this.id,
    @required this.imageURL,
    @required this.lat,
    @required this.lng,
    @required this.phone,
    @required this.startDate,
    @required this.title,
    @required this.titleAr,
  })  : assert(address != null),
        assert(amount != null),
        assert(category != null),
        assert(description != null),
        assert(descriptionAr != null),
        assert(email != null),
        assert(endDate != null),
        assert(id != null),
        assert(imageURL != null),
        assert(lat != null),
        assert(lng != null),
        assert(phone != null),
        assert(startDate != null),
        assert(title != null),
        assert(titleAr != null);
}
