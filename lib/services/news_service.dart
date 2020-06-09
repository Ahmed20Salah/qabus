import 'dart:convert';

import 'package:qabus/modals/news.dart';
import 'package:qabus/modals/news_category.dart';
import 'package:http/http.dart' as http;
import 'package:qabus/url.dart';

class NewsService {
  static Future<List<NewsCategory>> getAllCategories() async {
    try {
      final response = await http.get(URLs.serverURL + URLs.newsCategories);
      final jsonData = (json.decode(response.body))['data'];
      List<NewsCategory> categories = [];
      jsonData.forEach((item) {
        categories.add(NewsCategory(
          name: item['name'],
          id: int.parse(item['id']),
          nameAr: item['nameArb'],
        ));
      });
      return categories;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<News>> getAllNews() async {
    try {
      final response = await http.get(URLs.serverURL + URLs.news);
      final jsonData = (json.decode(response.body))['data'];
      return createNewsListFromList(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<News> createNewsListFromList(jsonData) {
    List<News> news = [];
    jsonData.forEach((item) {
      news.add(News(
        author: item['name'],
        category: int.parse(item['category']),
        description: item['descriptionEn'],
        descriptionAr: item['descriptionArb'],
        id: item['registerid'],
        imageURL: item['image'],
        summery: item['summeryEn'],
        summeryAr: item['summeryArb'],
        title: item['headingEn'],
        titleAr: item['headingArb'],
      ));
    });
    return news;
  }

  static Future<Map<String, List<News>>> getSingleNews(String id) async {
    try {
      final response = await http.get(URLs.serverURL + URLs.news + '/$id');
      final jsonData = (json.decode(response.body));
      Map<String, List<News>> result = {
        'news': createNewsListFromList(jsonData['news']),
        'related': createNewsListFromList(jsonData['relate']),
      };
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<News>> searchNews(String text) async {
    try {
      final response =
          await http.get(URLs.serverURL + URLs.newsSearch + '$text');
      final jsonData = (json.decode(response.body));
      return createNewsListFromList(jsonData['news']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<News>> getNewsFromCategory(int categoryId) async {
    try {
      final response = await http
          .get(URLs.serverURL + URLs.newsFromCategory + '$categoryId');
      final jsonData = (json.decode(response.body));
      return createNewsListFromList(jsonData['data']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
