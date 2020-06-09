import 'package:flutter/material.dart';

class BusinessListItem {
  String id;
  String name;
  String nameAr;
  String address;
  String addressAr;
  String lat;
  String lng;
  String profileImage;
  String backgroundImage;

  BusinessListItem({
    @required this.id,
    @required this.name,
    @required this.nameAr,
    @required this.address,
    @required this.addressAr,
    @required this.backgroundImage,
    @required this.lat,
    @required this.lng,
    @required this.profileImage,
  })  : assert(id != null),
        assert(name != null),
        assert(nameAr != null),
        assert(address != null),
        assert(addressAr != null),
        assert(backgroundImage != null),
        assert(lat != null),
        assert(lng != null),
        assert(profileImage != null);
}
