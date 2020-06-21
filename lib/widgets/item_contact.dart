import '../commons/res/colors.dart';
import '../commons/ui/image_view.dart';

import '../model/user.dart';
import '../provider/index.dart';

import 'package:flutter/material.dart';

class ItemContact extends StatelessWidget {
  final UserBean user;
  final bool isShowCheck;
  final VoidCallback onTap;

  ItemContact(
      {Key key, @required this.user, this.isShowCheck: false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: InkWell(
            onTap: onTap,
            child: Container(
                height: 60.0,
                child: Row(children: <Widget>[
                  Visibility(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Provider.of<ContactProvider>(context)
                                  .selectContacts
                                  .contains(user)
                              ? Icon(Icons.check_circle, color: checkColor)
                              : Icon(Icons.panorama_fish_eye)),
                      visible: isShowCheck),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ImageView(user?.avatarUrl,
                          radius: 5,
                          height: 40,
                          width: 40, placeholder: 'images/header.jpeg')),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          child: Text('${user?.name}'),
                          height: double.infinity,
                          alignment: Alignment.centerLeft),
                      Positioned(
                          child: Container(height: 1, color: Color(0xFFEFEFEF)),
                          bottom: 0,
                          left: 0,
                          right: 0)
                    ]),
                  )
                ]))));
  }
}
