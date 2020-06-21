import 'package:flutter/material.dart';
import '../../pages/chats/group/join_group.dart';
import '../../commons/index.dart';

class GroupInvitationView extends StatelessWidget {
  final JMCustomMessage message;
  final MessageSendType type;

  const GroupInvitationView({Key key, @required this.message, this.type})
      : super(key: key);

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
                      constraints: BoxConstraints(maxWidth: Utils.width * .75),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                          children: [
                            Text('邀请你加入群聊', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 5),
                            Row(children: <Widget>[
                              Expanded(
                                  child: Text('XXX邀请你加入群聊YYY YYYY，进入可以查看详情。',
                                      style: TextStyle(color: Colors.grey))),
                              SizedBox(width: 10),
                              ImageView(groupHeaderImage,
                                  radius: 5, width: 50, height: 50)
                            ]),
                          ],
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start),
                    )),
                onTap: () {
                  /// TODO 跳转到入群确认页面
                  pushNewPage(
                      context,
                      JoinGroupPage(
                          groupId: "43749887", fromUser: message.from));
                })));
  }
}
