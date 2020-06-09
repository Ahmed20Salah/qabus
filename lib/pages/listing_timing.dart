import 'package:flutter/material.dart';
import 'package:qabus/modals/business.dart';
import 'package:qabus/services/localization.dart';

class ListingTimingPage extends StatelessWidget {

  final BusinessTiming timing;
  final String openStatus;

  ListingTimingPage(this.timing, this.openStatus);

  Widget _buildTimingItem(BuildContext context, Map<String, String> weekday, [bool isToday = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(weekday['day'],
              style: isToday
                  ? Theme.of(context)
                      .textTheme
                      .display3
                      .copyWith(fontWeight: FontWeight.bold)
                  : Theme.of(context).textTheme.display3),
          Text(
            weekday['value'],
            style: isToday
                  ? Theme.of(context)
                      .textTheme
                      .display3
                      .copyWith(fontWeight: FontWeight.bold, color: Color(0xFF7A7A7A))
                  : Theme.of(context).textTheme.display3.copyWith(color: Color(0xFF7A7A7A))
          )
        ],
      ),
    );
  }

  List<Widget> _buildTimings(BuildContext context) {
    List<Widget> timings = [];
    for (var i = 0; i < timing.allDays.length; i++) {
      bool  isToday = false;
      if((i+1) == DateTime.now().weekday) {
        isToday = true;
      }
       timings.add(_buildTimingItem(context, timing.allDays[i], isToday));
    }
    return timings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context).translate('openingHours'),
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '●',
                  style: TextStyle(
                    color: Color(0xFF06D6A0),
                    fontSize: 30,
                    height: 1,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  openStatus,
                  style: Theme.of(context).textTheme.overline.copyWith(
                        color: Color(0xFF06D6A0),
                        height: 1.2,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            Column(children: _buildTimings(context),crossAxisAlignment: CrossAxisAlignment.start,)
          ],
        ),
      ),
    );
  }
}
