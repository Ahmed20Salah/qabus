import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:qabus/components/direction_btn.dart';
import 'package:qabus/components/listing_item.dart';
import 'package:qabus/components/offer_item.dart';
import 'package:qabus/components/open_status_btn.dart';
import 'package:qabus/components/rating_item.dart';
import 'package:qabus/components/review_item.dart';
import 'package:qabus/modals/business.dart';
import 'package:qabus/pages/listing_timing.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';

class ListingPage extends StatefulWidget {
  final String businessId;
  ListingPage(this.businessId) : assert(businessId != null);
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;

  bool isScrolledUnder = false;
  bool changeIconTheme = false;
  bool isDirectionsVisible = false;
  bool _showFullText = false;
  bool _isLoading = true;
  bool _hasError = false;
  BusinessItem _businessItem;
  bool _isFavorite = false;
  bool isFirstTimeLoad = true;

  void toggleFavorite(bool value, BuildContext context) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final AccountService _accountService = Provider.of<AccountService>(context);
    if (_accountService.currentUser == null) {
      return;
    }
    try {
      final bool response = await ExplorePageService.toggleFavorite(
        widget.businessId,
        _accountService.currentUser.userId,
      );
      if (response) {
        setState(() {
          _isLoading = false;
          _isFavorite = !_isFavorite;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getData(String userId) async {
    try {
      final BusinessItem businessItem =
          await ExplorePageService.getBusinessItem(widget.businessId, userId);
      if (businessItem == null) {
        throw Exception('returned null');
      }
      setState(() {
        _isLoading = false;
        _hasError = false;
        _businessItem = businessItem;
        _isFavorite = businessItem.isFavorite;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onScrollChange() {
    if (_scrollController.offset >= 195) {
      changeIconTheme = true;
      if (_scrollController.offset >= 225) {
        isScrolledUnder = true;
        if (_scrollController.offset >= 290) {
          setState(() {
            isDirectionsVisible = true;
          });
        } else {
          setState(() {
            isDirectionsVisible = false;
          });
        }
      } else {
        setState(() {
          isScrolledUnder = false;
        });
      }
    } else {
      setState(() {
        isDirectionsVisible = false;
        isScrolledUnder = false;
        changeIconTheme = false;
      });
    }
  }

  void _openListingPage(BuildContext context, String listingId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ListingPage(listingId),
      ),
    );
  }

  Widget _buildAppBar(context) {
    final AccountService accountService = Provider.of<AccountService>(context);
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return SliverAppBar(
      floating: false,
      pinned: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      expandedHeight: 250,
      iconTheme:
          IconThemeData(color: changeIconTheme ? Colors.black : Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: isScrolledUnder
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      isArabic ? _businessItem.nameAr : _businessItem.name,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.title.copyWith(
                            height: 1.1,
                          ),
                    ),
                    width: MediaQuery.of(context).size.width - 200,
                  ),
                  isDirectionsVisible
                      ? Container(
                          child: DirectionBtn(() async {
                            final availableMaps =
                                await MapLauncher.installedMaps;
                            await availableMaps.first.showMarker(
                              coords:
                                  Coords(_businessItem.lat, _businessItem.lng),
                              title: _businessItem.name,
                              description: _businessItem.description,
                            );
                          }),
                          margin: EdgeInsets.only(right: 15),
                        )
                      : Container(
                          height: 30,
                        ),
                ],
              )
            : Container(),
        background: Stack(
          children: <Widget>[
            FadeInImage(
              image:
                  NetworkImage(URLs.serverURL + _businessItem.backgroundImage),
              placeholder: AssetImage('assets/images/cover.png'),
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OpenStatusBtn(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListingTimingPage(
                            _businessItem.timing, _businessItem.openStatusText),
                      ),
                    );
                  }, _businessItem.openStatusText),
                  accountService.currentUser != null
                      ? IconButton(
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 30,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              toggleFavorite(!_isFavorite, context),
                          alignment: Alignment.center,
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isArabic ? _businessItem.nameAr : _businessItem.name,
            style: Theme.of(context).textTheme.title.copyWith(height: 1),
          ),
          SizedBox(height: 5),
          Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text(
                    '     ' +
                        (isArabic
                            ? _businessItem.addressAr
                            : _businessItem.address),
                    style: Theme.of(context).textTheme.display3,
                    maxLines: 2,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                child: Icon(Icons.location_on, size: 13),
              ),
            ],
          ),
          // SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // RatingItem(4.6),
              DirectionBtn(() async {
                final availableMaps = await MapLauncher.installedMaps;
                await availableMaps.first.showMarker(
                  coords: Coords(_businessItem.lat, _businessItem.lng),
                  title: _businessItem.name,
                  description: _businessItem.description,
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildExpandedText(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: AnimatedSize(
        curve: Curves.easeOut,
        vsync: this,
        duration: Duration(milliseconds: 500),
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: _showFullText
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 90),
              child: Text(
                isArabic
                    ? _businessItem.descriptionAr
                    : _businessItem.description,
              ),
            ),
            RawMaterialButton(
              onPressed: _toggleShowText,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _showFullText
                    ? <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('viewLess'),
                          style: Theme.of(context).textTheme.display2,
                        ),
                        Icon(
                          Icons.keyboard_arrow_up,
                          size: 16,
                          color: Theme.of(context).accentColor,
                        )
                      ]
                    : <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('viewMore'),
                          style: Theme.of(context).textTheme.display2,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Theme.of(context).accentColor,
                        )
                      ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesItem(BuildContext context, int index) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Icon(_businessItem.facilities.availableList[index]['icon'], size: 40),
          Container(
            width: 100,
            height: 40,
            child: Text(
              AppLocalizations.of(context).translate(
                  _businessItem.facilities.availableList[index]['name']),
              softWrap: true,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection(BuildContext context) {
    if (_businessItem.facilities.availableList.length < 1) {
      return Container();
    }
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _businessItem.facilities.availableList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildFacilitiesItem(context, index);
        },
      ),
    );
  }

  Widget _buildBestOffersItem(BuildContext context, int index) {
    return OfferItem(
      offer: _businessItem.offers[index],
    );
  }

  Widget _buildBestOffersSection(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        key: PageStorageKey('best-offer-list'),
        scrollDirection: Axis.horizontal,
        itemCount: _businessItem.offers.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildBestOffersItem(context, index);
        },
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context) {
    if (_businessItem.reviews.length < 1) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('reviews'),
                  style: Theme.of(context).textTheme.subhead,
                ),
                _businessItem.reviews.length > 2
                    ? RawMaterialButton(
                        onPressed: () {},
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
                    : Container(),
              ],
            ),
          ),
          ReviewItem(_businessItem.reviews[0]),
          _businessItem.reviews.length > 1
              ? ReviewItem(_businessItem.reviews[1])
              : Container(),
        ],
      ),
    );
  }

  Widget _buildRelatedItem(BuildContext context, int index) {
    return ListingItem(
        () => _openListingPage(
            context, _businessItem.relatedBusinesses[index].id),
        _businessItem.relatedBusinesses[index]);
  }

  Widget _buildRelatedPlacesSection(BuildContext context) {
    return _businessItem.relatedBusinesses.length > 1
        ? Container(
            height: 290,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    AppLocalizations.of(context).translate('related'),
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _businessItem.relatedBusinesses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildRelatedItem(context, index);
                    },
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  void _toggleShowText() {
    setState(() {
      _showFullText = !_showFullText;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChange);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AccountService accountService = Provider.of<AccountService>(context);
    if (isFirstTimeLoad) {
      String userId;
      if (accountService.currentUser != null) {
        userId = accountService.currentUser.userId;
      }

      getData(userId);
      setState(() {
        isFirstTimeLoad = false;
      });
    }
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      String userId;
                      if (accountService.currentUser != null) {
                        userId = accountService.currentUser.id.toString();
                      }
                      getData(userId);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(AppLocalizations.of(context)
                            .translate('errorText')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(AppLocalizations.of(context)
                                .translate('retryText')),
                            Icon(Icons.refresh)
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    _buildAppBar(context),
                    SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        _buildBasicInfoSection(context),
                        _buildExpandedText(context),
                        _businessItem.facilities.availableList.length < 1
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('facilities'),
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                  ),
                                  _buildFacilitiesSection(context),
                                ],
                              ),
                        SizedBox(height: 10),
                        _businessItem.offers.length < 1
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('offers'),
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                  ),
                                  _buildBestOffersSection(context),
                                ],
                              ),
                        _buildReviewSection(context),
                        _buildRelatedPlacesSection(context),
                        SizedBox(height: 50),
                      ]),
                    )
                  ],
                )),
    );
  }
}
