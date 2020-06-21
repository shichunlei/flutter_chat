import 'package:flutter_sound_lite/flutter_sound_player.dart';

import '../../commons/index.dart';

import '../../provider/index.dart';

import 'package:flutter/material.dart';

import '../index.dart';
import 'item_message_shake_view.dart';

class MessageSendView extends StatelessWidget {
  final dynamic message;
  final FlutterSoundPlayer player;
  final String time;
  final JMConversationInfo chat;

  const MessageSendView(
      {Key key, @required this.message, this.player, this.time, this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> actions = [];
    if (message is JMTextMessage) {
      actions = ['copy', 'forward', 'recall', 'remove', 'quote', 'select'];
    } else {
      actions = ['forward', 'recall', 'remove', 'quote', 'select'];
    }

    return Column(children: <Widget>[
      /// 时间显示
      Visibility(
          visible: time != null,
          child: Align(
              child: Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text('$time'),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)))))),
      Row(children: <Widget>[
//        Visibility(
//            child: InkWell(
//              onTap: () {
//                /// provider.selectMessage(message);
//              },
//              child: Padding(
//                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                  child: provider.selectMessages.contains(message)
//                      ? Icon(Icons.check_circle, color: checkColor)
//                      : Icon(Icons.panorama_fish_eye)),
//            ),
//            visible: provider.showChecked),
        Spacer(),
        PopupMenu(
            actions: actions,
            onValueChanged: (int value) {
              if (actions[value] == Config.COPY) {
                Utils.copyToClipboard('${message?.text}');
              } else if (actions[value] == Config.RECALL) {
                showRecallMessageDialog(context, callBack: (confirm) {
                  if (confirm) {
                    /// todo 撤回消息，这儿有个时间限制，大于两分钟的消息不能撤回，暂时没有做判断
                    Provider.of<ChatProvider>(context, listen: false)
                        .retractMessage(message);
                  }
                  Navigator.maybePop(context);
                });
              } else if (actions[value] == Config.REMOVE) {
                showDeleteMessageDialog(context, callBack: (confirm) {
                  if (confirm) {
                    Provider.of<ChatProvider>(context, listen: false)
                        .deleteMessageById(message);
                  }
                  Navigator.maybePop(context);
                });
              } else if (actions[value] == Config.FORWARD) {
                /// TODO
              } else if (actions[value] == Config.QUOTE) {
                /// TODO
              } else if (actions[value] == Config.SELECT) {
                /// TODO
                /// provider.toggleSelectMessage(true);
              }
            },
            child: Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildMessageView(context),
                      SizedBox(width: 10),
                      Consumer2<UserProvider, ChatProvider>(builder:
                          (BuildContext context, UserProvider userProvider,
                              ChatProvider chatProvider, Widget child) {
                        return ShakeView(
                          child: ImageView(
                              '${userProvider.userInfo.extras["avatarUrl"]}',
                              radius: 5,
                              height: 35,
                              width: 35,
                              placeholder: 'images/header.jpeg'),
                          doubleTapCallback: (bool value) {
                            if (value) {
                              print("拍了拍自己");
//                              chatProvider.sendShakeMessage(
//                                  chat, userProvider.userInfo);
                            }
                          },
                        );
                      }),
                    ])))
      ])
    ]);
  }

  Widget buildMessageView(BuildContext context) {
    if (message is JMTextMessage) {
      return TextMessageView(message: message.text, type: MessageSendType.send);
    } else if (message is JMImageMessage) {
      // 图片消息
      return ImageMessageView(message: message, type: MessageSendType.send);
    } else if (message is JMVoiceMessage) {
      // 语音消息
      return VoicePlayerView(
          message: message, type: MessageSendType.send, player: player);
    } else if (message is JMLocationMessage) {
      // 地址消息
      return MapMessageView(message: message, type: MessageSendType.send);
    } else if (message is JMFileMessage) {
      // 文件消息
      return FileMessageView(message: message, type: MessageSendType.send);
    } else if (message is JMCustomMessage) {
      // 自定义消息
      JMCustomMessage _message = message;

      print('JMCustomMessage => ${_message.customObject["type"]}');

      if (_message.customObject["type"] == "namecard") {
        // 发送名片
        return NameCardMessageView(
            message: message, type: MessageSendType.send);
      } else if (_message.customObject["type"] == "groupInvitation") {
        // 发送群邀请
        return GroupInvitationView(
            message: message, type: MessageSendType.send);
      } else if (_message.customObject["type"] == "shake") {
        // 发送拍了拍消息
        return ShakeMessageView(
          message: message,
          currentUser: Provider.of<UserProvider>(context).userInfo,
        );
      }
      return Container();
    } else {
      return Container();
    }
  }
}
