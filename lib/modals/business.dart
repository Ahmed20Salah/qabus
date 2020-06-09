import 'package:flutter/material.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/offer.dart';

class BusinessItem {
  final String id;
  final String name;
  final String nameAr;
  final String address;
  final String addressAr;
  final String description;
  final String descriptionAr;
  final int companyCategoryId;
  final double lat;
  final double lng;
  final String profileImage;
  final String backgroundImage;
  final String tagline;
  final String taglineAr;
  final String phone;
  final String websiteUrl;
  final String email;
  final BusinessFacilities facilities;
  final BusinessTiming timing;
  final List<Offer> offers;
  List<Review> reviews;
  final String openStatusText;
  final List<BusinessListItem> relatedBusinesses;
  final bool isFavorite;

  BusinessItem({
    @required this.id,
    @required this.name,
    @required this.nameAr,
    @required this.address,
    @required this.addressAr,
    @required this.description,
    @required this.descriptionAr,
    @required this.companyCategoryId,
    @required this.backgroundImage,
    @required this.lat,
    @required this.lng,
    @required this.profileImage,
    @required this.tagline,
    @required this.taglineAr,
    @required this.phone,
    @required this.websiteUrl,
    @required this.email,
    @required this.facilities,
    @required this.timing,
    this.offers,
    this.reviews,
    this.relatedBusinesses,
    this.isFavorite: false,
    @required this.openStatusText,
  })  : assert(id != null),
        assert(name != null),
        assert(nameAr != null),
        assert(address != null),
        assert(addressAr != null),
        assert(description != null),
        assert(descriptionAr != null),
        assert(companyCategoryId != null),
        assert(backgroundImage != null),
        assert(lat != null),
        assert(lng != null),
        assert(profileImage != null),
        assert(tagline != null),
        assert(taglineAr != null),
        assert(phone != null),
        assert(websiteUrl != null),
        assert(email != null),
        assert(facilities != null),
        assert(openStatusText != null),
        assert(timing != null);
}

class BusinessFacilities {
  final bool carparking;
  final bool wifi;
  final bool prayerroom;
  final bool wheelchair;
  final bool creditcard;
  final bool is24hours;

  BusinessFacilities.fromJson(Map<String, dynamic> facilities)
      : carparking = int.parse(facilities['carparking']) == 1 ? true : false,
        wifi = int.parse(facilities['wifi']) == 1 ? true : false,
        prayerroom = int.parse(facilities['prayerroom']) == 1 ? true : false,
        wheelchair = int.parse(facilities['wheelchair']) == 1 ? true : false,
        creditcard = int.parse(facilities['creditcard']) == 1 ? true : false,
        is24hours = int.parse(facilities['alltimeservice']) == 1 ? true : false;

  List<Map<String, dynamic>> get facilitiesList => [
        {
          'name': 'carParking',
          'value': carparking,
          'icon': Icons.local_parking
        },
        {'name': 'wifi', 'value': wifi, 'icon': Icons.wifi},
        {'name': 'prayerRoom', 'value': prayerroom, 'icon': Icons.person},
        {'name': 'wheelChair', 'value': wheelchair, 'icon': Icons.accessible},
        {'name': 'creditCard', 'value': creditcard, 'icon': Icons.credit_card},
        {'name': '24Hours', 'value': is24hours, 'icon': Icons.access_time}
      ];

  List<Map<String, dynamic>> get availableList {
    List<Map<String, dynamic>> items = [];
    facilitiesList.forEach((item) {
      if (item['value'] == true) {
        items.add(item);
      }
    });
    return items;
  }
}

class BusinessTiming {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  BusinessTiming.fromJson(Map<String, dynamic> timing)
      : monday = timing['Monday'],
        tuesday = timing['Tuesday'],
        wednesday = timing['Wednesday'],
        thursday = timing['Thursday'],
        friday = timing['Friday'],
        saturday = timing['Saturday'],
        sunday = timing['Sunday'];

  List<Map<String, String>> get allDays => [
        {'value': this.monday, 'day': 'Monday'},
        {'value': this.tuesday, 'day': 'Tuesday'},
        {'day': 'Wednesday', 'value': this.wednesday},
        {'day': 'Thursday', 'value': this.thursday},
        {'day': 'Friday', 'value': this.friday},
        {'day': 'Saturday', 'value': this.saturday},
        {'day': 'Sunday', 'value': this.sunday}
      ];
}

class Review {
  final String name;
  final String email;
  final String message;
  final double rating;

  Review({this.email, this.message, this.name, this.rating})
      : assert(name != null),
        assert(email != null),
        assert(message != null),
        assert(rating != null);
}
