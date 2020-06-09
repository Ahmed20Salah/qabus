import 'package:flutter/material.dart';
import 'package:qabus/modals/business_list_item.dart';

enum USER_TYPE { SUPER_ADMIN, NONE, USER, BUSINESS }

class User {
  final int id;
  final String userId;
  String name;
  String email;
  String phone;
  String imageURL;
  final String limit;
  final USER_TYPE userType;
  final List<BusinessListItem> favorites;

  User({
    @required this.id,
    @required this.email,
    @required this.imageURL,
    @required this.limit,
    @required this.name,
    @required this.phone,
    @required this.userType,
    @required this.userId,
    this.favorites,
  })  : assert(id != null),
        assert(email != null),
        assert(imageURL != null),
        assert(userType != null),
        assert(userId != null);

  updateProfile(String name, String email, String phone) {
    this.name = name;
    this.email = email;
    this.phone = phone;
  }
}
