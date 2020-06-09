import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/components/rating_item.dart';
import 'package:qabus/modals/business_list_item.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/url.dart';

class ListingItem extends StatelessWidget {
  final Function onPressed;
  final BusinessListItem _businessListItem;

  ListingItem(this.onPressed, this._businessListItem);

  @override
  Widget build(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(left: 15),
        height: 240,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                image: NetworkImage(
                    URLs.serverURL + _businessListItem.backgroundImage),
                placeholder: AssetImage('assets/images/listing_cover.png'),
                fit: BoxFit.cover,
                height: 145,
                width: 200,
              ),
            ),
            Text(
              isArabic ? _businessListItem.nameAr : _businessListItem.name,
              style: Theme.of(context).textTheme.display4,
              maxLines: 1,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 13,
                ),
                SizedBox(width: 2),
                Container(
                  child: Text(
                    isArabic
                        ? _businessListItem.addressAr
                        : _businessListItem.address,
                    style: Theme.of(context).textTheme.display3,
                    maxLines: 1,
                  ),
                  width: 185,
                )
              ],
            ),
            // Text('Market', style: Theme.of(context).textTheme.overline),
            // RatingItem(4.5),
          ],
        ),
      ),
    );
  }
}
