import 'package:flutter/material.dart';
import 'package:qabus/components/offer_item.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/modals/offer_tag.dart';
import 'package:qabus/pages/offers/offer_detail.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/services/offers_service.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<OfferTag> _categories = [];
  List<Offer> _offers = [];
  List<Offer> _filteredOffers = [];
  int _selectedIndex;
  bool _isLoading = true;
  bool _hasError = false;

  void _selectCategory(int index) async {
    setState(() {
      _selectedIndex = index;
      _isLoading = true;
    });
    try {
      final offers = await OffersService.sortOffersById(_categories[index]);
      setState(() {
        _isLoading = false;
        _hasError = false;
        _filteredOffers = offers;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildCategory(int index) {
    return GestureDetector(
      onTap: index == 0 ? null : () => _selectCategory(index - 1),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: 20,
        child: Text(
          index == 0
              ? AppLocalizations.of(context).translate('all')
              : _categories[index - 1].name,
          style: index == 0
              ? Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.white)
              : Theme.of(context).textTheme.caption,
        ),
        decoration: BoxDecoration(
          color: index == 0 ? Color(0xFFB8234F) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: index == 0
              ? []
              : [
                  BoxShadow(
                    blurRadius: 6,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
        ),
      ),
    );
  }

  void _getData() async {
    try {
      final data = await OffersService.getAllOffers();
      final offers = data['offers'];
      final tags = data['tags'];
      setState(() {
        _isLoading = false;
        _hasError = false;
        _offers = offers;
        _filteredOffers = offers;
        _categories = tags;
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
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('offers'),
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {},
          //   color: Colors.black,
          //   iconSize: 30,
          // )
        ],
      ),
      body: Column(
        children: <Widget>[
          buildCategoryHeader(context),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (_hasError
                  ? Center(
                      child: Text(
                          AppLocalizations.of(context).translate('errorText')),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredOffers.length,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OfferDetail(_filteredOffers[index]),
                                    ),
                                  );
                                },
                                child: OfferItem(
                                  marginLeft: 0,
                                  width: 100,
                                  offer: _filteredOffers[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ))
        ],
      ),
    );
  }

  Container buildCategoryHeader(BuildContext context) {
    if (_selectedIndex == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: ListView.builder(
          itemCount: _categories.length + 1,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return _buildCategory(index);
          },
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _filteredOffers = _offers;
                  _selectedIndex = null;
                });
              },
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Icon(Icons.keyboard_arrow_left),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      spreadRadius: 0,
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                _categories[_selectedIndex].name,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFB8234F),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        ),
      );
    }
  }
}
