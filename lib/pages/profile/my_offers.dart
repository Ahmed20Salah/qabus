import 'package:flutter/material.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';

class MyOffersPage extends StatelessWidget {
  final List<Offer> offers;
  MyOffersPage(this.offers);

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        AppLocalizations.of(context).translate('myOffers'),
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _buildOfferItem(String asset, String title, String subtitle) {
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(0),
          leading: Image.asset(
            asset,
            width: 70,
            fit: BoxFit.cover,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
          ),
        ),
        Divider(color: Colors.grey, height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 30, left: 15, right: 15),
        itemCount: offers.length,
        itemBuilder: (BuildContext context, int index) {
          final Offer item = offers[index];
          return _buildOfferItem(
            URLs.serverURL + item.imageURL,
            item.title,
            item.description,
          );
        },
      ),
    );
  }
}
