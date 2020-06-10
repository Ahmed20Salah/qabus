import 'package:flutter/material.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/qabuss_icons_icons.dart';

class Data {
  static final List _categories = [
    {
      'title': 'Nearby',
    },
    {
      'icon': QabussIcons.sunglasses,
      'title': 'Accessories & Jewelry',
      'color': Color(0xFF9258F8)
    },
    {
      'icon': QabussIcons.car_wheel,
      'title': 'Automotive',
      'color': Color(0xFF4D4D4D)
    },
    {
      'icon': QabussIcons.cupcake,
      'title': 'Bakery & Desserts',
      'color': Color(0xFFEF2D2D)
    },
    {
      'icon': QabussIcons.bank,
      'title': 'Banks & Financial',
      'color': Color(0xFFF6B801)
    },
    {
      'icon': QabussIcons.beauty_cosmetics,
      'title': 'Beauty & Cosmetics',
      'color': Color(0xFFFF9B43)
    },
    {
      'icon': QabussIcons.cocktail,
      'title': 'Beverages',
      'color': Color(0xFF3AB0C8)
    },
    {
      'icon': QabussIcons.skyline,
      'title': 'Business & Industrial',
      'color': Color(0xFF23B964)
    },
    {
      'icon': QabussIcons.cafe_coffee_shop,
      'title': 'Cafe & Coffee Shop',
      'color': Color(0xFF885053)
    },
    {
      'icon': QabussIcons.clinics,
      'title': 'Clinics',
      'color': Color(0xFFFD5F54)
    },
    {
      'icon': QabussIcons.siren,
      'title': 'Emergency',
      'color': Color(0xFFEF2D2D)
    },
    {
      'icon': QabussIcons.fashion,
      'title': 'Fashion',
      'color': Color(0xFF5864F8)
    },
    {
      'icon': QabussIcons.dumbbell,
      'title': 'Fitness',
      'color': Color(0xFFFF9B43)
    },
    {
      'icon': QabussIcons.gift,
      'title': 'Flowers & Gifts',
      'color': Color(0xFFF544AE)
    },
    {
      'icon': QabussIcons.flower,
      'title': 'Home & Garden',
      'color': Color(0xFF23B964)
    },
    {
      'title': 'Home Services',
    },
    {
      'title': 'Hotel & Travel',
    },
    {'icon': QabussIcons.puzzle, 'title': 'Kids', 'color': Color(0xFF23B964)},
    {
      'title': 'Mall',
    },
    {
      'title': 'Markets',
    },
    {
      'title': 'Media',
    },
    {'icon': QabussIcons.museum, 'title': 'Museum', 'color': Color(0xFF726CAA)},
    {
      'title': 'Perfumes',
    },
    {
      'title': 'Restaurants',
    },
    {
      'icon': QabussIcons.salons_spas,
      'title': 'Salons & Spas',
      'color': Color(0xFFF6B801)
    },
  ];

  static get serverURL => 'https://qabuss.com/';

  static Map<String, String> get apis => {
        'ABOUT': '/api/qab_page/ABT10023',
        'LOCATE': '/api/qab_page/LCT10023',
        'TERMS': '/api/qab_page/TRM10023',
        'HELP': '/api/qab_page/NDH10023',
        'QATAR': '/api/qab_qatar',
      };

  static List<Map<String, dynamic>> get topics => [
    {
      'title': 'Shopping',
      'key': 'shopping',
      'children': [
        {'key': 'hypermarket', 'name': 'HyperMarket', 'isSelected': false},
        {'key': 'supermarket', 'name': 'SuperMarket', 'isSelected': false}
      ]
    },
    {
      'title': 'Companies',
      'key': 'companies',
      'children': [
        {'key': 'exchange', 'name': 'Exchange', 'isSelected': false},
        {'key': 'finance', 'name': 'Finance', 'isSelected': false},
        {'key': 'vehicle', 'name': 'Vehicle Agent', 'isSelected': false}

      ]
    }
  ];
}
