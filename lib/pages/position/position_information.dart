import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../generated/i18n.dart';
import '../../model/position.dart';

class PositionInformationPage extends StatefulWidget {
  final Position location;

  PositionInformationPage({Key key, this.location}) : super(key: key);

  @override
  createState() => _PositionInformationPageState();
}

class _PositionInformationPageState extends State<PositionInformationPage> {
  AmapController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            centerTitle: true,
            title: Text(widget.location == null
                ? S.of(context).title_position_info
                : widget.location.poi.title)),
        body: AmapView(
            onMapCreated: (controller) async {
              _controller = controller;

              if (await Permission.location.request().isGranted) {
                await _controller.showMyLocation(MyLocationOption());

                await _controller.addMarker(MarkerOption(
                    latLng: widget.location.poi.latLng,
                    iconProvider: AssetImage("images/icon_location.png"),
//                    imageConfig: createLocalImageConfiguration(context),
                    title: widget.location.poi.title,
                    snippet: '描述'));
              } else {
                print('没有权限');
              }
            },
            zoomLevel: 18,

            /// 开始移动
            onMapMoveStart: (MapMove move) async {
              print(
                  '开始移动:lat: ${move.latLng.latitude}, lng: ${move.latLng.longitude}');
            },

            /// 移动结束
            onMapMoveEnd: (MapMove move) async {
              print(
                  '结束移动:lat: ${move.latLng.latitude}, lng: ${move.latLng.longitude}');
            }));
  }
}
