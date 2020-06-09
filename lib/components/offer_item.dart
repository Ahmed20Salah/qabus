import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/offer.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/url.dart';

class OfferItem extends StatelessWidget {
  final double width;
  final double marginLeft;
  final Offer offer;
  OfferItem({this.width = 150, this.marginLeft = 15, @required this.offer})
      : assert(offer != null);

  @override
  Widget build(BuildContext context) {
     final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if(appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return Container(
      height: 130,
      padding: EdgeInsets.all(2),
      constraints: BoxConstraints(maxHeight: 125),
      width: width,
      margin: EdgeInsets.only(left: marginLeft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Stack(
          //   children: <Widget>[
          //     Positioned(
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(10),
          //         child: FadeInImage(
          //           width: MediaQuery.of(context).size.width,
          //           height: 100,
          //           fit: BoxFit.cover,
          //           image: NetworkImage(URLs.serverURL + offer.imageURL),
          //           placeholder: AssetImage('assets/images/offer_cover.png'),
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 5,
          //       right: 5,
          //       left: 5,
          //       child: Text(
          //         offer.title,
          //         style: Theme.of(context).textTheme.subtitle.copyWith(
          //               color: Colors.white,
          //               height: 1.0,
          //               fontWeight: FontWeight.w600,
          //             ),
          //       ),
          //     )
          //   ],
          // ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.cover,
              image: NetworkImage(URLs.serverURL + offer.imageURL),
              placeholder: AssetImage('assets/images/offer_cover.png'),
            ),
          ),
          Container(
            child: Text(
              isArabic ? offer.titleAr : offer.title,
              style: Theme.of(context).textTheme.subtitle,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
