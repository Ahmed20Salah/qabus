import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qabus/modals/area.dart';
import 'package:qabus/modals/business.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/modals/event.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/modals/slider.dart';
import 'package:qabus/modals/sub_category.dart';
import 'package:qabus/services/events_service.dart';
import 'package:qabus/services/news_service.dart';
import 'package:qabus/services/offers_service.dart';
import 'package:qabus/url.dart';

class ExplorePageService {
  static Future<bool> addBusiness(
      String userId, dynamic data, File file1, File file2) async {
    final String url = URLs.serverURL + URLs.addBusiness + userId;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      //add text fields
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      //create multipart using filepath, string or bytes
      var profileImage =
          await http.MultipartFile.fromPath("profileimage", file1.path);
      var backgroundImage =
          await http.MultipartFile.fromPath("backgroundimage", file2.path);
      //add multipart to request
      request.files.add(profileImage);
      request.files.add(backgroundImage);
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> editBusiness(String userId, data) async {
    final String url = URLs.serverURL + URLs.editBusiness + userId;
    try {
      final response = await http.post(url, body: json.encode(data));
      final jsonData = (json.decode(response.body));
      if (jsonData['response'] == '0') {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static List<Category> _createCategories(data) {
    List<Category> categories = [];

    data.forEach((item) {
      categories.add(Category(
        title: item['name'],
        id: int.parse(item['id'].toString()),
        image: item['icon'],
        titleArb: item['nameArb'],
      ));
    });
    return categories;
  }

  static Future<List<Category>> getAllCategories() async {
    try {
      final response = await http.get(URLs.serverURL + URLs.allCategories);
      final jsonData = (json.decode(response.body))['data'];
      return _createCategories(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Category>> getMainCategories() async {
    try {
      final response = await http.get(URLs.serverURL + URLs.mainCategories);
      final jsonData = (json.decode(response.body))['data'];
      return _createCategories(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<BusinessListItem>> getBusinessesFromCategory(
      int categoryId) async {
    try {
      final String url =
          URLs.serverURL + URLs.businessFromCategory + categoryId.toString();
      final response = await http.get(url);
      final jsonData = (json.decode(response.body))['business'];
      return createBusinessListItemFromList(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getTopicCategories() async {
    try {
      final String url = URLs.serverURL + URLs.topics;
      final response = await http.get(url);
      final jsonData = (json.decode(response.body));
      final mainCategoriesData = jsonData['maincategory'];
      final subCategoriesData = jsonData['subcategory'];
      final List<SubCategory> subCategories = [];
      subCategoriesData.forEach((item) {
        subCategories.add(
          SubCategory(
            title: item['name'],
            id: int.parse(item['id'].toString()),
            image: item['icon'],
            titleArb: item['nameArb'],
            parentID: int.parse(item['parent'].toString()),
          ),
        );
      });
      final mainCategories = _createCategories(mainCategoriesData);
      return _createTopicsList(mainCategories, subCategories);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<SubCategory>> getTopicSubCategories() async {
    try {
      final String url = URLs.serverURL + URLs.topics;
      final response = await http.get(url);
      final jsonData = (json.decode(response.body));
      final subCategoriesData = jsonData['subcategory'];
      final List<SubCategory> subCategories = [];
      subCategoriesData.forEach((item) {
        subCategories.add(
          SubCategory(
            title: item['name'],
            id: int.parse(item['id'].toString()),
            image: item['icon'],
            titleArb: item['nameArb'],
            parentID: int.parse(item['parent'].toString()),
          ),
        );
      });
      return subCategories;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<Map<String, dynamic>> _createTopicsList(
    List<Category> categories,
    List<SubCategory> subcategories,
  ) {
    List<Map<String, dynamic>> finalList = [];

    categories.forEach((category) {
      final List<SubCategory> subcats = List.from(subcategories);
      subcats.retainWhere(
        (subcategory) => subcategory.parentID == category.id,
      );
      finalList.add({
        'category': category,
        'subcategories': subcats,
      });
    });
    return finalList;
  }

  static Future<bool> saveTopicsToPhone(List<int> selectedCategories) async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'topics', value: selectedCategories.join(','));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveTopics(List<int> topics, String userId) async {
    if (topics == null || topics.length < 1) {
      return false;
    }
    try {
      final String url = URLs.serverURL + URLs.saveTopics + userId;
      var postData = {};
      for (var i = 0; i < topics.length; i++) {
        postData['recommend[$i]'] = topics[i].toString();
      }
      final response = await http.post(url, body: postData);
      final jsonData = (json.decode(response.body));
      if (jsonData['response'] == '0') {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<BusinessItem> getBusinessItem(
      String businessId, String userId) async {
    if (businessId == null) {
      return null;
    }
    try {
      final String url = URLs.serverURL + URLs.getSingleBusinessURL(businessId);
      var postData = {};
      if (userId != null) {
        postData = {
          'userId': userId,
        };
      }
      final response = await http.post(url, body: postData);
      final jsonMainData = (json.decode(response.body));
      BusinessItem businessItem = createBusinessItem(jsonMainData);
      return businessItem;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static BusinessItem createBusinessItem(jsonMainData) {
    Map<String, dynamic> jsonData = jsonMainData['data'];
    Map<String, dynamic> businessData = jsonData['business'][0];
    return BusinessItem(
      address: businessData['companylocation'],
      addressAr: businessData['companylocationArb'],
      backgroundImage: businessData['background_image'],
      id: businessData['registerId'],
      lat: double.parse(businessData['lat']),
      lng: double.parse(businessData['lng']),
      name: businessData['companyname'],
      nameAr: businessData['companynameArb'],
      profileImage: businessData['profile_image'],
      companyCategoryId: int.parse(businessData['companycategory']),
      description: businessData['companydescription'],
      descriptionAr: businessData['companydescriptionArb'],
      email: businessData['company_email'],
      phone: businessData['companyphone'],
      tagline: businessData['company_tagline'],
      taglineAr: businessData['company_taglineArb'],
      websiteUrl: businessData['company_website'],
      facilities: BusinessFacilities.fromJson(
        jsonData['facilities'][0],
      ),
      timing: BusinessTiming.fromJson(
        jsonData['working'][0],
      ),
      offers: OffersService.createOfferItemList(jsonData['offers']),
      reviews: _createReviewsList(jsonData['review']),
      openStatusText: jsonMainData['time'],
      relatedBusinesses: createBusinessListItemFromList(jsonMainData['relate']),
      isFavorite: jsonMainData['favorite'],
    );
  }

  static Future<List<BusinessListItem>> getBusinessByDistance(
      double lat, double lng, int categoryId) async {
    try {
      final String url = URLs.serverURL +
          URLs.businessByDistance +
          categoryId.toString() +
          '/lat/$lat/lng/$lng';
      final response = await http.get(url);
      final jsonData = (json.decode(response.body))['business'];
      return createBusinessListItemFromList(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> toggleFavorite(String businessID, String userID) async {
    try {
      final String url =
          URLs.serverURL + URLs.getFavoriteURL(userID, businessID);
      final response = await http.delete(url);
      final status = (json.decode(response.body))['response'];
      if (status == 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<BusinessListItem> createBusinessListItemFromList(jsonData) {
    List<BusinessListItem> businesses = [];
    jsonData.forEach((item) {
      businesses.add(
        BusinessListItem(
          address: item['companylocation'],
          addressAr: item['companylocationArb'],
          backgroundImage: item['background_image'],
          id: item['registerId'],
          lat: item['lat'],
          lng: item['lng'],
          name: item['companyname'],
          nameAr: item['companynameArb'],
          profileImage: item['profile_image'],
        ),
      );
    });
    return businesses;
  }

  static Future<List<Area>> getAreas() async {
    try {
      final response = await http.get(URLs.serverURL + URLs.areas);
      final jsonData = (json.decode(response.body))['data'];
      List<Area> areas = [];
      jsonData.forEach((item) {
        areas.add(Area(
          name: item['locationEn'],
          id: item['id'],
          nameAr: item['locationArb'],
        ));
      });
      return areas;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<BusinessListItem>> getBusinessByArea(
      List<Area> areas, int categoryId) async {
    try {
      final String url =
          URLs.serverURL + URLs.businessByArea + categoryId.toString();
      Map<String, String> postData = {};
      for (var i = 0; i < areas.length; i++) {
        postData['area[$i]'] = areas[i].id.toString();
      }
      final response = await http.post(url, body: postData);
      final jsonData = (json.decode(response.body))['business'];
      return createBusinessListItemFromList(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static List<Review> _createReviewsList(jsonData) {
    List<Review> reviews = [];
    jsonData.forEach((item) {
      reviews.add(Review(
        email: item['email'],
        message: item['message'],
        name: item['name'],
        rating: double.parse(item['rate']),
      ));
    });
    return reviews;
  }

  static Future<Map<String, dynamic>> getHomePageContentWithUser(
    String userId,
    double lat,
    double lng,
  ) async {
    try {
      final String url = URLs.serverURL + URLs.homePage;
      final response = await http.post(url, body: {
        'userid': userId,
        'lat': lat.toString(),
        'lng': lng.toString(),
      });
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      final jsonData = json.decode(response.body);
      return _createHomePageContent(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>> getHomePageContent(
    double lat,
    double lng,
  ) async {
    try {
      final storage = new FlutterSecureStorage();
      final String savedTopics = await storage.read(key: 'topics');
      if (savedTopics == null) {
        return null;
      }
      final List<int> topics =
          savedTopics.split(',').map((i) => int.parse(i)).toList();

      final String url = URLs.serverURL + URLs.homePage;
      Map<String, String> postBody = {};
      postBody['lat'] = lat.toString();
      postBody['lng'] = lng.toString();
      for (var i = 0; i < topics.length; i++) {
        postBody['category[$i]'] = topics[i].toString();
      }
      final response = await http.post(url, body: postBody);
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      final jsonData = json.decode(response.body);
      return _createHomePageContent(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Map<String, dynamic> _createHomePageContent(jsonData) {
    final List<SliderModal> sliders = _createSlidersList(jsonData['Slider']);
    final List<Category> categories = _createCategories(jsonData['Category']);
    final List<BusinessListItem> recomendedBusinesses =
        _createRecomendedList(jsonData['Recommend']);
    final List<BusinessListItem> newBusiness =
        createBusinessListItemFromList(jsonData['NewlyBusines']);
    final List<Offer> offers =
        OffersService.createOfferItemList(jsonData['Offers']);
    final List<Event> events =
        EventsService.createEventItemList(jsonData['Events']);
    final List<BusinessListItem> featuredBusiness =
        createBusinessListItemFromList(jsonData['Featured']);

    return {
      'sliders': sliders,
      'categories': categories,
      'recomendedBusinesses': recomendedBusinesses,
      'newBusiness': newBusiness,
      'offers': offers,
      'events': events,
      'featuredBusiness': featuredBusiness
    };
  }

  static List<BusinessListItem> _createRecomendedList(data) {
    List<BusinessListItem> businesses = [];
    data.forEach((item) {
      businesses.addAll(createBusinessListItemFromList(item));
    });
    return businesses;
  }

  static List<SliderModal> _createSlidersList(data) {
    List<SliderModal> sliders = [];
    data.forEach((item) =>
        sliders.add(SliderModal(id: item['id'], imageURL: item['slider'])));
    return sliders;
  }

  static Future<Map<String, dynamic>> searchText(String searchText) async {
    try {
      final String url = URLs.serverURL + URLs.search;
      final response = await http.post(url, body: {'search': searchText});
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      final jsonData = json.decode(response.body);
      final Map<String, dynamic> result = {
        'listings': createBusinessListItemFromList(jsonData['Business']),
        'events': EventsService.createEventItemList(jsonData['Events']),
        'articles': NewsService.createNewsListFromList(jsonData['News']),
        'offers': OffersService.createOfferItemList(jsonData['Offers']),
      };
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> deleteListing(String userId, String businessId) async {
    try {
      final String url =
          URLs.serverURL + URLs.deleteBusiness(businessId, userId);
      final response = await http.delete(url);
      if ((json.decode(response.body))['response'] == 0) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
