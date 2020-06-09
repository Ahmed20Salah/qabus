import 'package:flutter/material.dart';
import 'package:qabus/components/drawer.dart';
import 'package:qabus/components/filter_panel.dart';
import 'package:qabus/qabuss_icons_icons.dart';
import 'package:qabus/routes.dart';
import 'package:qabus/state_management/scoped_panel_ctrl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentIndex = 0;

  List<Widget> pages;
  List<GlobalKey<NavigatorState>> navigatorKeys;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _exploreKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _eventsKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _articlesKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _offersKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    navigatorKeys = [_exploreKey, _offersKey, _eventsKey, _articlesKey];
  }

  @override
  Widget build(BuildContext context) {
    final ScopedController _controllerModal = ScopedController();
    _controllerModal.scaffoldKey = _scaffoldKey;
    return ScopedModel<ScopedController>(
      model: _controllerModal,
      child: SlidingUpPanel(
        panel: FilterPanel(panelController: _controllerModal),
        controller: _controllerModal.controller,
        backdropEnabled: true,
        minHeight: 0,
        body: WillPopScope(
          onWillPop: () async =>
              !await navigatorKeys[currentIndex].currentState.maybePop(),
          child: Scaffold(
              key: _scaffoldKey,
              drawer: CustomDrawer(),
              drawerEdgeDragWidth: 0,
              bottomNavigationBar: _buildBottomBar(context),
              body: _buildBody()
              // body: pages[currentIndex],
              ),
        ),
      ),
    );
  }

  Stack _buildBody() {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: currentIndex != 0,
          child: TabNavigator(initialRoute: Routes.explore, navigatorKey: navigatorKeys[0],),
        ),
        Offstage(
          offstage: currentIndex != 1,
          child: TabNavigator(initialRoute: Routes.offers, navigatorKey: navigatorKeys[1],)
        ),
        Offstage(
          offstage: currentIndex != 2,
          child: TabNavigator(initialRoute: Routes.events, navigatorKey: navigatorKeys[2],),
        ),
        Offstage(
          offstage: currentIndex != 3,
          child: TabNavigator(initialRoute: Routes.articles, navigatorKey: navigatorKeys[3],),
        ),
      ],
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: TabBar(
            onTap: (int index) {
              setState(() => currentIndex = index);
            },
            indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
            indicatorWeight: 3,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.black,
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(QabussIcons.explore_filled, size: 22),
              ),
              Tab(
                icon: Icon(Icons.card_giftcard, size: 25),
              ),
              Tab(
                icon: Icon(QabussIcons.events, size: 16),
              ),
              Tab(
                icon: Icon(QabussIcons.articles, size: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.initialRoute});
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final routeBuilders = Routes().routeBuilders(context);
    return Navigator(
        key: navigatorKey,
        initialRoute: initialRoute,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name](context));
        });
  }
}
