import 'package:flutter/material.dart';
import 'package:flutter_chat/commons/index.dart';
import 'package:flutter_chat/model/user.dart';

class ItemGridMember extends StatelessWidget {
  final UserBean user;
  final VoidCallback onTap;
  final bool showDel;
  final VoidCallback onDelTap;

  const ItemGridMember(
      {Key key, this.user, this.onTap, this.showDel: false, this.onDelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = (Utils.width - 60) / 5.0;

    return GestureDetector(
        onTap: showDel ? null : onTap,
        child: Container(
          child: Column(children: [
            Stack(children: <Widget>[
              ImageView('${user.avatarUrl}',
                  height: size,
                  width: size,
                  radius: 5,
                  placeholder: 'images/header.jpeg'),
              Visibility(
                  visible: showDel,
                  child: Positioned(
                      child: GestureDetector(
                          onTap: onDelTap,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(Icons.cancel, color: Colors.red))),
                      top: 0,
                      left: 0))
            ]),
            Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis)
          ]),
        ));
  }
}
