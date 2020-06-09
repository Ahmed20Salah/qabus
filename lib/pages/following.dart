import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/sub_category.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  bool _isLoading = false;
  bool _hasError = false;
  List<SubCategory> _topics = [];
  bool hasChanged = false;
  bool isArabic = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final storage = new FlutterSecureStorage();
    final String savedTopics = await storage.read(key: 'topics');
    List<int> topicsSaved = [];
    if (savedTopics != null) {
      if (savedTopics != '') {
        topicsSaved = savedTopics.split(',').map((i) => int.parse(i)).toList();
      }
    }
    setState(() {
      _isLoading = true;
      _hasError = false;
      hasChanged = false;
    });
    try {
      final List<SubCategory> topics =
          await ExplorePageService.getTopicSubCategories();
      if (topics == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return null;
      }
      List<SubCategory> sortedTopics = [];
      topicsSaved.forEach((int id) {
        final topicIndex =
            topics.indexWhere((SubCategory topic) => topic.id == id);
        if (topicIndex > -1) {
          topics[topicIndex].toggleSelect(true);
          sortedTopics.add(topics[topicIndex]);
          topics.removeAt(topicIndex);
        }
      });
      sortedTopics.addAll(topics);
      setState(() {
        _isLoading = false;
        _topics = sortedTopics;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void onSavePressed(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    _topics.retainWhere((item) => item.isSelected);
    await ExplorePageService.saveTopicsToPhone(
        _topics.map((item) => item.id).toList());
    final AccountService accountService = Provider.of<AccountService>(context);
    if (accountService.currentUser != null) {
      final bool result = await ExplorePageService.saveTopics(
          _topics.map((item) => item.id).toList(),
          accountService.currentUser.userId);
      if (result ==  null || !result) {
        throw Exception('failed saving to phone');
      }
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    if(appLanguage.appLocal != Locale('en')) {
      isArabic = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context).translate('followingPageTitle'),
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          hasChanged
              ? FlatButton(
                  child: Text(AppLocalizations.of(context).translate('save')),
                  onPressed: () => onSavePressed(context),
                )
              : Container()
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_hasError
              ? Center(
                  child: Text(AppLocalizations.of(context).translate('errorText')),
                )
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.black26,
                    );
                  },
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  itemCount: _topics.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildTile(_topics[index]);
                  },
                )),
    );
  }

  CheckboxListTile _buildTile(SubCategory category) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool value) {
        setState(() {
          hasChanged = true;
          category.toggleSelect(value);
        });
      },
      value: category.isSelected,
      title: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 160,
            ),
            child: Text(
              isArabic ? category.titleArb : category.title,
              softWrap: true,
            ),
          ),
          Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.black12,
              width: 50,
              height: 50,
              child: Image.network(URLs.serverURL + category.image),
            ),
          ),
        ],
      ),
    );
  }
}
