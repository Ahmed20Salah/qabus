import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:qabus/components/direction_btn.dart';
import 'package:qabus/modals/event.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatelessWidget {
  // final Event event;
  // EventPage(this.event);

  @override
  Widget build(BuildContext context) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    final Event event = ModalRoute.of(context).settings.arguments;

    String happeningDate;
    String startHour = event.startDate.hour < 10
        ? '0${event.startDate.hour}'
        : event.startDate.hour.toString();
    String startMinute = event.startDate.minute < 10
        ? '0${event.startDate.minute}'
        : event.startDate.minute.toString();
    String endHour = event.endDate.hour < 10
        ? '0${event.endDate.hour}'
        : event.endDate.hour.toString();
    String endMinute = event.startDate.minute < 10
        ? '0${event.startDate.minute}'
        : event.startDate.minute.toString();
    String startTime = event.startDate.hour > 12 ? 'PM' : 'AM';
    String endTime = event.endDate.hour > 12 ? 'PM' : 'AM';

    if (DateTime.now().isAfter(event.startDate) &&
        DateTime.now().isBefore(event.endDate)) {
      happeningDate = AppLocalizations.of(context).translate('today');
    } else {
      happeningDate =
          '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}';
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          isArabic ? event.titleAr : event.title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Happening $happeningDate at \n$startHour:$startMinute $startTime - $endHour:$endMinute $endTime',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(height: 1.2),
                    ),
                    Text(
                      isArabic ? event.addressAr : event.address,
                      style: Theme.of(context).textTheme.display3,
                    ),
                  ],
                ),
                DirectionBtn(() async {
                  final availableMaps = await MapLauncher.installedMaps;
                  await availableMaps.first.showMarker(
                    coords: Coords(event.lat, event.lng),
                    title: isArabic ? event.titleAr : event.title,
                    description:
                        isArabic ? event.descriptionAr : event.description,
                  );
                })
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            height: 200,
            child: FadeInImage(
              image: NetworkImage(URLs.serverURL + event.imageURL),
              placeholder: AssetImage('assets/images/event_card_cover.png'),
              fit: BoxFit.contain,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Html(
              data: isArabic ? event.descriptionAr : event.description,
            ),
          ),
          ListTile(
            onTap: () {
              launch('tel:${event.phone}');
            },
            leading: Icon(Icons.call),
            title: Text(
              event.phone,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              launch('mailto:${event.email}');
            },
            leading: Icon(Icons.mail),
            title: Text(
              event.email,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
