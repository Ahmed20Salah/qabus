import 'package:flutter/material.dart';

class WidgetListPage extends StatelessWidget {
  final String pageTitle;
  final List<Widget> widgets;
  WidgetListPage({@required this.pageTitle, @required this.widgets})
      : assert(pageTitle != null),
        assert(widgets != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int index) => widgets[index],
      ),
    );
  }

  AppBar _buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      centerTitle: false,
      title: Text(pageTitle, style: Theme.of(context).textTheme.title,),
    );
  }
}
