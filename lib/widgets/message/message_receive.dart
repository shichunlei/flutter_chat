import 'package:flutter_chat/pages/contacts/friend.dart';

import '../../commons/index.dart';
import '../../provider/index.dart';

import 'package:flutter_sound_lite/flutter_sound_player.dart';

import 'package:flutter/material.dart';

import '../index.dart';
import 'item_message_shake_view.dart';

class MessageReceiveView extends StatefulWidget {
  final dynamic message;
  final String time;
  final FlutterSoundPlayer player;
  final JMConversationInfo chat;

  MessageReceiveView(
      {Key key,
      @required this.message,
      this.time,
      @required this.player,
      this.chat})
      : super(key: key);

  @override
  createState() => _MessageReceiveViewState();
}

class _MessageReceiveViewState extends State<MessageReceiveView>
    with AutomaticKeepAliveClientMixin {
  String avatar;

  JMUserInfo userInfo;

  List<String> actions = [];

  @override
  void initState() {
    super.initState();

    userInfo = widget.message.from as JMUserInfo;

    if (widget.message is JMTextMessage) {
      actions = ['copy', 'forward', 'remove', 'quote', 'select'];
    } else {
      actions = ['forward', 'remove', 'quote', 'select'];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(children: <Widget>[
      /// 时间显示
      Visibility(
          visible: widget.time != null,
          child: Align(
              child: Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: Text('${widget.time}'),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)))))),
//      message.isRecall
//          ? Align(
//          child: Container(
//              padding: EdgeInsets.symmetric(vertical: 3),
//              child: Text(S.of(context).withdrew_message(message.user.name),
//                  style: TextStyle(color: Colors.grey[600])) //
//          )):
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Visibility(
//                child: InkWell(
//                  onTap: () {
//                    /// provider.selectMessage(message);
//                  },
//                  child: Padding(
//                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                      child: provider.selectMessages.contains(widget.message)
//                          ? Icon(Icons.check_circle, color: checkColor)
//                          : Icon(Icons.panorama_fish_eye)),
//                ),
//                visible: provider.showChecked),
            PopupMenu(
                actions: actions,
                onValueChanged: (int value) {
                  if (actions[value] == Config.COPY) {
                    Utils.copyToClipboard('${widget.message?.text}');
                  } else if (actions[value] == Config.REMOVE) {
                    showDeleteMessageDialog(context, callBack: (confirm) {
                      if (confirm) {
                        print('messageId======> ${widget.message.id}');
                        // todo 删除消息,好像是不能删除对方发送的消息，这儿不知是不是插件的问题
                        Provider.of<ChatProvider>(context, listen: false)
                            .deleteMessageById(widget.message);
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
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ShakeView(
                              child: ImageView(userInfo.extras["avatarUrl"],
                                  radius: 5,
                                  height: 35,
                                  width: 35,
                                  placeholder: 'images/header.jpeg'),
                              onTap: () => pushNewPage(
                                  context,
                                  FriendInfoPage(
                                      identifier: userInfo.username)),
                              doubleTapCallback: (bool value) {
                                if (value) {
                                  print("双击回调");
//                                  Provider.of<ChatProvider>(context,
//                                          listen: false)
//                                      .sendShakeMessage(widget.chat, userInfo);
                                }
                              }),
                          SizedBox(width: 10),
                          buildMessageView(context, widget.message)
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start)))
          ])
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildMessageView(BuildContext context, message) {
    if (message is JMTextMessage) {
      // 文本消息
      return TextMessageView(
          message: message.text, type: MessageSendType.receive);
    } else if (message is JMImageMessage) {
      // 图片消息
      return ImageMessageView(message: message, type: MessageSendType.receive);
    } else if (message is JMVoiceMessage) {
      // 语音消息
      return VoicePlayerView(
          type: MessageSendType.receive,
          message: message,
          player: widget.player);
    } else if (message is JMLocationMessage) {
      // 地址消息
      return MapMessageView(message: message, type: MessageSendType.receive);
    } else if (message is JMFileMessage) {
      // 文件消息
      return FileMessageView(message: message, type: MessageSendType.receive);
    } else if (message is JMCustomMessage) {
      // 自定义消息
      JMCustomMessage _message = message;

      print('JMCustomMessage => ${_message.customObject["type"]}');

      if (_message.customObject["type"] == "namecard") {
        // 发送名片
        return NameCardMessageView(
            message: message, type: MessageSendType.receive);
      } else if (_message.customObject["type"] == "groupInvitation") {
        // 发送群邀请
        return GroupInvitationView(
            message: message, type: MessageSendType.receive);
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
