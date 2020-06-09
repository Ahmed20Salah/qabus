import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/data.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/services/language_service.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  CategoryItem({@required this.category}) : assert(category != null);

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if(appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    return Container(
      constraints: BoxConstraints(maxHeight: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(5),
              ),
              child: FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(Data.serverURL + category.image),
                placeholder: AssetImage('assets/images/category_bg.png'),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: Text(
              isArabic ? category.titleArb : category.title,
              maxLines: 1,
              style: Theme.of(context).textTheme.caption.copyWith(
                    height: 1.1,
                    fontSize: 12,
                  ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
