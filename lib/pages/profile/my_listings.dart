import 'package:flutter/material.dart';
import 'package:qabus/modals/business.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/pages/profile/listings_form.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';

class MyListingsPage extends StatelessWidget {
  final List<BusinessListItem> businesses;
  final Function(String) onDelete;
  MyListingsPage(this.businesses, this.onDelete);

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        AppLocalizations.of(context).translate('myListings'),
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _buildListingItem(BusinessListItem business, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ListingFormPage(
              businessId: business.id,
            ),
          ),
        );
      },
      onLongPress: () => onDelete(business.id),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 30, left: 15, right: 15),
        itemCount: businesses.length,
        itemBuilder: (BuildContext context, int index) {
          final BusinessListItem item = businesses[index];
          return _buildListingItem(item, context);
        },
      ),
    );
  }
}
