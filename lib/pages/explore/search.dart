import 'package:flutter/material.dart';
import 'package:qabus/components/article_card.dart';
import 'package:qabus/components/event_card.dart';
import 'package:qabus/components/listing_item_list.dart';
import 'package:qabus/components/offer_item.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/event.dart';
import 'package:qabus/modals/news.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/pages/articles/article.dart';
import 'package:qabus/pages/events/event.dart';
import 'package:qabus/pages/explore/listing.dart';
import 'package:qabus/pages/explore/widget_list.dart';
import 'package:qabus/pages/offers/offer_detail.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/localization.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Offer> _offers = [];
  List<BusinessListItem> _business = [];
  List<Event> _events = [];
  List<News> _articles = [];
  bool _hasError = false;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  void _search(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      final String searchText = _searchController.text;
      if (searchText == null || searchText.trim().isEmpty) {
        FocusScope.of(context).requestFocus(_searchNode);
        return;
      }
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      final Map<String, dynamic> data =
          await ExplorePageService.searchText(searchText);
      if (data == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }
      setState(() {
        _offers = data['offers'];
        _articles = data['articles'];
        _business = data['listings'];
        _events = data['events'];
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String searchText = _searchController.text;
    final int totalResults =
        _offers.length + _business.length + _events.length + _articles.length;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (_hasError
                ? Center(
                    child:
                        Text(AppLocalizations.of(context).translate('errorText')),
                  )
                : ListView(
                    children: <Widget>[
                      searchText.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                totalResults.toString() +
                                    (totalResults > 1
                                        ? AppLocalizations.of(context).translate('resultsPlural')
                                        : AppLocalizations.of(context).translate('resultsSingle')) +
                                        AppLocalizations.of(context).translate('foundFor') +
                                    ' "$searchText"',
                                style: Theme.of(context).textTheme.display3,
                              ),
                            )
                          : Container(),
                      _buildListingResults(context),
                      _buildEventsResults(context),
                      _buildArticleResults(context),
                      _buildOffersResults(context),
                    ],
                  )),
      ),
    );
  }

  void onListingPressed(String businessId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ListingPage(businessId),
      ),
    );
  }

  void onListingsSeeAllPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: AppLocalizations.of(context).translate('allListings'),
          widgets: _business
              .map((item) =>
                  ListingItemListView(() => onListingPressed(item.id), item))
              .toList(),
        ),
      ),
    );
  }

  void onOffersSeeAllPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: AppLocalizations.of(context).translate('allOffers'),
          widgets: _offers.map((item) => _buildOfferItem(item)).toList(),
        ),
      ),
    );
  }

  void onArticlesSeeAllPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: AppLocalizations.of(context).translate('allArticles'),
          widgets: _articles.map((item) => _buildArticleItem(item)).toList(),
        ),
      ),
    );
  }

  void onEventsSeeAllPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: AppLocalizations.of(context).translate('allEvents'),
          widgets: _events.map((item) => onEventPressed(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildListingResults(BuildContext context) {
    if (_business.length < 1) {
      return Container();
    }
    return Column(
      children: <Widget>[
        _buildSectionHeading(context, AppLocalizations.of(context).translate('listings'), onListingsSeeAllPressed),
        ListingItemListView(
            () => onListingPressed(_business[0].id), _business[0]),
        _business.length > 1
            ? ListingItemListView(
                () => onListingPressed(_business[1].id), _business[1])
            : Container()
      ],
    );
  }

  Widget _buildOfferItem(Offer offer) {
    return GestureDetector(
      child: Container(
        child: OfferItem(
          offer: offer,
          width: MediaQuery.of(context).size.width - 40,
        ),
        height: 130,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OfferDetail(offer),
          ),
        );
      },
    );
  }

  Widget _buildOffersResults(BuildContext context) {
    if (_offers.length < 1) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionHeading(context, AppLocalizations.of(context).translate('offers'), _offers.length > 2 ? onOffersSeeAllPressed: null),
        _buildOfferItem(_offers[0]),
        _offers.length > 1 ? _buildOfferItem(_offers[1]) : Container()
      ],
    );
  }

  Widget _buildArticleItem(News news) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ArticlePage(news),
          ),
        );
      },
      child: ArticleCard(news),
    );
  }

  Widget _buildArticleResults(BuildContext context) {
    if (_articles.length < 1) {
      return Container();
    }
    return Column(
      children: <Widget>[
        _buildSectionHeading(context, AppLocalizations.of(context).translate('articles'), _articles.length > 2 ? onArticlesSeeAllPressed : null),
        _buildArticleItem(_articles[0]),
        _articles.length > 1 ? _buildArticleItem(_articles[1]) : Container()
      ],
    );
  }

  void onEventPressed(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EventPage(),
        settings: RouteSettings(arguments: event),
      ),
    );
  }

  Widget _buildEventsResults(BuildContext context) {
    if (_events.length < 1) {
      return Container();
    }
    return Column(
      children: <Widget>[
        _buildSectionHeading(context, AppLocalizations.of(context).translate('events'), _events.length > 2 ? onEventsSeeAllPressed : null),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: EventCard(
            event: _events[0],
            onPressed: () => onEventPressed(context, _events[0]),
            width: MediaQuery.of(context).size.width - 100,
          ),
        ),
        _events.length > 1
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: EventCard(
                  event: _events[1],
                  onPressed: () => onEventPressed(context, _events[1]),
                  width: MediaQuery.of(context).size.width - 100,
                ),
              )
            : Container()
      ],
    );
  }

  Widget _buildSectionHeading(BuildContext context, String heading,
      [Function onPressed]) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            heading,
            style: Theme.of(context).textTheme.subhead,
          ),
          onPressed != null
              ? RawMaterialButton(
                  onPressed: onPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('seeMore'),
                        style: Theme.of(context).textTheme.display2,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Theme.of(context).accentColor,
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      title: TextField(
        cursorColor: Colors.black,
        focusNode: _searchNode,
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          hintText: AppLocalizations.of(context).translate('search'),
        ),
        onEditingComplete: () => _search(context),
      ),
      actions: <Widget>[
        RawMaterialButton(
          onPressed: () => _search(context),
          child: Text(AppLocalizations.of(context).translate('search')),
        )
      ],
    );
  }
}
