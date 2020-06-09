import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/event.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/url.dart';

class EventCard extends StatelessWidget {
  final double width;
  final Function onPressed;
  final Event event;
  final int maxLines;
  EventCard(
      {@required this.width, @required this.onPressed, @required this.event, this.maxLines: 4});

  @override
  Widget build(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    final String day = event.endDate.day.toString().length < 2
        ? '0' + event.endDate.day.toString()
        : event.endDate.day.toString();
    final String month = event.endDate.month.toString().length < 2
        ? '0' + event.endDate.month.toString()
        : event.endDate.month.toString();
    final String year = event.endDate.year.toString();
    final String expiryDate = '$day/$month/$year';

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(3),
        height: 140,
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Container(
                width: 124,
                child: Stack(
                  children: <Widget>[
                    FadeInImage(
                      width: 120,
                      height: 140,
                      fit: BoxFit.cover,
                      image: NetworkImage(URLs.serverURL + event.imageURL),
                      placeholder:
                          AssetImage('assets/images/event_card_cover.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                        margin: EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          'Ends on $expiryDate',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width - 130,
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxHeight: 50),
                      child: Text(
                        isArabic ? event.titleAr : event.title,
                        style: Theme.of(context)
                            .textTheme
                            .display4
                            .copyWith(height: 1.3),
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 14,
                        ),
                        SizedBox(width: 3),
                        Container(
                          width: width - 160,
                          constraints: BoxConstraints(maxHeight: 40),
                          child: Text(event.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .display3
                                  .copyWith(height: 1.2)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Text(
                        isArabic ? event.descriptionAr : event.description,
                        maxLines: maxLines,
                        style: Theme.of(context).textTheme.display3.copyWith(
                              color: Color(0xFF7A7A7A),
                              height: 1.2,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
