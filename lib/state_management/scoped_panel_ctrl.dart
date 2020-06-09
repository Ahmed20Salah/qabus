import 'package:flutter/material.dart';
import 'package:qabus/modals/area.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum SORT_BY { DISTANCE, NAME, RATING, POPULARITY }
enum FILTER_TYPE { SORT_BY, ALL_AREAS, FILTER }

class ScopedController extends Model {
  PanelController controller = PanelController();
  FILTER_TYPE _currentFilterType;
  SORT_BY _currentSortBy;
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Area> _selectedAreas;

  changeFilterType(FILTER_TYPE type) {
    _currentFilterType = type;
    notifyListeners();
  }

  changeSortBy(SORT_BY type) {
    _currentSortBy = type;
    notifyListeners();
  }

  changeSelectedAreas(List<Area> areas) {
    _selectedAreas = areas;
    notifyListeners();
  }

  FILTER_TYPE get filterType => _currentFilterType;
  SORT_BY get sortBy => _currentSortBy;
  List<Area> get selectedAreas => _selectedAreas;
}
