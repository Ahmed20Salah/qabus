import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/basic_page_content.dart';
import 'package:qabus/services/basic_page_service.dart';
import 'package:qabus/services/language_service.dart';

class BasicPage extends StatelessWidget {
  final String code;

  BasicPage(this.code) : assert(code != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BasicPageContent>(
      stream: BasicPageService.getContent(code).asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final appLanguage = Provider.of<AppLanguage>(context);
        bool isArabic = appLanguage.appLocal == Locale('en') ? false : true;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final BasicPageContent data = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                isArabic ? data.titleAr : data.title,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Html(data: isArabic ? data.contentAr : data.content,),
            ),
            ),
          );
        }
      },
    );
  }
}
