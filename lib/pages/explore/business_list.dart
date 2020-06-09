import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:qabus/components/listing_item_list.dart';
import 'package:qabus/modals/area.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/pages/explore/listing.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/state_management/scoped_panel_ctrl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';

class BusinessListPage extends StatefulWidget {
  final Category category;
  BusinessListPage(this.category) : assert(category != null);
  @override
  _BusinessListPageState createState() => _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<BusinessListItem> _businesses;
  List<BusinessListItem> _filteredBusinesses = [];
  SORT_BY _currentSortBy;
  bool _isSelectedAreasLoading = false;

  AppBar _buildAppBar(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if(appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return AppBar(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Text(
        isArabic ? widget.category.titleArb : widget.category.title,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ScopedModelDescendant<ScopedController>(
            builder:
                (BuildContext context, Widget child, ScopedController modal) {
              return Row(
                children: <Widget>[
                  Text(
                    _filteredBusinesses.length > 1
                        ? _filteredBusinesses.length.toString() +
                            AppLocalizations.of(context).translate('resultsPlural')
                        : (_filteredBusinesses.length > 0
                            ? AppLocalizations.of(context).translate('resultsSingle')
                            : AppLocalizations.of(context).translate('resultsNone')),
                    style: Theme.of(context).textTheme.display3,
                  ),
                  Spacer(),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      modal.changeFilterType(FILTER_TYPE.SORT_BY);
                      modal.controller.open();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.sort,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(width: 3),
                        Text(
                          AppLocalizations.of(context).translate('sortBy'),
                          style: Theme.of(context).textTheme.display2,
                        )
                      ],
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      modal.changeFilterType(FILTER_TYPE.FILTER);
                      modal.controller.open();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.filter_list,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(width: 3),
                        Text(
                          AppLocalizations.of(context).translate('filterBy'),
                          style: Theme.of(context).textTheme.display2,
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          // Container(
          //   height: 40,
          //   child: ListView.builder(
          //     padding: EdgeInsets.all(5),
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 10,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Container(
          //         margin: EdgeInsets.only(right: 10),
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(50),
          //           border: Border.all(
          //             color: Theme.of(context).accentColor,
          //             width: 1.5,
          //           ),
          //         ),
          //         child: RawMaterialButton(
          //           constraints: BoxConstraints(minWidth: 70),
          //           highlightColor:
          //               Theme.of(context).accentColor.withOpacity(0.2),
          //           onPressed: () {},
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(50),
          //           ),
          //           child: Text(
          //             'abaya',
          //             style: Theme.of(context).textTheme.display2,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildListingItem(BuildContext context, int index) {
    return ListingItemListView(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ListingPage(_filteredBusinesses[index].id),
        ),
      );
    }, _filteredBusinesses[index]);
  }

  void _getData() async {
    try {
      final List<BusinessListItem> businesses =
          await ExplorePageService.getBusinessesFromCategory(
              widget.category.id);
      setState(() {
        _isLoading = false;
        _hasError = false;
        _businesses = businesses;
        _filteredBusinesses = _businesses;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getData();
  }

  void _onSortByChange(ScopedController modal) {
    if (modal.selectedAreas != null && modal.selectedAreas.isNotEmpty) {
      return _showBasedOnAreas(modal.selectedAreas);
    }
    if (_currentSortBy == modal.sortBy) {
      return;
    }
    _currentSortBy = modal.sortBy;
    switch (_currentSortBy) {
      case SORT_BY.DISTANCE:
        _sortByDistance();
        break;
      case SORT_BY.NAME:
        _sortAlphabetically();
        break;
      case SORT_BY.POPULARITY:
      case SORT_BY.RATING:
    }
  }

  void _sortByDistance() async {
    LocationData currentLocation;
    Location location = new Location();

    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('permission denied');
        //TODO show permission denied alert
      }
      currentLocation = null;
      return null;
    }

    double lat = currentLocation.latitude;
    double lng = currentLocation.longitude;
    try {
      List<BusinessListItem> businesses =
          await ExplorePageService.getBusinessByDistance(
        lat,
        lng,
        widget.category.id,
      );
      if (businesses == null) {
        businesses = [];
      }
      setState(() {
        _isLoading = false;
        _hasError = false;
        _filteredBusinesses = businesses;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _sortAlphabetically() {
    _filteredBusinesses.sort((first, second) {
      return first.name.compareTo(second.name);
    });
  }

  void _showBasedOnAreas(List<Area> areas) async {
    if (_isSelectedAreasLoading) {
      return;
    }
    _isSelectedAreasLoading = true;
    try {
      List<BusinessListItem> businesses =
          await ExplorePageService.getBusinessByArea(areas, widget.category.id);
      if (businesses == null) {
        businesses = [];
      }
      setState(() {
        _isLoading = false;
        _hasError = false;
        _filteredBusinesses = businesses;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    } finally {
      _isSelectedAreasLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError
              ? GestureDetector(
                  onTap: _getData,
                  child: Center(
                    child: Text(AppLocalizations.of(context).translate('errorText')),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 10),
                      child: _buildFilterSection(context),
                    ),
                    Expanded(
                      child: ScopedModelDescendant(
                        builder: (BuildContext context, Widget child,
                            ScopedController modal) {
                          _onSortByChange(modal);
                          return ListView.builder(
                            itemCount: _filteredBusinesses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildListingItem(context, index);
                            },
                          );
                        },
                      ),
                    )
                  ],
                )),
    );
  }
}
