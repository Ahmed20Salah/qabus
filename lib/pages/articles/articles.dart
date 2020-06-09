import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/components/article_card.dart';
import 'package:qabus/modals/news.dart';
import 'package:qabus/modals/news_category.dart';
import 'package:qabus/pages/articles/article.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/services/news_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<News> _news = [];
  List<News> _filteredNews = [];
  List<NewsCategory> _newsCategories = [];
  bool _isSearchActive = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  PanelController _panelController = PanelController();
  NewsCategory _currentCategory;

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(AppLocalizations.of(context).translate('news'),
          style: Theme.of(context).textTheme.title),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      bottom: _isSearchActive
          ? PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: _searchNews,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: AppLocalizations.of(context).translate('search'),
                  ),
                ),
              ),
            )
          : null,
      actions: <Widget>[
        _isSearchActive
            ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _toggleSearchState(context);
                  setState(() {
                    _searchController.clear();
                    _filteredNews = _news;
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _toggleSearchState(context),
              ),
        IconButton(
          icon: Icon(Icons.apps),
          onPressed: () {
            _panelController.isPanelOpen()
                ? _panelController.close()
                : _panelController.open();
          },
        )
      ],
      actionsIconTheme: IconThemeData(color: Colors.black),
    );
  }

  void _searchNews() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      final String searchText = _searchController.text;
      List<News> result = await NewsService.searchNews(searchText);
      if (result != null) {
        _filteredNews = result;
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getCategories() async {
    try {
      final List<NewsCategory> categories =
          await NewsService.getAllCategories();
      setState(() {
        _newsCategories = categories;
      });
    } catch (e) {
      print(e);
    }
  }

  void _getData() async {
    try {
      final List<News> news = await NewsService.getAllNews();
      setState(() {
        _isLoading = false;
        _hasError = false;
        _news = news;
        _filteredNews = news;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _getNewsFromCategories(NewsCategory category) async {
    _panelController.close();
    setState(() {
      _isLoading = true;
    });
    try {
      final List<News> news =
          await NewsService.getNewsFromCategory(category.id);
      setState(() {
        _isLoading = false;
        _hasError = false;
        _filteredNews = news;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _toggleSearchState(BuildContext context) {
    setState(() {
      _isSearchActive = !_isSearchActive;
    });
    if (_isSearchActive) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError
              ? Center(
                  child:
                      Text(AppLocalizations.of(context).translate('errorText')),
                )
              : SlidingUpPanel(
                  backdropEnabled: true,
                  controller: _panelController,
                  body: _buildListView(),
                  minHeight: 0,
                  parallaxEnabled: true,
                  maxHeight: MediaQuery.of(context).size.height * 0.50,
                  panel: ListView.builder(
                    itemCount: _newsCategories.length + 2,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCategoryItem(context, index);
                    },
                  ),
                )),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    final AppLanguage appLanguage = Provider.of<AppLanguage>(context);
    bool isArabic = false;
    if (appLanguage.appLocal == Locale('ar')) {
      isArabic = true;
    }
    if (index == 0) {
      return Padding(
        child: Text(
          AppLocalizations.of(context).translate('selectCategory'),
          style: Theme.of(context).textTheme.display2.copyWith(fontSize: 20),
        ),
        padding: EdgeInsets.only(left: 10, top: 10),
      );
    } else if (index == 1) {
      return FlatButton(
        child: _buildCategoryListButton(
            AppLocalizations.of(context).translate('allNews'), isArabic),
        onPressed: () {
          _panelController.close();
          setState(() {
            _currentCategory = null;
            _filteredNews = _news;
          });
        },
      );
    }
    return FlatButton(
      child: _buildCategoryListButton(
          isArabic
              ? _newsCategories[index - 2].nameAr
              : _newsCategories[index - 2].name,
          isArabic),
      onPressed: () {
        if (_currentCategory != _newsCategories[index - 2]) {
          _currentCategory = _newsCategories[index - 2];
          _getNewsFromCategories(_newsCategories[index - 2]);
        } else {
          _panelController.close();
        }
      },
    );
  }

  Widget _buildCategoryListButton(String text, bool isArabic) {
    Color color;
    
    if (_currentCategory != null) {
      final String name =
        isArabic ? _currentCategory.nameAr : _currentCategory.name;
      color = name == text ? Theme.of(context).accentColor : Colors.black;
    } else {
      color = Colors.black;
    }
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _buildListView() {
    if(_filteredNews.length < 1) {
      return Center(child: Text('No News Found.'),);
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 200),
      itemCount: _filteredNews.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ArticlePage(_filteredNews[index]),
              ),
            );
          },
          child: ArticleCard(_news[index]),
        );
      },
    );
  }
}
