import 'package:amap_map_fluttify/amap_map_fluttify.dart';

import '../../model/position.dart';
import '../../generated/i18n.dart';

import 'package:flutter/material.dart';

class PositionInformationPage extends StatefulWidget {
  final Position location;

  PositionInformationPage({Key key, this.location}) : super(key: key);

  @override
  createState() => _PositionInformationPageState();
}

class _PositionInformationPageState extends State<PositionInformationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                : widget.location.poi.address)),
        body: AmapView(centerCoordinate: widget.location.poi.latLng));
  }
}
