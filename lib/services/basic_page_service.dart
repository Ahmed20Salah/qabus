import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:qabus/data.dart';
import 'package:qabus/modals/basic_page_content.dart';
import 'package:qabus/modals/qatar_page_content.dart';

class BasicPageService {
  static Future<BasicPageContent> getContent(String code) async {
    final String link = Data.apis[code];
    if (link.isEmpty) {
      return null;
    }

    try {
      final String url = Data.serverURL + link;
      final response = await http.get(url);
      final jsonData = (json.decode(response.body))['data'];
      return BasicPageContent(
          content: jsonData['descriptionEn'],
          contentAr: jsonData['descriptionArb'],
          title: jsonData['nameEn'],
          titleAr: jsonData['nameArb']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<QatarPageContent>> getQatarContent() async {
    final String link = Data.apis['QATAR'];
    if (link.isEmpty) {
      return null;
    }

    try {
      final String url = Data.serverURL + link;
      final response = await http.get(url);
      final List jsonData = (json.decode(response.body))['data'];
      List<QatarPageContent> data = jsonData.map((item) {
        return QatarPageContent(
          content: item['descriptionEn'],
          contentAr: item['descriptionArb'],
          title: item['nameEn'],
          titleAr: item['nameArb'],
          summery: item['summeryEn'],
          summeryAr: item['summeryArb'],
          image: item['image']
        );
      }).toList();
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
