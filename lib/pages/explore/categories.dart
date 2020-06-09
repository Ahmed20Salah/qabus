import 'package:flutter/material.dart';
import 'package:qabus/components/category_item.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/pages/explore/business_list.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/localization.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> _categories;
  List<Category> _filteredCategories;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isSearchActive = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Text(
        AppLocalizations.of(context).translate('allCategories'),
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        _isSearchActive ?
        IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            _toggleSearchState(context);
            setState(() {
              _filteredCategories = _categories;
              _searchController.clear();
            });
          },
        ) :
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _toggleSearchState(context),
        )
      ],
      bottom: _isSearchActive ? PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (String value) {
              setState(() {
                _filteredCategories = _filterCategory(value);
              });
            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              hintText: AppLocalizations.of(context).translate('search')
            ),
          ),
        ),
      ): null,
    );
  }

  void _toggleSearchState(BuildContext context) {
    setState(() {
      _isSearchActive = !_isSearchActive;
    });
    if(_isSearchActive) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    }
  }

  Widget _buildGridItem(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                BusinessListPage(_filteredCategories[index]),
          ),
        );
      },
      child: CategoryItem(
        category: _filteredCategories[index],
      ),
    );
  }

  void getData() async {
    try {
      final List<Category> categories =
          await ExplorePageService.getAllCategories();
      setState(() {
        _isLoading = false;
        _hasError = false;
        _categories = categories;
        _filteredCategories = _categories;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _categories = [];
    _filteredCategories = [];
    getData();
  }

  Widget _buildCategories(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    final double aspectRatio = deviceWidth / (deviceWidth + 40);
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: aspectRatio,
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildGridItem(index, context);
      },
    );
  }

  Widget _showErrorScreen() {
    return Center(
      child: GestureDetector(
        onTap: getData,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppLocalizations.of(context).translate('errorText')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(AppLocalizations.of(context).translate('retryText')),
                SizedBox(width: 5),
                Icon(
                  Icons.refresh,
                  size: 16,
                  color: Theme.of(context).accentColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Category> _filterCategory(String text) {
    List<Category> results = [];
    _categories.forEach((item) {
      if(item.title.toLowerCase().contains(text.toLowerCase())) {
        results.add(item);
      }
    });
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError ? _showErrorScreen() : _buildCategories(context)),
    );
  }
}
