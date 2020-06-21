import 'package:amap_search_fluttify/amap_search_fluttify.dart';

class Position {
  bool selected = false;
  Poi poi;

  Position({this.poi, this.selected});

  Map toJson() => {
        "poi": poi,
        "selected": selected,
      };
}
