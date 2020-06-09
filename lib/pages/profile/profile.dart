import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/business.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/pages/explore/listing.dart';
import 'package:qabus/pages/profile/add_offer.dart';
import 'package:qabus/pages/profile/change_password.dart';
import 'package:qabus/pages/profile/edit_profile.dart';
import 'package:qabus/pages/profile/listings_form.dart';
import 'package:qabus/pages/profile/my_listings.dart';
import 'package:qabus/pages/profile/my_offers.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage(this.user);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  bool _hasError = false;
  AccountService auth;
  List<BusinessListItem> businesses = [];
  List<BusinessListItem> favorites = [];

  List<Offer> offers = [];
  User user;

  void _getData() async {
    try {
      auth = Provider.of<AccountService>(context);
      Map<String, dynamic> data = await auth.getProfileData(widget.user.userId);
      if (data == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }
      setState(() {
        _isLoading = false;
        businesses = data['businesses'];
        offers = data['offers'];
        user = data['user'];
        favorites = data['favorites'];
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context).translate('myAccount'),
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError
              ? Center(
                  child: Text(AppLocalizations.of(context).translate('errorText')),
                )
              : _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildProfileSection(),
            _buildListingSection(context),
            _buildOffersSection(context),
            _buildFavoriteSection(context),
            // SizedBox(height: 15),
            SizedBox(
              height: 35,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('editProfile'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          EditProfilePage(widget.user),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 35,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('changePassword'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangePasswordPage(widget.user),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 35,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('logoutText'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () {
                  final auth = Provider.of<AccountService>(context);
                  auth.logout();
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteSection(BuildContext context) {
    if (favorites.length < 1) {
      return Container();
    }
    return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSectionHeading(context, AppLocalizations.of(context).translate('myFavorites'), ''),
              favorites.length < 1
                  ? Container()
                  : _buildListingItem(
                      favorites[0], context, ListingPage(favorites[0].id)),
              favorites.length < 2
                  ? Container()
                  : _buildListingItem(
                      favorites[1], context, ListingPage(favorites[1].id)),
              favorites.length > 2
                  ? SizedBox(
                      height: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Text(AppLocalizations.of(context).translate('viewMore')),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyListingsPage(favorites, (String value) {
                                deleteListing(context, value);
                              }),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        );
  }

  Widget _buildListingSection(BuildContext context) {
    if (businesses.length < 1) {
      return Container();
    }
    Widget returnWidget;
    switch (widget.user.userType) {
      case USER_TYPE.SUPER_ADMIN:
      case USER_TYPE.BUSINESS:
        returnWidget = Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSectionHeading(context, AppLocalizations.of(context).translate('myListings'), AppLocalizations.of(context).translate('addListing'), () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ListingFormPage(),
                  ),
                );
              }),
              businesses.length < 0
                  ? Container()
                  : _buildListingItem(
                      businesses[0],
                      context,
                      ListingFormPage(
                        businessId: businesses[0].id,
                      ),
                    ),
              businesses.length < 1
                  ? Container()
                  : _buildListingItem(
                      businesses[1],
                      context,
                      ListingFormPage(
                        businessId: businesses[1].id,
                      ),
                    ),
              businesses.length > 2
                  ? SizedBox(
                      height: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Text(AppLocalizations.of(context).translate('viewMore')),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyListingsPage(businesses, (String value) {
                                deleteListing(context, value);
                              }),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        );
        break;
      case USER_TYPE.NONE:
      case USER_TYPE.USER:
        returnWidget = Container();
        break;
    }
    return returnWidget;
  }

  Widget _buildOffersSection(BuildContext context) {
    if (offers.length < 1) {
      return Container();
    }
    Widget returnWidget;
    switch (widget.user.userType) {
      case USER_TYPE.SUPER_ADMIN:
      case USER_TYPE.BUSINESS:
        returnWidget = Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            children: <Widget>[
              _buildSectionHeading(context, AppLocalizations.of(context).translate('myListings'), AppLocalizations.of(context).translate('addOffer'), () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddOfferPage(),
                  ),
                );
              }),
              offers.length < 1
                  ? Container()
                  : _buildOfferItem(
                      offers[0],
                      context,
                    ),
              offers.length < 2
                  ? Container()
                  : _buildOfferItem(offers[0], context),
              offers.length > 2
                  ? SizedBox(
                      height: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Text(AppLocalizations.of(context).translate('viewMore')),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyOffersPage(offers),
                            ),
                          );
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        );
        break;
      case USER_TYPE.NONE:
      case USER_TYPE.USER:
        returnWidget = Container();
        break;
    }
    return returnWidget;
  }

  Widget _buildOfferItem(Offer offer, BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(0),
      leading: Image.network(
        URLs.serverURL + offer.imageURL,
        width: 70,
        fit: BoxFit.cover,
      ),
      title: Text(
        offer.title,
        style: TextStyle(fontSize: 16, height: 1.2),
        maxLines: 2,
      ),
      subtitle: Text(
        offer.description,
        style: TextStyle(fontSize: 14),
        maxLines: 2,
      ),
    );
  }

  void deleteListing(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('confirmDeleteListingHeading')),
            content: Text(AppLocalizations.of(context).translate('confirmDeleteListingSubtitle')),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('cancel')),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('accept')),
                onPressed: () async {
                  final bool result = await ExplorePageService.deleteListing(
                      widget.user.userId.toString(), id);
                  if (result) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
              )
            ],
          );
        });
  }

  Widget _buildListingItem(
      BusinessListItem business, BuildContext context, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => nextPage,
          ),
        );
      },
      onLongPress: () async {
        final bool dialogResult = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {},
        );
        if (dialogResult) {
          setState(() {
            businesses.removeWhere((item) => item.id == business.id);
          });
        }
      },
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(0),
        leading: Image.network(
          URLs.serverURL + business.profileImage,
          width: 70,
          fit: BoxFit.cover,
        ),
        title: Text(
          business.name,
          style: TextStyle(fontSize: 16, height: 1.2),
          maxLines: 2,
        ),
        subtitle: Text(
          business.address,
          style: TextStyle(fontSize: 14),
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildSectionHeading(
      BuildContext context, String heading, String moreText,
      [Function onPressed]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          heading,
          style: Theme.of(context).textTheme.subhead,
        ),
        RawMaterialButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                moreText,
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
      ],
    );
  }

  Widget buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage:
                NetworkImage(URLs.serverURL + widget.user.imageURL),
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.user.name == null ? AppLocalizations.of(context).translate('defaultUserName') : widget.user.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                widget.user.email,
                style: TextStyle(fontSize: 16),
              ),
              widget.user.phone == null
                  ? Container(
                      height: 35,
                    )
                  : Text(widget.user.phone, style: TextStyle(fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }
}
