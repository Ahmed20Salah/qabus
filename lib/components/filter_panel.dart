import 'package:flutter/material.dart';
import 'package:qabus/modals/area.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/services/localization.dart';
import 'package:qabus/state_management/scoped_panel_ctrl.dart';
import 'package:scoped_model/scoped_model.dart';

class FilterPanel extends StatefulWidget {
  final ScopedController panelController;
  FilterPanel({this.panelController});
  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  SORT_BY _selectedSortByOption;
  int _review = 3;
  List<Area> _areas = [];
  List<Area> _selectedAreas = [];

  Widget _buildRadioBtn(SORT_BY filter, String text) {
    return SizedBox(
      height: 35,
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        onPressed: () => setState(() => _selectedSortByOption = filter),
        child: Row(
          children: <Widget>[
            Radio(
              value: filter,
              groupValue: _selectedSortByOption,
              onChanged: (SORT_BY value) =>
                  setState(() => _selectedSortByOption = value),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.display3,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBoxBtn(Area area) {
    return SizedBox(
      height: 35,
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        onPressed: () {
          setState(() {
            if (_selectedAreas.contains(area)) {
              _selectedAreas.remove(area);
            } else {
              _selectedAreas.add(area);
            }
          });
        },
        child: Row(
          children: <Widget>[
            Checkbox(
              activeColor: Theme.of(context).accentColor,
              value: _selectedAreas.contains(area),
              onChanged: (bool value) {
                setState(() {
                  if (value) {
                    _selectedAreas.add(area);
                  } else {
                    _selectedAreas.remove(area);
                  }
                });
              },
            ),
            Text(
              area.name,
              style: Theme.of(context).textTheme.display3,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRadioBtnList() {
    return [
      _buildRadioBtn(SORT_BY.DISTANCE, AppLocalizations.of(context).translate('distance')),
      _buildRadioBtn(SORT_BY.NAME, AppLocalizations.of(context).translate('nameA-Z')),
      _buildRadioBtn(SORT_BY.POPULARITY, AppLocalizations.of(context).translate('popularity')),
      _buildRadioBtn(SORT_BY.RATING, AppLocalizations.of(context).translate('overallRating')),
    ];
  }

  List<Widget> _buildCheckBoxBtnList() {
    if (_areas == null || _areas.length < 1) {
      return [];
    }
    return _areas.map((item) => _buildCheckBoxBtn(item)).toList();
  }

  @override
  void initState() {
    super.initState();
    _getAreas();
  }

  void _getAreas() async {
    try {
      final List<Area> areas = await ExplorePageService.getAreas();
      setState(() {
        _areas = areas;
      });
    } catch (e) {
      _areas = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: _buildPanel(context),
            ),
          ),
          _buildBottomBtns(context),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ScopedController modal) {
        if (modal.filterType == FILTER_TYPE.SORT_BY) {
          return _buildBasicFilter(context);
        } else if (modal.filterType == FILTER_TYPE.ALL_AREAS) {
          return _buildAllAreas(context);
        }
        return _buildOtherFilters(context);
      },
    );
  }

  Widget _buildBasicFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(AppLocalizations.of(context).translate('sortBy'), style: Theme.of(context).textTheme.display1),
        ),
        ..._buildRadioBtnList(),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(AppLocalizations.of(context).translate('area'), style: Theme.of(context).textTheme.display1),
              FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('seeMore'),
                  style: Theme.of(context).textTheme.display2,
                ),
                onPressed: () {
                  widget.panelController
                      .changeFilterType(FILTER_TYPE.ALL_AREAS);
                },
              ),
            ],
          ),
        ),
        ..._buildCheckBoxBtnList().sublist(0, 4),
      ],
    );
  }

  Widget _buildAllAreas(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(AppLocalizations.of(context).translate('allAreas'), style: Theme.of(context).textTheme.display1),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextField(
            cursorColor: Theme.of(context).accentColor,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('search'),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 10),
        ..._buildCheckBoxBtnList(),
      ],
    );
  }

  Widget _buildOtherFilters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(AppLocalizations.of(context).translate('reviews'), style: Theme.of(context).textTheme.display1),
        ),
        _buildReviewRow(context),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(AppLocalizations.of(context).translate('features'), style: Theme.of(context).textTheme.display1),
        ),
        ..._buildCheckBoxBtnList(),
      ],
    );
  }

  Widget _buildBottomBtns(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
            onPressed: _resetForm,
            fillColor: Color(0xFFF9B4C8),
            child: Text(
              AppLocalizations.of(context).translate('reset'),
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            constraints: BoxConstraints(minHeight: 60, minWidth: 110),
          ),
          SizedBox(width: 15),
          Expanded(
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              onPressed: _applyFilter,
              fillColor: Theme.of(context).accentColor,
              child: Text(
                AppLocalizations.of(context).translate('apply'),
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: Colors.white,
                    ),
              ),
              constraints: BoxConstraints(minHeight: 60),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReviewRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ..._buildStars(_review),
          Spacer(),
          Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                '$_review / 5',
                style: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(15),
              ))
        ],
      ),
    );
  }

  List<Widget> _buildStars(int number) {
    List<Widget> stars = List.generate(5, (int index) {
      return SizedBox(
        height: 30,
        width: 30,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _review = index + 1;
            });
          },
          child: Icon(
            Icons.star,
            color: index < number ? Colors.yellow : Colors.grey,
          ),
        ),
      );
    });
    return stars;
  }

  void _resetForm() {
    widget.panelController.changeFilterType(FILTER_TYPE.SORT_BY);
    widget.panelController.changeSortBy(null);
    _selectedSortByOption = null;
    widget.panelController.controller.close();
    _selectedAreas = [];
    widget.panelController.changeSelectedAreas([]);
  }

  void _applyFilter() {
    widget.panelController.changeSortBy(_selectedSortByOption);
    widget.panelController.changeSelectedAreas(_selectedAreas);
    widget.panelController.controller.close();
  }
}
