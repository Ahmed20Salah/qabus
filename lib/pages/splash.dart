import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/pages/tabs.dart';
import 'package:qabus/pages/topics.dart';
import 'package:qabus/services/account_service.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void openNextPage(BuildContext context) async {
    final ACCOUNT_STATE state =
        await Provider.of<AccountService>(context).initialSetup();
    Widget nextPage;
    switch (state) {
      case ACCOUNT_STATE.NEW:
        nextPage = TopicsPage();
        break;
      case ACCOUNT_STATE.LOGGED_IN:
      case ACCOUNT_STATE.LOGGED_OUT:
        nextPage = TabsPage();
        break;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => nextPage,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    openNextPage(context);
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
