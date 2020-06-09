import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qabus/components/article_card.dart';
import 'package:qabus/modals/news.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/services/news_service.dart';
import 'package:qabus/url.dart';

class ArticlePage extends StatefulWidget {
  final News _news;

  ArticlePage(this._news) : assert(_news != null);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<News> _relatedNews = [];
  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: false,
    );
  }

  void _getData() async {
    try {
      final List<News> relatedNews =
          (await NewsService.getSingleNews(widget._news.id))['related'];
      setState(() {
        _relatedNews = relatedNews;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> _buildRelatedNews() {
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(
          AppLocalizations.of(context).translate('relatedNews'),
          style: Theme.of(context).textTheme.display4.copyWith(fontSize: 20),
        ),
      ),
    );
    widgets.addAll(
      _relatedNews.map((item) {
        return GestureDetector(
          child: ArticleCard(item),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ArticlePage(item),
              ),
            );
          },
        );
      }).toList(),
    );
    return widgets;
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(URLs.serverURL + widget._news.imageURL),
            placeholder: AssetImage('assets/images/article.png'),
            fit: BoxFit.cover,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Text(
              widget._news.title,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'no Date',
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Html(
              data: widget._news.description,
            ),
          ),
          ..._buildRelatedNews(),
        ],
      ),
    );
  }
}
