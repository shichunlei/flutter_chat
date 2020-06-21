import 'package:flutter_chat/commons/config.dart';

import '../commons/ui/image_view.dart';
import '../commons/res/colors.dart';

import '../utils/date_util.dart';
import '../utils/jpush_util.dart';

import 'package:flutter/material.dart';

class ItemChat extends StatelessWidget {
  final JMConversationInfo chat;
  final GestureTapCallback onPress;
  final GestureLongPressCallback onLongPress;
  final GestureTapDownCallback onTapDown;

  ItemChat(
      {Key key,
      @required this.chat,
      this.onPress,
      this.onLongPress,
      this.onTapDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("==================================${chat?.latestMessage}");

    String avatar = '';

    bool isNoDisturb = false; // 是否免打扰

    if (chat.conversationType == JMConversationType.single) {
      // 单聊会话
      JMUserInfo userInfo = chat.target;

      avatar = userInfo.extras["avatarUrl"];

      isNoDisturb = userInfo.isNoDisturb;
    } else if (chat.conversationType == JMConversationType.group) {
      JMGroupInfo groupInfo = chat.target;

      print("--------------->${groupInfo.id}");

      // 群聊会话
      avatar = groupHeaderImage;
      isNoDisturb = groupInfo.isNoDisturb;
    }

    return Material(
        color: topBgColor(chat),
        child: InkWell(
            splashColor: Colors.grey[200],
            onTap: onPress,
            onLongPress: onLongPress,
            onTapDown: onTapDown,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(children: <Widget>[
                  SizedBox(
                      height: 50,
                      width: 60,
                      child: Stack(children: <Widget>[
                        ImageView(avatar,
                            radius: 5,
                            borderWidth: 1.0,
                            borderColor: Theme.of(context).accentColor,
                            placeholder: 'images/header.jpeg',
                            height: 50,
                            width: 50),
                        Positioned(
                            child: Visibility(
                                visible: chat.unreadCount > 0,
                                child: Container(
                                    margin:
                                        EdgeInsets.only(right: 10, left: 10),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFED7962),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Text('${chat?.unreadCount}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12)))),
                            top: 0,
                            right: 0)
                      ])),
                  Expanded(
                    child: Column(children: [
                      Row(children: <Widget>[
                        Text(chat.title,
                            style: TextStyle(color: Color(0xFF424752))),
                        Text(
                            chat?.latestMessage == null
                                ? ''
                                : '${formatDateByMs((chat.latestMessage as JMNormalMessage).createTime, formats: [
                                    mm,
                                    "/",
                                    dd,
                                    " ",
                                    hh,
                                    ":",
                                    nn
                                  ])}',
                            style: TextStyle(
                                color: Color(0xFFB9BEC6), fontSize: 14))
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      SizedBox(height: 10),
                      Row(children: <Widget>[
                        Expanded(
                            child: Text(JPushUtil.getLastMessageStr(chat),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xFFB3B9C2)))),
                        Visibility(
                            visible: isNoDisturb,
                            child: Icon(Icons.volume_off, color: Colors.grey))
                      ])
                    ]),
                  )
                ]))));
  }

  Color topBgColor(JMConversationInfo conversationInfo) {
    bool isTop = JPushUtil.isTopChat(conversationInfo);

    return isTop ? topChatBgColor : Colors.white;
  }
}
