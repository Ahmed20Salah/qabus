import 'package:flutter/material.dart';
import 'package:qabus/components/event_card.dart';
import 'package:qabus/modals/event.dart';
import 'package:qabus/pages/events/event.dart';
import 'package:qabus/services/events_service.dart';
import 'package:qabus/services/localization.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  List<Event> _todayEvents = [];
  List<Event> _otherEvents = [];

  bool _isSearchActive = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  void _sortEvents() {
    List<Event> todayEvents = [];
    List<Event> otherEvents = [];
    _filteredEvents.forEach((item) {
      if (item.startDate.isBefore(DateTime.now()) &&
          item.endDate.isAfter(DateTime.now())) {
        todayEvents.add(item);
      } else {
        otherEvents.add(item);
      }
    });
    setState(() {
      _todayEvents = todayEvents;
      _otherEvents = otherEvents;
    });
  }

  void _openEvent(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EventPage(),
        settings: RouteSettings(arguments: event),
      ),
    );
  }

  void _getData() async {
    try {
      final List<Event> events = await EventsService.getAllEvents();
      if (events == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return null;
      }
      setState(() {
        _events = events;
        _filteredEvents = _events;
        _isLoading = false;
        _sortEvents();
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
    _getData();
    super.initState();
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
              : _buildBody(context)),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(AppLocalizations.of(context).translate('events'),
          style: Theme.of(context).textTheme.title),
      bottom: _isSearchActive
          ? PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: _searchEvents,
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
                    _filteredEvents = _events;
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _toggleSearchState(context),
              ),
      ],
    );
  }

  void _searchEvents() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      final String searchText = _searchController.text;
      List<Event> result = await EventsService.searchForEvents(searchText);
      if (result != null) {
        setState(() {
          _filteredEvents = result;
        });
        _sortEvents();
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBody(BuildContext context) {

    if(_otherEvents.length == 0 && _todayEvents.length == 0) {
      return Center(child: Text('No Events available.'),);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _todayEvents.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('happeningToday'),
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _todayEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: EventCard(
                            event: _todayEvents[index],
                            width: MediaQuery.of(context).size.width - 30,
                            onPressed: () =>
                                _openEvent(context, _todayEvents[index]),
                          ),
                        );
                      },
                    )
                  ],
                )
              : Container(),
          _otherEvents.length > 0 ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  AppLocalizations.of(context).translate('upcomingEvents'),
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _otherEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: EventCard(
                      event: _otherEvents[index],
                      width: MediaQuery.of(context).size.width - 30,
                      onPressed: () => _openEvent(context, _otherEvents[index]),
                    ),
                  );
                },
              )
            ],
          ): Container()
        ],
      ),
    );
  }
}
