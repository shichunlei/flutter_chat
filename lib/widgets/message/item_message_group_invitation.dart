import 'package:flutter/material.dart';

import '../../provider/index.dart';
import '../../pages/chats/group/join_group.dart';
import '../../commons/index.dart';

class GroupInvitationView extends StatelessWidget {
  final JMCustomMessage message;
  final MessageSendType type;
  final JMUserInfo toUser;

  const GroupInvitationView({
    Key key,
    @required this.message,
    this.type,
    this.toUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Ink(
            decoration: BoxDecoration(
                color: type == MessageSendType.send
                    ? sendMessageColor
                    : Color(0xFFEEF7FD),
                borderRadius: borderRadius(type)),
            child: InkWell(
                borderRadius: borderRadius(type),
                child: ClipRRect(
                    borderRadius: borderRadius(type),
                    child: Container(
                        constraints:
                            BoxConstraints(maxWidth: Utils.width * .75),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                            children: [
                              Text(
                                  type == MessageSendType.send
                                      ? "你邀请${JPushUtil.getName(toUser)}加入群聊"
                                      : '邀请你加入群聊',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: type == MessageSendType.send
                                          ? Colors.white
                                          : Colors.black54)),
                              SizedBox(height: 5),
                              Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                        type == MessageSendType.send
                                            ? '你邀请${JPushUtil.getName(toUser)}加入群聊“${message.customObject["groupName"]}”，进入可以查看详情。'
                                            : '${JPushUtil.getName(toUser)}邀请你加入群聊“${message.customObject["groupName"]}”，进入可以查看详情。',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: type == MessageSendType.send
                                                ? Colors.white
                                                : Colors.grey))),
                                SizedBox(width: 10),
                                ImageView(groupHeaderImage,
                                    radius: 5,
                                    width: 50,
                                    height: 50,
                                    placeholder: 'images/header.jpeg')
                              ]),
                            ],
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start))),
                onTap: type == MessageSendType.send
                    ? () {
                        /// 跳转到群聊会话中
                        Provider.of<ChatProvider>(context, listen: false)
                            .jumpToConversationMessage(
                                context,
                                JMGroup.fromJson({
                                  "groupId": message.customObject["groupId"]
                                }));
                      }
                    : () {
                        /// 跳转到入群确认页面
                        pushNewPage(
                            context,
                            JoinGroupPage(
                                groupId: message.customObject["groupId"],
                                fromUser: message.from));
                      })));
  }
}
