import 'package:flutter/material.dart';
import 'package:qabus/components/rating_stars.dart';
import 'package:qabus/modals/business.dart';

class ReviewItem extends StatelessWidget {
  final Review review;

  ReviewItem(this.review) : assert(review != null);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(top: 2),
          //   child: CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/cover.png'),
          //     radius: 10,
          //   ),
          // ),
          // SizedBox(width: 10),
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(review.name,
                    maxLines: 1,
                        style: Theme.of(context).textTheme.caption),
                    Spacer(
                      flex: 1,
                    ),
                    Text(review.rating.toString(), style: Theme.of(context).textTheme.caption),
                    SizedBox(width: 5),
                    RatingStars(review.rating),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                constraints: BoxConstraints(maxHeight: 60),
                child: Text(
                  review.message,
                  style: Theme.of(context).textTheme.overline,
                  maxLines: 3,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
