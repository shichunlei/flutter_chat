import 'package:flutter/material.dart';
import '../generated/i18n.dart';

import '../commons/index.dart';

import '../pages/chats/group/mygroup.dart';
import '../pages/contacts/new_friends.dart';

class ContactHeaderView extends StatelessWidget {
  const ContactHeaderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Material(
            color: Colors.white,
            child: InkWell(
                onTap: () => pushNewPage(context, NewFriendsPage()),
                child: Container(
                    child: Row(children: <Widget>[
                      ImageView(
                        'images/icon_addFriend.png',
                        imageType: ImageType.assets,
                        height: 30,
                        width: 30,
                        radius: 3,
                      ),
                      Container(
                          child: Text('${S.of(context).new_friend}'),
                          height: double.infinity,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 15))
                    ]),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10)))),
        Material(
            color: Colors.white,
            child: InkWell(
                onTap: () => pushNewPage(context, MyGroupsPage()),
                child: Container(
                    child: Row(children: <Widget>[
                      ImageView(
                        'images/icon_addgroup.png',
                        imageType: ImageType.assets,
                        height: 30,
                        width: 30,
                        radius: 3,
                      ),
                      Expanded(
                        child: Stack(children: <Widget>[
                          Container(
                              child: Text('${S.of(context).group_chat}'),
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 15)),
                          Positioned(
                              child: Container(
                                  height: 1, color: Color(0xFFEFEFEF)),
                              left: 0,
                              right: 0)
                        ]),
                      )
                    ]),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10)))),
        Material(
            color: Colors.white,
            child: InkWell(
                onTap: () {},
                child: Container(
                    child: Row(children: <Widget>[
                      ImageView(
                        'images/icon_ContactTag.png',
                        imageType: ImageType.assets,
                        height: 30,
                        width: 30,
                        radius: 3,
                      ),
                      Expanded(
                        child: Stack(children: <Widget>[
                          Container(
                              child: Text('${S.of(context).tags}'),
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 15)),
                          Positioned(
                              child: Container(
                                  height: 1, color: Color(0xFFEFEFEF)),
                              left: 0,
                              right: 0)
                        ]),
                      )
                    ]),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10)))),
        Material(
            color: Colors.white,
            child: InkWell(
                onTap: () {},
                child: Container(
                    child: Row(children: <Widget>[
                      ImageView(
                        'images/icon_offical.png',
                        imageType: ImageType.assets,
                        height: 30,
                        width: 30,
                        radius: 3,
                      ),
                      Expanded(
                        child: Stack(children: <Widget>[
                          Container(
                              child: Text('${S.of(context).official_accounts}'),
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 15)),
                          Positioned(
                              child: Container(
                                  height: 1, color: Color(0xFFEFEFEF)),
                              left: 0,
                              right: 0)
                        ]),
                      )
                    ]),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10))))
      ]),
    );
  }
}
