import 'package:flutter/material.dart';
import 'package:qabus/pages/articles/article.dart';
import 'package:qabus/pages/articles/articles.dart';
import 'package:qabus/pages/events/event.dart';
import 'package:qabus/pages/events/events.dart';
import 'package:qabus/pages/explore/explore.dart';
import 'package:qabus/pages/offers/offers.dart';
import 'package:qabus/pages/qatar.dart';

class Routes {
  static const String explore = 'explore';
  static const String listing = 'listing';
  static const String article = 'article';
  static const String articles = 'articles';
  static const String event = 'event';
  static const String events = 'events';
  static const String qatar = 'qatar';
  static const String offers = 'offers';

  final PageStorageKey _exploreKey = PageStorageKey('explore');

  Map<String, WidgetBuilder> routeBuilders(BuildContext context) {
    return {
      explore: (context) => ExplorePage(_exploreKey),
      articles: (context) => ArticlesPage(),
      event: (BuildContext context) => EventPage(),
      events: (context) => EventsPage(),
      qatar: (context) => QatarPage(),
      offers: (context) => OffersPage(),
    };
  }
}
