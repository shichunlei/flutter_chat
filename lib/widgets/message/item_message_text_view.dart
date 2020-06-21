import '../../commons/res/styles.dart';
import '../../commons/config.dart';
import '../../commons/res/colors.dart';
import '../../utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class TextMessageView extends StatelessWidget {
  final String message;
  final MessageSendType type;

  TextMessageView({Key key, @required this.message, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: Utils.width - 100),
        decoration: BoxDecoration(
            color: type == MessageSendType.send
                ? sendMessageColor
                : Color(0xFFEEF7FD),
            borderRadius: borderRadius(type)),
        padding: EdgeInsets.all(8.0),
        child: Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            style: TextStyle(
                color: type == MessageSendType.send
                    ? Colors.white
                    : Color(0xff666666)),
            text: "$message",
            linkStyle: TextStyle(color: Colors.blue)));
  }
}
