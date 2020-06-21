import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../model/position.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../widgets/item_poi_position.dart';
import '../../commons/ui/loader.dart';
import '../../provider/index.dart';

import '../../generated/i18n.dart';
import '../../utils/utils.dart';

import 'package:flutter/material.dart';

const _iconSize = 50.0;
const _indicator = 'images/location.png';
double _fabHeight = 16.0;

class SearchPositionPage extends StatefulWidget {
  SearchPositionPage({Key key}) : super(key: key);

  @override
  createState() => _SearchPositionPageState();
}

class _SearchPositionPageState extends State<SearchPositionPage>
    with SingleTickerProviderStateMixin {
  AmapController _amapController;

  // 动画相关
  AnimationController _jumpController;
  Animation<Offset> _tween;

  TextEditingController textEditingController;

  /// 定位点坐标
  LatLng centerLatLng;

  /// 标记是否要重新根据地图中心点获取数据
  bool reLoadData = true;

  int page = 1;

  String keyword = "";

  @override
  void initState() {
    super.initState();

    _jumpController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _tween = Tween(begin: Offset(0, 0), end: Offset(0, -15)).animate(
        CurvedAnimation(parent: _jumpController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    _jumpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PoiProvider>(
        builder: (context, PoiProvider provider, Widget child) {
      return Stack(children: <Widget>[
        Scaffold(
            backgroundColor: Colors.grey[200],
            body: Column(children: [
              Container(
                  height: 250,
                  child: Stack(children: <Widget>[
                    AmapView(
                        zoomLevel: 18,
                        showZoomControl: false,
                        onMapCreated: (controller) async {
                          _amapController = controller;

                          if (await Permission.location.request().isGranted) {
                            provider..setState(LoaderState.Loading);
                            _showMyLocation();
                          } else {
                            print('没有权限');
                          }
                        },

                        /// 开始移动
                        onMapMoveStart: (MapMove move) async {
                          print(
                              '开始移动:lat: ${move.latLng.latitude}, lng: ${move.latLng.longitude}');
                        },

                        /// 移动结束
                        onMapMoveEnd: (MapMove move) async {
                          print(
                              '结束移动:lat: ${move.latLng.latitude}, lng: ${move.latLng.longitude}');

                          // 地图移动结束, 显示跳动动画
                          _jumpController
                              .forward()
                              .then((it) => _jumpController.reverse());

                          if (reLoadData) {
                            page = 1;
                            keyword = "";

                            centerLatLng = move.latLng;

                            provider
                              ..setState(LoaderState.Loading)
                              ..getPoiData(latLng: move.latLng, page: page);
                          }

                          /// 设置为ture是为了保证下次如果是手动滑动地图时重新获取数据，如果下次不是手动移动的地图则会先把reLoadData设置为false再移动
                          reLoadData = true;
                        }),
                    Center(
                        child: AnimatedBuilder(
                            animation: _tween,
                            builder: (BuildContext context, Widget child) {
                              return Transform.translate(
                                  offset: Offset(_tween.value.dx,
                                      _tween.value.dy - _iconSize / 2),
                                  child: child);
                            },
                            child: Image.asset(_indicator, height: _iconSize))),
                    Positioned(
                        child: FloatingActionButton(
                            mini: true,
                            onPressed: () {
                              /// 重新定位到当前所在位置（即将定位点设置为地图中心点）
                              _showMyLocation();
                            },
                            backgroundColor: Colors.white,
                            child:
                                Icon(Icons.gps_fixed, color: Colors.black54)),
                        right: _fabHeight,
                        bottom: _fabHeight)
                  ])),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  height: 50.0,
                  child: provider.showEdit
                      ? Row(children: <Widget>[
                          Expanded(
                              child: TextField(
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55.0))),
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) {
                                    page = 1;

                                    setState(() {
                                      keyword = value;
                                    });

                                    provider
                                      ..setEditState(false)
                                      ..setState(LoaderState.Loading)
                                      ..getPoiData(keyword: keyword, page: page)
                                          .then((value) => _setCenterCoordinate(
                                              provider.list[0].poi.latLng,
                                              reLoadData: true));

                                    textEditingController.text = '';
                                  })),
                          Container(
                              width: 60,
                              margin: EdgeInsets.only(left: 10),
                              child: FlatButton(
                                  padding: EdgeInsets.only(left: 1, right: 1),
                                  shape: StadiumBorder(),
                                  child: Text(S.of(context).cancel,
                                      style: TextStyle(color: Colors.blue)),
                                  onPressed: () {
                                    provider.setEditState(false);
                                    _showMyLocation();
                                  }))
                        ])
                      : Container(
                          width: double.infinity,
                          child: FlatButton(
                              shape: StadiumBorder(),
                              child: Text(S.of(context).search),
                              color: Colors.white,
                              onPressed: () {
                                provider
                                  ..setEditState(true)
                                  ..clear();
                              }))),
              Expanded(
                  child: LoaderContainer(
                      contentView: EasyRefresh(
                          onLoad: () async {
                            page++;

                            provider.getPoiData(
                                latLng: centerLatLng,
                                keyword: keyword,
                                page: page);
                          },
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (_, index) {
                                return ItemPoiView(
                                    position: provider.list[index],
                                    onTap: () {
                                      provider.selectedPoi(index);

                                      /// 将选中的位置设置为地图中心点
                                      _setCenterCoordinate(
                                          provider.list[index].poi.latLng,
                                          reLoadData: false);
                                    });
                              },
                              itemCount: provider.list.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      SizedBox(height: 1))),
                      loaderState: provider.state))
            ])),
        Container(
            height: Utils.navigationBarHeight,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    actions: <Widget>[
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                          child: FlatButton(
                              disabledColor: Color(0xFFB6DFC9),
                              shape: StadiumBorder(),
                              onPressed: provider.state == LoaderState.Loading
                                  ? null
                                  : () {
                                      Position position = provider.list
                                          .firstWhere(
                                              (element) => element.selected);

                                      Navigator.of(context).pop(position);
                                    },
                              color: Color(0xFF60B47A),
                              child: Text(S.of(context).send,
                                  style: TextStyle(color: Colors.white))))
                    ])))
      ]);
    });
  }

  Future _setCenterCoordinate(LatLng latLng, {bool reLoadData}) async {
    setState(() {
      this.reLoadData = reLoadData;
    });

    await _amapController.setCenterCoordinate(latLng);
  }

  Future _showMyLocation() async {
    await _amapController.showMyLocation(MyLocationOption(
        strokeColor: Colors.transparent,
        fillColor: Colors.transparent,
        show: true));
  }
}
