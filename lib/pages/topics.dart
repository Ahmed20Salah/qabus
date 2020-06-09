import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:qabus/data.dart';
import 'package:qabus/modals/category.dart';
import 'package:qabus/modals/sub_category.dart';
import 'package:qabus/pages/tabs.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/localization.dart';

class TopicsPage extends StatefulWidget {
  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  int expandedPanel = 0;
  List<Map<String, dynamic>> _topics = [];
  bool _isValid = false;
  bool _didDataLoadOnce = false;
  bool _isLoading = true;
  bool _hasError = false;

  void _getData() async {
    if (_didDataLoadOnce) {
      return null;
    }
    setState(() {
      _didDataLoadOnce = true;
      _isLoading = true;
      _hasError = false;
    });
    try {
      final List<Map<String, dynamic>> topics =
          await ExplorePageService.getTopicCategories();
      if (topics == null) {
        setState(() {
          _isLoading = false;
          _isValid = false;
          _hasError = true;
        });
        return null;
      }
      setState(() {
        _isLoading = false;
        _topics = topics;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isValid = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
      backgroundColor: Colors.white70,
      bottomNavigationBar: _buildBottomButton(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError
              ? Center(
                  child: Text(AppLocalizations.of(context).translate('errorText')),
                )
              : _buildBody()),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              AppLocalizations.of(context).translate('topicsPageTitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: Text(
                AppLocalizations.of(context).translate('topicsPageSubtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            ..._buildCategories(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategories() {
    return _topics.map((category) {
      return _buildTopicCategory(category);
    }).toList();
  }

  bool _isAllTopicsSelected(List<SubCategory> subCategories) {
    bool returnValue = true;
    subCategories.forEach((SubCategory item) {
      if (!item.isSelected) {
        returnValue = false;
      }
    });
    return returnValue;
  }

  void _checkRequirements() {
    int count = 0;
    _topics.forEach((category) {
      final List<SubCategory> subCategories = category['subcategories'];
      subCategories.forEach((subCat) {
        if (subCat.isSelected) {
          count++;
        }
      });
    });
    if (count >= 5) {
      setState(() {
        _isValid = true;
      });
      return null;
    }
    setState(() {
      _isValid = false;
    });
  }

  Widget _buildTopicCategory(Map<String, dynamic> categoryData) {
    final List<SubCategory> subCategories = categoryData['subcategories'];
    final Category category = categoryData['category'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ExpandablePanel(
        tapBodyToCollapse: false,
        iconColor: Theme.of(context).accentColor,
        header: Container(
          height: 42,
          padding: EdgeInsets.only(left: 10),
          child: Text(
            category.title,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        collapsed: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 50),
          child: Row(
            children: _showSelectedTopics(subCategories),
          ),
        ),
        expanded: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isAllTopicsSelected(subCategories),
                    onChanged: (bool value) {
                      _toggleAllTopicSelectedStatus(subCategories, value);
                      _checkRequirements();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('selectAll'),
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              Wrap(
                children: subCategories.map<Widget>((SubCategory item) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        item.isSelected
                            ? item.toggleSelect(false)
                            : item.toggleSelect(true);
                      });
                      _checkRequirements();
                    },
                    child: _buildTopicSubItem(
                      context,
                      item.title,
                      item.isSelected,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
        tapHeaderToExpand: true,
        hasIcon: true,
      ),
    );
  }

  List<Widget> _showSelectedTopics(List<SubCategory> subCategories) {
    final List<SubCategory> subcats = List.from(subCategories);
    subcats.retainWhere((item) => item.isSelected);
    List<Widget> selectedTopicWidgets = [];
    for (var i = 0; i < subcats.length; i++) {
      if (i == subcats.length - 1) {
        selectedTopicWidgets.add(Padding(
            child: Text(subcats[i].title), padding: EdgeInsets.only(right: 5)));
      } else {
        selectedTopicWidgets.add(Padding(
            child: Text(subcats[i].title + ','),
            padding: EdgeInsets.only(right: 5)));
      }
    }
    return selectedTopicWidgets;
  }

  void _toggleAllTopicSelectedStatus(
      List<SubCategory> subCategories, bool value) {
    setState(() {
      subCategories.forEach((SubCategory item) {
        item.toggleSelect(value);
      });
    });
  }

  Container _buildTopicSubItem(
      BuildContext context, String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 10,
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).accentColor),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(20),
        color: isSelected ? Theme.of(context).accentColor : Colors.white,
      ),
    );
  }

  Container _buildBottomButton() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: _isLoading
            ? Container(
                height: 50,
              )
            : Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate('minimumTopicsMessage'),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500),
                    ),
                    _isValid
                        ? FlatButton(
                            child: Text(
                              AppLocalizations.of(context).translate('continue'),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: _selectTopics,
                          )
                        : Container()
                  ],
                ),
              ),
      ),
    );
  }

  void _selectTopics() async {
    List<int> selectedTopics = [];
    _topics.forEach((category) {
      final List<SubCategory> subCategories = category['subcategories'];
      subCategories.forEach((subCat) {
        if (subCat.isSelected) {
          selectedTopics.add(subCat.id);
        }
      });
    });
    setState(() {
      _isLoading = true;
    });
    final bool result = await ExplorePageService.saveTopicsToPhone(selectedTopics);
    setState(() {
      _isLoading = false;
    });
    if(result) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => TabsPage(),),
      );
    }
  }
}
