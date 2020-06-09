import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:qabus/data.dart';
import 'package:qabus/modals/qatar_page_content.dart';
import 'package:qabus/services/basic_page_service.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';

enum CONTENT_TYPE { ABOUT, CONTACT, NEWS }

class QatarPage extends StatefulWidget {
  @override
  _QatarPageState createState() => _QatarPageState();
}

class _QatarPageState extends State<QatarPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  bool _isScrolled = false;
  CONTENT_TYPE _type;
  // int _showFullText = 0;
  bool _isQatarLoaded = false;
  List<QatarPageContent> _qatarData = [];

  void _onScroll() {
    if (_scrollController.offset >= 100 && _isScrolled == false) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_isScrolled && _scrollController.offset < 100) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  void _changeContentType(CONTENT_TYPE type) {
    if (_type == type) {
      return;
    }
    setState(() {
      _type = type;
    });
  }

  Widget _buildContentTypeBtn(
    CONTENT_TYPE type, [
    AxisDirection direction,
  ]) {
    double bottomLeft = 0;
    double bottomRight = 0;
    double topLeft = 0;
    double topRight = 0;

    if (direction == AxisDirection.right) {
      bottomLeft = 15;
      bottomRight = 0;
      topLeft = 15;
      topRight = 0;
    } else if (direction == AxisDirection.left) {
      bottomLeft = 0;
      bottomRight = 15;
      topLeft = 0;
      topRight = 15;
    }

    return Container(
      height: 30,
      width: 100,
      margin: EdgeInsets.only(bottom: 10),
      child: RawMaterialButton(
        elevation: 0,
        fillColor: _type == type ? Theme.of(context).accentColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomLeft),
            topLeft: Radius.circular(topLeft),
            bottomRight: Radius.circular(bottomRight),
            topRight: Radius.circular(topRight),
          ),
        ),
        onPressed: () => _changeContentType(type),
        child: Text(
          type == CONTENT_TYPE.ABOUT
              ? AppLocalizations.of(context).translate('about')
              : (type == CONTENT_TYPE.CONTACT ? AppLocalizations.of(context).translate('contact') : AppLocalizations.of(context).translate('news')),
          style: _type == type
              ? Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.white)
              : Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    final bool isArabic = appLanguage.appLocal == Locale('en') ? false : true;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: _isScrolled
            ? Colors.white.withOpacity(0.8)
            : Colors.white.withOpacity(0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Platform.isIOS
                        ? IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              color: _isScrolled ? Colors.black : Colors.white,
                              size: 38,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        : Container(),
                    Text(
                      AppLocalizations.of(context).translate('aboutQatar'),
                      style: Theme.of(context).textTheme.title.copyWith(
                          color: _isScrolled ? Colors.black : Colors.white,
                          height: 1.6),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildContentTypeBtn(CONTENT_TYPE.ABOUT,
                        isArabic ? AxisDirection.left : AxisDirection.right),
                    _buildContentTypeBtn(CONTENT_TYPE.CONTACT, null),
                    _buildContentTypeBtn(CONTENT_TYPE.NEWS,
                        isArabic ? AxisDirection.right : AxisDirection.left)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _type = CONTENT_TYPE.ABOUT;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadQatarData();
  }

  void _loadQatarData() async {
    final List<QatarPageContent> response =
        await BasicPageService.getQatarContent();
    setState(() {
      _qatarData = response;
      _isQatarLoaded = true;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    QatarPageContent item = _qatarData[index - 1];
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 50),
          child: Text(
            item.title,
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(item.summery),
        ),
        FadeInImage(
          image: NetworkImage(Data.serverURL + item.image),
          placeholder: AssetImage('assets/images/qatar_cover.png'),
          height: 250,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10),
        // _buildExpandedText(context, index, item.content),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Html(
            data: item.content,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _isQatarLoaded
        ? ListView.builder(
            padding: EdgeInsets.only(bottom: 50),
            controller: _scrollController,
            itemCount: _qatarData.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return FadeInImage(
                  image: AssetImage('assets/images/qatar_cover.png'),
                  placeholder: AssetImage('assets/images/qatar_cover.png'),
                  height: 250,
                  fit: BoxFit.cover,
                );
              }
              return _buildListItem(context, index);
            },
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget _buildTabs(BuildContext context) {
    Widget toReturn;
    switch (_type) {
      case CONTENT_TYPE.ABOUT:
        toReturn = _buildAboutSection(context);
        break;
      case CONTENT_TYPE.CONTACT:
        toReturn = Center(
          child: Text('Contact'),
        );
        break;
      case CONTENT_TYPE.NEWS:
        toReturn = Center(
          child: Text('News'),
        );
        break;
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _buildTabs(context),
        _buildTopBar(context),
      ],
    ));
  }

  // void _toggleShowText([int index = 0]) {
  //   setState(() {
  //     _showFullText = index;
  //   });
  // }

  // Widget _buildExpandedText(BuildContext context, int index, String content) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 15),
  //     child: AnimatedSize(
  //       curve: Curves.easeOut,
  //       vsync: this,
  //       duration: Duration(milliseconds: 500),
  //       child: Column(
  //         children: <Widget>[
  //           ConstrainedBox(
  //             constraints: _showFullText == index
  //                 ? BoxConstraints()
  //                 : BoxConstraints(maxHeight: 90),
  //             child: Html(
  //               shrinkToFit: true,
  //               data: content,
  //             ),
  //           ),
  //           RawMaterialButton(
  //             onPressed: _showFullText == index
  //                 ? _toggleShowText
  //                 : () => _toggleShowText(index),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: _showFullText == index
  //                   ? <Widget>[
  //                       Text(
  //                         'View less',
  //                         style: Theme.of(context).textTheme.display2,
  //                       ),
  //                       Icon(
  //                         Icons.keyboard_arrow_up,
  //                         size: 16,
  //                         color: Theme.of(context).accentColor,
  //                       )
  //                     ]
  //                   : <Widget>[
  //                       Text(
  //                         'View more',
  //                         style: Theme.of(context).textTheme.display2,
  //                       ),
  //                       Icon(
  //                         Icons.keyboard_arrow_down,
  //                         size: 16,
  //                         color: Theme.of(context).accentColor,
  //                       )
  //                     ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
