import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/news.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/url.dart';

class ArticleCard extends StatelessWidget {
  final News newsItem;

  ArticleCard(this.newsItem);

  Widget _buildCardHeader(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal != Locale('en')) {
      isArabic = true;
    }
    return Container(
      height: 130,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeInImage(
              image: NetworkImage(URLs.serverURL + newsItem.imageURL),
              placeholder: AssetImage('assets/images/article.png'),
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black12],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        isArabic ? newsItem.titleAr : newsItem.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.white, height: 1.1),
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(
                      '${newsItem.date}',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.white60),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.all(8.0),
      child: Text(
        newsItem.summery,
        style: Theme.of(context).textTheme.overline.copyWith(height: 1.3),
        maxLines: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);

    bool isArabic = false;
    if (appLanguage.appLocal != Locale('en')) {
      isArabic = true;
    }
    return Column(
      children: <Widget>[_buildCardHeader(context), _buildCardBody(context)],
    );
  }
}

class RelatedCard extends StatelessWidget {
  final News newsItem;

  RelatedCard(this.newsItem);

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);

    bool isArabic = false;
    if (appLanguage.appLocal != Locale('en')) {
      isArabic = true;
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width - 30.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 130.0,
              height: 100.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage(
                  image: NetworkImage(URLs.serverURL + newsItem.imageURL),
                  placeholder: AssetImage('assets/images/article.png'),
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              height: 120.0,
              width: MediaQuery.of(context).size.width - 190.0,
              child: Text(
                isArabic ? newsItem.titleAr : newsItem.title,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: TextStyle(fontWeight: FontWeight.bold, height: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
