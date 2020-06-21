import '../../pages/contacts/friend.dart';

import '../../commons/res/styles.dart';
import '../../commons/config.dart';
import '../../commons/ui/image_view.dart';

import '../../utils/utils.dart';
import '../../utils/jpush_util.dart';
import '../../utils/route_util.dart';

import 'package:flutter/material.dart';

class NameCardMessageView extends StatelessWidget {
  final JMCustomMessage message;
  final MessageSendType type;

  NameCardMessageView({Key key, @required this.message, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Ink(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: borderRadius(type)),
            child: InkWell(
                borderRadius: borderRadius(type),
                child: Container(
                    constraints: BoxConstraints(maxWidth: Utils.width * .65),
                    child: ClipRRect(
                        borderRadius: borderRadius(type),
                        child: Column(children: [
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18.0),
                              child: Row(children: <Widget>[
                                ImageView('${message.customObject["avatar"]}',
                                    radius: 20),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text('${message.customObject["nickname"]}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      SizedBox(height: 5),
                                      Text('bersdness cose',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))
                                    ]))
                              ])),
                          Container(
                              width: double.infinity,
                              color: Color(0xff60B47A),
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Name Card',
                                  style: TextStyle(color: Colors.white)))
                        ], mainAxisSize: MainAxisSize.min))),
                onTap: () {
                  /// TODO 跳转到名片用户详情界面
                  pushNewPage(
                      context,
                      FriendInfoPage(
                          identifier: message.customObject["identifier"]));
                })));
  }
}
