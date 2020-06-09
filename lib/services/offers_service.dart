import 'dart:convert';

import 'package:qabus/modals/offer.dart';
import 'package:qabus/modals/offer_tag.dart';
import 'package:qabus/url.dart';
import 'package:http/http.dart' as http;

class OffersService {
  static List<Offer> createOfferItemList(jsonData) {
    List<Offer> offers = [];
    jsonData.forEach((item) {
      offers.add(
        Offer(
          companyId: item['companyid'],
          description: item['descriptionEn'],
          descriptionAr: item['descriptionArb'],
          endDate: DateTime.parse(item['enddate']),
          imageURL: item['image'],
          startDate: DateTime.parse(item['startdate']),
          title: item['headingEn'],
          titleAr: item['headingArb'],
        ),
      );
    });
    return offers;
  }

  static Future<Map<String, dynamic>> getAllOffers() async {
    try {
      final String url = URLs.serverURL + URLs.allOffers;
      final response = await http.get(url);
      final jsonData = (json.decode(response.body));
      final List<Offer> offers = createOfferItemList(jsonData['Offers']);
      final List<OfferTag> offerTags =
          _createOfferTagList(jsonData['Offerstag']);
      return {
        'offers': offers,
        'tags': offerTags,
      };
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<OfferTag> _createOfferTagList(jsonData) {
    List<OfferTag> offertags = [];
    jsonData.forEach((item) {
      offertags.add(
        OfferTag(
          name: item['nameEn'],
          id: int.parse(item['id']),
          nameAr: item['nameArb'],
        ),
      );
    });
    return offertags;
  }

  static Future<List<Offer>> sortOffersById(OfferTag tag) async {
    try {
      final String url = URLs.serverURL + URLs.sortOffers;
      final response = await http.post(url, body: {'id': tag.id.toString()});
      final jsonData = (json.decode(response.body));
      final List<Offer> offers = createOfferItemList(jsonData);
      return offers;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
