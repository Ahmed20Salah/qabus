import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';

class ListingItemListView extends StatelessWidget {
  final Function onPressed;
  final BusinessListItem _businessItem;

  ListingItemListView(this.onPressed, this._businessItem);

  @override
  Widget build(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if(appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(left: 15, bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                image:
                    NetworkImage(URLs.serverURL + _businessItem.profileImage),
                placeholder: AssetImage('assets/images/listing_cover.png'),
                fit: BoxFit.cover,
                height: 130,
                width: MediaQuery.of(context).size.width * 0.33,
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 20,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '●',
                          style: TextStyle(
                            color: Color(0xFF06D6A0),
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          AppLocalizations.of(context).translate('openNow'),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                color: Color(0xFF06D6A0),
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(isArabic ? _businessItem.nameAr : _businessItem.name,
                        style: Theme.of(context).textTheme.display4),
                    width: MediaQuery.of(context).size.width - 180,
                  ),
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.location_on,
                              size: 13,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Text(
                                '     ' + (isArabic ? _businessItem.addressAr : _businessItem.address),
                                style: Theme.of(context).textTheme.display3,
                                maxLines: 2,
                              )),
                        ),
                      ],
                    ),
                  ),
                  // RatingItem(4.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
