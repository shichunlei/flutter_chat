import 'dart:async';

import 'package:amap_search_fluttify/amap_search_fluttify.dart';

import '../model/position.dart';

import '../commons/index.dart';

import 'package:flutter/foundation.dart';

class PoiProvider extends ChangeNotifier {
  LatLng _location;

  LatLng get location => _location;

  LoaderState _state = LoaderState.Loading;

  LoaderState get state => _state;

  setState(LoaderState state) {
    _state = state;
    if (_state == LoaderState.Loading) {
      clear();
    }

    notifyListeners();
  }

  List<Position> _list = [];

  List<Position> get list => _list;

  Future selectedPoi(int index) async {
    _list.forEach((element) {
      if (element == list[index]) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    });

    notifyListeners();
  }

  /// 搜索pois
  ///
  /// [latLng] 经纬度
  /// [keyword] 关键字
  /// [page] 页码(1-100)
  ///
  Future getPoiData({LatLng latLng, String keyword, int page: 1}) async {
    _list.clear();

    if (Utils.isNotEmpty(keyword)) {
      await AmapSearch.searchKeyword(keyword, page: page)
          .then((List<Poi> value) {
        _list.addAll(
            value.map((poi) => Position(poi: poi, selected: false)).toList());
        // 默认勾选第一项
        if (_list.length > 0) {
          _list[0].selected = true;
        }
      });
    } else {
      await AmapSearch.searchAround(latLng, page: page).then((List<Poi> value) {
        _list.addAll(
            value.map((poi) => Position(poi: poi, selected: false)).toList());

        // 默认勾选第一项
        if (_list.length > 0) {
          _list[0].selected = true;
        }
      });
    }

    if (_list.length > 0) {
      print(_list.toString());
      setState(LoaderState.Succeed);
    } else {
      setState(LoaderState.NoData);
    }
  }

  bool _showEdit = false;

  bool get showEdit => _showEdit;

  Future setEditState(bool showEdit) async {
    _showEdit = showEdit;

    notifyListeners();
  }

  Future clear() async {
    _list.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
