import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/pages/auth/auth.dart';
import 'package:qabus/pages/basic_page.dart';
import 'package:qabus/pages/following.dart';
import 'package:qabus/pages/profile/profile.dart';
import 'package:qabus/pages/qatar.dart';
import 'package:qabus/qabuss_icons_icons.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/url.dart';
import 'package:share_extend/share_extend.dart';

class CustomDrawer extends StatelessWidget {
  Widget _buildDrawerItem(String text, IconData icon,
      [VoidCallback onPressed]) {
    return FlatButton(
      padding: EdgeInsets.all(00),
      child: ListTile(
        dense: true,
        title: Text(text, style: TextStyle(fontSize: 15, color: Colors.black)),
        leading: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AccountService auth = Provider.of<AccountService>(context);
    final appLanguage = Provider.of<AppLanguage>(context);

    final User user = auth.currentUser;
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildDrawerHeader(context, user),
              FlatButton(
                padding: EdgeInsets.all(00),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.translate,
                    color: Colors.black,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('changeLanguage'),
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  appLanguage.changeLanguage(appLanguage.appLocal == Locale('en')
                      ? Locale('ar')
                      : Locale('en'));
                },
              ),
              Divider(),
              ..._buildDrawerItems(context),
              user != null
                  ? _buildDrawerItem(AppLocalizations.of(context).translate('logoutText'), Icons.exit_to_app, () {
                      Navigator.of(context).pop();
                      auth.logout();
                    })
                  : _buildDrawerItem(
                      AppLocalizations.of(context).translate('loginText'),
                      Icons.person_outline,
                      () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => AuthPage(),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page, BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => page,
      ),
    );
  }

  void _onPressCallback(String code, BuildContext context) {
    switch (code) {
      case 'ABOUT':
      case 'LOCATE':
      case 'HELP':
      case 'TERMS':
        _navigateTo(BasicPage(code), context);
        break;
      case 'QATAR':
        _navigateTo(QatarPage(), context);
        break;
      case 'FOLLOWING':
        _navigateTo(FollowingPage(), context);
        break;
      case 'SETTINGS':
        AppSettings.openAppSettings();
        break;
      case 'SPREAD':
        ShareExtend.share(
            'Check out Qabuss from http:www.qabuss.com/mobileapp', 'text');
        break;
    }
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        'text': AppLocalizations.of(context).translate('aboutQatar'),
        'icon': QabussIcons.info,
        'code': 'QATAR'
      },
      {
        'text': AppLocalizations.of(context).translate('aboutUs'),
        'icon': Icons.perm_device_information,
        'code': 'ABOUT'
      },
      {
        'text': AppLocalizations.of(context).translate('following'),
        'icon': Icons.favorite,
        'code': 'FOLLOWING'
      },
      {
        'text': AppLocalizations.of(context).translate('needHelp'),
        'icon': Icons.help_outline,
        'code': 'HELP'
      },
      {
        'text': AppLocalizations.of(context).translate('locateUs'),
        'icon': Icons.location_on,
        'code': 'LOCATE'
      },
      {
        'text': AppLocalizations.of(context).translate('appSettings'),
        'icon': Icons.settings_applications,
        'code': 'SETTINGS'
      },
      {
        'text': AppLocalizations.of(context).translate('feedback'),
        'icon': Icons.chat,
        'code': 'FEEDBACK'
      },
      {
        'text': AppLocalizations.of(context).translate('likeThisApp'),
        'icon': Icons.thumb_up,
        'code': 'LIKE'
      },
      {
        'text': AppLocalizations.of(context).translate('spreadTheWord'),
        'icon': Icons.share,
        'code': 'SPREAD'
      },
      {
        'text': AppLocalizations.of(context).translate('termsAndConditions'),
        'icon': Icons.description,
        'code': 'TERMS'
      },
    ];
    return items
        .map(
          (item) => _buildDrawerItem(
            item['text'],
            item['icon'],
            () => _onPressCallback(item['code'], context),
          ),
        )
        .toList();
  }

  Widget buildDrawerHeader(BuildContext context, User user) {
    return user != null
        ? Container(
            height: 100,
            child: FlatButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfilePage(user),
                  ),
                );
              },
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(URLs.serverURL + user.imageURL),
                ),
                title: Text(user.name == null ? 'Qabuss User' : user.name,
                    style: Theme.of(context).textTheme.subtitle),
                subtitle: user.email == null ? Container() : Text(user.email),
              ),
            ),
          )
        : Container(
            height: 100,
            child: FlatButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AuthPage(),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context).translate('loginTitle'),
                      style: Theme.of(context).textTheme.display2),
                  Text(AppLocalizations.of(context).translate('loginSubtitle'))
                ],
              ),
            ),
          );
  }
}
