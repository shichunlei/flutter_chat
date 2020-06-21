import 'package:flutter/material.dart';
import '../commons/index.dart';

class ItemBlacklist extends StatelessWidget {
  final JMUserInfo userInfo;
  final VoidCallback onTop;

  const ItemBlacklist({Key key, @required this.userInfo, this.onTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Row(children: <Widget>[
          ImageView(userInfo.extras["avatarUrl"],
              radius: 20, placeholder: 'images/header.jpeg'),
          SizedBox(width: 10),
          Expanded(child: Text(JPushUtil.getName(userInfo))),
          Container(
              width: 60,
              child: RaisedButton(
                  onPressed: onTop,
                  child: Text('移除', style: TextStyle(color: Colors.white)),
                  color: Colors.deepOrange))
        ]));
  }
}
