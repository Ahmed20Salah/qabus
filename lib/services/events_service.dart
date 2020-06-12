import 'dart:convert';

import 'package:qabus/modals/event.dart';
import 'package:qabus/url.dart';
import 'package:http/http.dart' as http;

class EventsService {
  static Future<List<Event>> getAllEvents() async {
    try {
      final String url = URLs.serverURL + URLs.allEvents;
      final response = await http.get(url);
      final jsonData = (json.decode(response.body));
      print(jsonData);
      final List<Event> offers = createEventItemList(jsonData['data']);
      return offers;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Event>> searchForEvents(String text) async {
    try {
      final String url = URLs.serverURL + URLs.searchEvents;
      final response = await http.post(url, body: {'search': text});
      final jsonData = (json.decode(response.body));
      final List<Event> offers = createEventItemList(jsonData['data']);
      return offers;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<Event> createEventItemList(jsonData) {
    // print(jsonData);
    List<Event> events = [];
    print(jsonData);
    for (var item in jsonData) {
      print(item['category']);
      events.add(
        Event(
          address: item['location'],
          addressAr: item['locationArb'],
          amount: double.parse(item['amount']),
          description: item['descriptionEn'],
          descriptionAr: item['descriptionArb'],
          email: item['email'],
          endDate: DateTime.parse(item['enddate']),
          id: int.parse(item['id']),
          imageURL: item['image'],
          lat: double.parse(item['lat']),
          lng: double.parse(item['lng']),
          phone: item['phone'],
          startDate: DateTime.parse(item['startdate']),
          title: item['headingEn'],
          titleAr: item['headingArb'],
        ),
      );
    }

    return events;
  }
}
