import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:qabus/components/category_item.dart';
import 'package:qabus/components/event_card.dart';
import 'package:qabus/components/home_search_btn.dart';
import 'package:qabus/components/listing_item.dart';
import 'package:qabus/components/listing_item_list.dart';
import 'package:qabus/components/offer_item.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/modals/event.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/modals/slider.dart';
import 'package:qabus/pages/events/event.dart';
import 'package:qabus/pages/explore/business_list.dart';
import 'package:qabus/pages/explore/categories.dart';
import 'package:qabus/pages/explore/listing.dart';
import 'package:qabus/pages/explore/search.dart';
import 'package:qabus/pages/explore/widget_list.dart';
import 'package:qabus/pages/offers/offer_detail.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/state_management/scoped_panel_ctrl.dart';
import 'package:qabus/url.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:geocoder/geocoder.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage(Key key) : super(key: key);
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  PageController _pageController;
  final _currentPageNotifier = ValueNotifier<int>(0);
  bool _isLoading = true;
  bool _hasError = false;
  List<SliderModal> _sliders = [];
  List<Category> _categories = [];
  List<BusinessListItem> _recommendedBusinesses = [];
  List<BusinessListItem> _newBusiness = [];
  List<Offer> _offers = [];
  List<Event> _events = [];
  List<BusinessListItem> _featuredBusiness = [];
  bool _isDataLoading = false;
  String locationName = '';
  Widget _buildTopSection() {
    return Container(
      height: 250,
      child: Stack(
        children: <Widget>[
          Container(
            height: 225,
            child: PageView.builder(
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
              },
              itemCount: _sliders.length,
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                return FadeInImage(
                  fit: BoxFit.cover,
                  image:
                      NetworkImage(URLs.serverURL + _sliders[index].imageURL),
                  placeholder: AssetImage('assets/images/cover.png'),
                );
              },
            ),
          ),
          Positioned(
            bottom: 55,
            left: 0,
            right: 0,
            child: CirclePageIndicator(
              dotColor: Color(0xFFB1AFAF),
              selectedDotColor: Theme.of(context).accentColor,
              size: 10,
              selectedSize: 10,
              itemCount: _sliders.length,
              dotSpacing: 10,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: HomePageSearchBtn(() => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SearchPage(),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeading(BuildContext context, String heading,
      [Function onPressed]) {
    return Container(
      height: 55,
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

  Widget _buildCategorySection(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 60) / 4;
    if (_categories.length < 1) {
      return Container();
    }
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: _buildSectionHeading(
            context, AppLocalizations.of(context).translate('categories'), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CategoriesPage(),
            ),
          );
        }),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Wrap(
          runSpacing: 10,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 10,
          direction: Axis.horizontal,
          children: List.generate(
            _categories.length > 8 ? 8 : _categories.length,
            (int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          BusinessListPage(_categories[index]),
                    ),
                  );
                },
                child: Container(
                  width: width,
                  child: CategoryItem(
                    category: _categories[index],
                  ),
                ),
              );
            },
          ),
        ),
      )
    ]);
  }

  Widget __buildRecommendedItem(BuildContext context, int index) {
    return ListingItem(
        () => _openListingPage(context, _recommendedBusinesses[index].id),
        _recommendedBusinesses[index]);
  }

  void onBusinessSeeAllPressed(BuildContext context, List list, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: title,
          widgets: list
              .map(
                (item) => ListingItemListView(
                  () => _openListingPage(context, item.id),
                  item,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void onEventsSeeAllPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: AppLocalizations.of(context).translate('latestEvents'),
          widgets: _events.map(
            (item) {
              final double cardWidth = MediaQuery.of(context).size.width - 50;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: EventCard(
                  event: item,
                  onPressed: () => _openEvent(context, item),
                  width: cardWidth,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  void onOffersSeeAllPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetListPage(
          pageTitle: AppLocalizations.of(context).translate('bestOffers'),
          widgets: _offers.map((item) => OfferItem(offer: item)).toList(),
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    if (_recommendedBusinesses.length < 1) {
      return Container();
    }
    return Container(
      height: 250,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSectionHeading(
                context,
                AppLocalizations.of(context).translate('recommendedForYou'),
                _recommendedBusinesses.length > 2
                    ? () => onBusinessSeeAllPressed(
                        context,
                        _recommendedBusinesses,
                        AppLocalizations.of(context)
                            .translate('recommendedForYou'))
                    : null),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendedBusinesses.length > 10
                  ? 10
                  : _recommendedBusinesses.length,
              itemBuilder: (BuildContext context, int index) {
                return __buildRecommendedItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewlyAddedItem(BuildContext context, int index) {
    return ListingItem(() => _openListingPage(context, _newBusiness[index].id),
        _newBusiness[index]);
  }

  Widget _buildNewlyAddedSection(BuildContext context) {
    if (_newBusiness.length < 1) {
      return Container();
    }
    return Container(
      height: 250,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSectionHeading(
                context,
                AppLocalizations.of(context).translate('newlyAdded'),
                _newBusiness.length > 2
                    ? () => onBusinessSeeAllPressed(context, _newBusiness,
                        AppLocalizations.of(context).translate('newlyAdded'))
                    : null),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _newBusiness.length > 10 ? 10 : _newBusiness.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildNewlyAddedItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestOffersItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return OfferDetail(_offers[index]);
        }));
      },
      child: OfferItem(
        offer: _offers[index],
      ),
    );
  }

  Widget _buildBestOffersSection(BuildContext context) {
    if (_offers.length < 1) {
      return Container();
    }
    return Container(
      height: 190,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSectionHeading(
                context,
                AppLocalizations.of(context).translate('bestOffers'),
                _offers.length > 2
                    ? () => onOffersSeeAllPressed(context)
                    : null),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _offers.length > 10 ? 10 : _offers.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildBestOffersItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestEventsItem(BuildContext context, int index) {
    final double cardWidth = MediaQuery.of(context).size.width - 50;
    return Container(
      width: cardWidth,
      margin: index == 0 ? EdgeInsets.only(left: 15) : EdgeInsets.only(left: 5),
      child: EventCard(
        maxLines: 2,
        event: _events[index],
        onPressed: () => _openEvent(context, _events[index]),
        width: cardWidth,
      ),
    );
  }

  Widget _buildLatestEventsSection(BuildContext context) {
    if (_events.length < 1) {
      return Container();
    }
    return Container(
      height: 185,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSectionHeading(
                context,
                AppLocalizations.of(context).translate('latestEvents'),
                _events.length > 2
                    ? () => onEventsSeeAllPressed(context)
                    : null),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _events.length > 10 ? 10 : _events.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildLatestEventsItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedItem(BuildContext context, int index) {
    return ListingItem(
        () => _openListingPage(context, _featuredBusiness[index].id),
        _featuredBusiness[index]);
  }

  Widget _buildFeaturedSection(BuildContext context) {
    if (_featuredBusiness.length < 1) {
      return Container();
    }
    return Container(
      height: 290,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildSectionHeading(
                context,
                AppLocalizations.of(context).translate('featuredPlaces'),
                _featuredBusiness.length > 2
                    ? () => onBusinessSeeAllPressed(
                        context, _featuredBusiness, 'Featured Places')
                    : null),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  _featuredBusiness.length > 10 ? 10 : _featuredBusiness.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildFeaturedItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 5),
      onPressed: () {},
      child: Row(
        children: <Widget>[
          Text(
            locationName,
            style: Theme.of(context)
                .textTheme
                .display4
                .copyWith(fontSize: 20, color: Colors.white),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  void _openListingPage(BuildContext context, String businessId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ListingPage(businessId),
      ),
    );
  }

  void _openEvent(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EventPage(),
        settings: RouteSettings(arguments: event),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _getData(context, [bool override = false]) async {
    if (_isDataLoading && !override) {
      return;
    }

    setState(() {
      _isDataLoading = true;
      _isLoading = true;
      _hasError = false;
    });
    try {
      final auth = Provider.of<AccountService>(context);
      Map<String, dynamic> data;
      LocationData currentLocation;
      Location location = new Location();

      currentLocation = await location.getLocation();

      double lat = currentLocation?.latitude;
      double lng = currentLocation?.longitude;
      if (auth.currentUser == null) {
        data = await ExplorePageService.getHomePageContent(lat, lng);
      } else {
        data = await ExplorePageService.getHomePageContentWithUser(
          auth.currentUser.userId,
          lat,
          lng,
        );
      }
      final city = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(lat, lng))
          .then((value) => value.first.countryName);
          print(city);
      if (data == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return null;
      }
      setState(() {
        _sliders = data['sliders'];
        _categories = data['categories'];
        _recommendedBusinesses = data['recomendedBusinesses'];
        _newBusiness = data['newBusiness'];
        _offers = data['offers'];
        _events = data['events'];
        _featuredBusiness = data['featuredBusiness'];
        _isLoading = false;
        _hasError = false;
        locationName = city;
      });
    } catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        print('permission denied');
      }
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getData(context);
    return ScopedModelDescendant<ScopedController>(
      builder: (BuildContext context, Widget child, ScopedController modal) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black),
            title: _buildLocationSelector(context),
            leading: IconButton(
              icon: Icon(
                Icons.dehaze,
                color: Colors.white,
              ),
              onPressed: () {
                modal.scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (_hasError
                  ? Center(
                      child: Text(
                          AppLocalizations.of(context).translate('errorText')),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _getData(context, true),
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        key: PageStorageKey('explore-list'),
                        children: <Widget>[
                          _buildTopSection(),
                          _buildCategorySection(context),
                          _buildRecommendedSection(context),
                          _buildNewlyAddedSection(context),
                          _buildBestOffersSection(context),
                          _buildLatestEventsSection(context),
                          _buildFeaturedSection(context),
                          SizedBox(height: 10),
                        ],
                      ),
                    )),
        );
      },
    );
  }
}
