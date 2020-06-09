import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/offers_service.dart';
import 'package:qabus/url.dart';
import 'package:http/http.dart' as http;

enum ACCOUNT_STATE { LOGGED_IN, NEW, LOGGED_OUT }

class AccountService {
  User _currentUser;
  StreamController<User> _authController = StreamController<User>();

  User get currentUser => _currentUser;

  Stream<User> get authStream => _authController.stream.asBroadcastStream();

  void logout() {
    _authController.add(null);
    _currentUser = null;
    final storage = new FlutterSecureStorage();
    storage.delete(key: 'email');
    storage.delete(key: 'password');
  }

  Future<ACCOUNT_STATE> initialSetup() async {
    final storage = new FlutterSecureStorage();
    final String email = await storage.read(key: 'email');
    final String password = await storage.read(key: 'password');
    final String savedTopics = await storage.read(key: 'topics');
    if (savedTopics == null) {
      return ACCOUNT_STATE.NEW;
    }
    if (savedTopics == '') {
      return ACCOUNT_STATE.NEW;
    }
    final List<int> topics =
        savedTopics.split(',').map((i) => int.parse(i)).toList();

    if (topics == null || topics.isEmpty) {
      return ACCOUNT_STATE.NEW;
    }

    if (email == null || password == null) {
      return ACCOUNT_STATE.LOGGED_OUT;
    }

    User user = await login(email, password);
    if (user == null) {
      _currentUser = user;
      _authController.add(user);
      return ACCOUNT_STATE.LOGGED_OUT;
    }

    _authController.add(user);
    return ACCOUNT_STATE.LOGGED_IN;
  }

  Future<User> login(String email, String password) async {
    try {
      final String url = URLs.serverURL + URLs.login;
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);
      final jsonData = (json.decode(response.body))['data'];
      final User user = _createUser(jsonData);
      _currentUser = user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> register(
    String email,
    String password,
  ) async {
    try {
      final String url = URLs.serverURL + URLs.register;
      Map<String, String> postData = {
        'email': email,
        'password': password,
      };
      final storage = new FlutterSecureStorage();
      final String savedTopics = await storage.read(key: 'topics');
      if (savedTopics == null) {
        return null;
      }
      final List<int> topics =
          savedTopics.split(',').map((i) => int.parse(i)).toList();
      for (var i = 0; i < topics.length; i++) {
        postData['category[$i]'] = topics[i].toString();
      }
      final response = await http.post(url, body: postData);
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      final jsonData = (json.decode(response.body))['data'];
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);
      final User user = _createUser(jsonData);
      _currentUser = user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getProfileData(String userId) async {
    try {
      final String url = URLs.serverURL + URLs.loggedInUserDashboard + userId;
      final response = await http.get(url);
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      final jsonData = json.decode(response.body);
      final User user = _createUser(jsonData['User'][0]);
      final List<BusinessListItem> businesses =
          ExplorePageService.createBusinessListItemFromList(
              jsonData['Business']);
      final List<Offer> offers =
          OffersService.createOfferItemList(jsonData['Offers']);
      final List<BusinessListItem> favorites =
          ExplorePageService.createBusinessListItemFromList(
              jsonData['Favourite']);
      return {
        'user': user,
        'businesses': businesses,
        'offers': offers,
        'favorites': favorites,
      };
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateProfile(
      String name, String email, String phone, String userId) async {
    try {
      final String url = URLs.serverURL + URLs.updateProfile + userId;
      final response = await http
          .post(url, body: {'email': email, 'phone': phone, 'name': name});
      if ((json.decode(response.body))['response'] == 0) {
        return null;
      }
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  User _createUser(data) {
    return User(
      email: data['email'],
      id: data['id'],
      imageURL: data['image'],
      limit: data['limit'],
      name: data['name'],
      phone: data['phone'],
      userId: data['registerid'],
      userType: _getUserType(data['type']),
    );
  }

  USER_TYPE _getUserType(String userType) {
    switch (userType) {
      case 'superAdmin':
        return USER_TYPE.SUPER_ADMIN;
        break;
      case 'user':
        return USER_TYPE.USER;
        break;
      default:
        return USER_TYPE.NONE;
    }
  }

  void updateUser(String name, String email, String phone) {
    _currentUser.updateProfile(name, email, phone);
    _authController.add(_currentUser);
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final String url = URLs.serverURL + URLs.forgotPassword;
      final response = await http.post(url, body: {
        'email': email,
      });
      if ((json.decode(response.body))['response'] == 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String old, String newPass, String userId) async {
    try {
      final String url = URLs.serverURL + URLs.resetPassword + userId;
      final response = await http.post(url, body: {
        'oldpassword': old,
        'newpassword': newPass,
        'confirmpass': newPass,
      });
      if ((json.decode(response.body))['response'] == 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void dispose() {
    _authController.close();
  }
}
