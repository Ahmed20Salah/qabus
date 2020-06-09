import 'package:flutter/material.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/url.dart';

class OfferDetail extends StatelessWidget {
  final Offer offer;
  OfferDetail(this.offer) : assert(offer != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInImage(
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
              image: AssetImage(URLs.serverURL + offer.imageURL),
              placeholder: AssetImage('assets/images/offer_cover.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Text(offer.title, style: Theme.of(context).textTheme.title),
            ),
            _buildRequirements(context),
            _buildTutorial(context),
            _buildTerms(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildRedeemMethod(context),
    );
  }

  Widget _buildRedeemMethod(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: () {},
          fillColor: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          constraints: BoxConstraints(minHeight: 50),
          child: Text(
            'Redeem',
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorial(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tutorial',
            style: Theme.of(context).textTheme.subhead,
          ),
          SizedBox(height: 5),
          Text(
            'All you need is just to fill the requirements.',
            style: Theme.of(context).textTheme.display3,
          )
        ],
      ),
    );
  }

  Widget _buildTerms(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Terms & Conditions',
            style: Theme.of(context).textTheme.subhead,
          ),
          SizedBox(height: 5),
          Text(
            'After redeem, the coupon will be valid for one week.',
            style: Theme.of(context).textTheme.display3,
          )
        ],
      ),
    );
  }

  Widget _buildRequirements(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Requirements',
            style: Theme.of(context).textTheme.subhead,
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Icon(Icons.check_circle_outline),
              SizedBox(width: 5),
              Text(
                'Login',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 5),
              Text(
                '08:00 - 10:00',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final String day = offer.endDate.day.toString().length < 2
        ? '0' + offer.endDate.day.toString()
        : offer.endDate.day.toString();
    final String month = offer.endDate.month.toString().length < 2
        ? '0' + offer.endDate.month.toString()
        : offer.endDate.month.toString();
    final String year = offer.endDate.year.toString();
    final String expiryDate = '$day/$month/$year';

    return AppBar(
      centerTitle: false,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        'Expires on ' + expiryDate,
        style: Theme.of(context).textTheme.display3.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
