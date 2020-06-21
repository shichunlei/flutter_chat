import 'package:flutter/material.dart';
import '../../commons/index.dart';

class ShakeMessageView extends StatelessWidget {
  final JMCustomMessage message;
  final JMUserInfo currentUser;

  const ShakeMessageView({Key key, this.message, this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    JMUserInfo toUser = JMUserInfo.fromJson(message.extras["toUser"]);

    String text =
        '${message.from.username == currentUser.username ? "你" : JPushUtil.getName(toUser)}拍了拍${message.extras["username"] == currentUser.username ? "自己" : JPushUtil.getName(toUser)}';

    return Container(child: Text(text), alignment: Alignment.center);
  }
}
