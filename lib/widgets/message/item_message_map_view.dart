import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';

import '../../model/position.dart';
import '../../pages/position/position_information.dart';

import '../../commons/config.dart';
import '../../commons/res/styles.dart';

import '../../utils/utils.dart';
import '../../utils/jpush_util.dart';
import '../../utils/route_util.dart';

import 'package:flutter/material.dart';

class MapMessageView extends StatefulWidget {
  final JMLocationMessage message;
  final MessageSendType type;

  const MapMessageView({Key key, @required this.message, this.type})
      : super(key: key);

  @override
  createState() => _MapMessageViewState();
}

class _MapMessageViewState extends State<MapMessageView>
    with AutomaticKeepAliveClientMixin {
  Position position;

  @override
  void initState() {
    super.initState();

    position = Position(
        poi: Poi(
            latLng: LatLng(widget.message.latitude, widget.message.longitude),
            title: widget.message.address));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
        child: AbsorbPointer(
            child: Container(
                constraints: BoxConstraints(maxWidth: Utils.width * 0.65),
                child: ClipRRect(
                    borderRadius: borderRadius(widget.type),
                    child: Container(
                      child: Column(children: [
                        Container(
                            child: Stack(children: <Widget>[
                              AmapView(
                                  centerCoordinate: position.poi.latLng,
                                  showZoomControl: false,
                                  zoomLevel: 15),
                              Center(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Image.asset('images/location.png',
                                          height: 30)))
                            ]),
                            height: 100.0),
                        Container(
                            width: double.infinity,
                            color: Colors.green,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(position.poi.title,
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis))
                      ]),
                    )))),
        onTap: () =>
            pushNewPage(context, PositionInformationPage(location: position)));
  }

  @override
  bool get wantKeepAlive => true;
}
