import 'package:flutter/material.dart';

import '../model/position.dart';

class ItemPoiView extends StatelessWidget {
  final Position position;
  final VoidCallback onTap;

  ItemPoiView({Key key, @required this.position, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          position.poi.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(position.poi.address,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: onTap,
        trailing: position.selected ? Icon(Icons.check) : SizedBox());

//    return Material(
//        color: Colors.white,
//        child: InkWell(
//            child: Container(
//                padding: const EdgeInsets.all(15.0),
//                child: Text(
//                  '${position.poi.title}',
//                  style: TextStyle(
//                      color: position.selected ? Colors.green : Colors.grey),
//                )),
//            onTap: onTap));
  }
}
