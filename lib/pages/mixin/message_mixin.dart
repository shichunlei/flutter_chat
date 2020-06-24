import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound_player.dart';

import '../../provider/index.dart';
import '../../utils/jpush_util.dart';

mixin MessageStateMixin<T extends StatefulWidget> on State<T> {
  FlutterSoundPlayer player;

  JMUserInfo currentUserInfo;

  JMGroupInfo groupInfo;

  JMUserInfo toUserInfo;

  String toUserAvatarPath = '';

  @override
  void initState() {
    super.initState();

    initPlayer();

    Future.delayed(Duration.zero, () {
      currentUserInfo =
          Provider.of<UserProvider>(context, listen: false).userInfo;
    });
  }

  void init(JMConversationInfo chat) async {
    if (chat.conversationType == JMConversationType.single) {
      toUserInfo = chat.target;

      /// 接收消息监听
      jMessage.addReceiveMessageListener(receiveMessageListener);

      /// 撤回消息监听
      jMessage.addMessageRetractListener(messageRetractListener);

      toUserAvatarPath = toUserInfo.extras["avatarUrl"];

      // (Android only) 进入聊天会话。当调用后，该聊天会话的消息将不再显示通知。
      // iOS 默认应用在前台时，就不会显示通知。
      await jMessage.enterConversation(target: toUserInfo.targetType);
    } else if (chat.conversationType == JMConversationType.group) {
      groupInfo = chat.target;

      /// 接收消息监听
      jMessage.addReceiveMessageListener(receiveMessageListener);

      /// 撤回消息监听
      jMessage.addMessageRetractListener(messageRetractListener);

      // (Android only) 进入聊天会话。当调用后，该聊天会话的消息将不再显示通知。
      // iOS 默认应用在前台时，就不会显示通知。
      await jMessage.enterConversation(target: groupInfo.targetType);
    }
  }

  @override
  void dispose() {
    player?.release();
    jMessage.removeReceiveMessageListener(receiveMessageListener);
    jMessage.removeMessageRetractListener(messageRetractListener);
    super.dispose();
  }

  void initPlayer() async {
    player = await FlutterSoundPlayer().initialize();
    await player.setSubscriptionDuration(0.01);
  }

  /// 当前会话接收消息监听处理
  ///
  void receiveMessageListener(message) {
    print(
        'MessagePage    接收到新消息事件监听 => ${message.toJson()}\n=================> ${(message.from as JMUserInfo).username}');

    if ((message as JMNormalMessage).target is JMUserInfo) {
      // 单聊
      print('----------------------> ${toUserInfo.username}');

      if ((message.from as JMUserInfo).username == toUserInfo.username) {
        // 只有当接收的消息是当前会话（与toUserInfo的单聊）时才将消息插入到会话中
        Future.delayed(Duration.zero, () {
          Provider.of<ChatProvider>(context, listen: false)
              .addMessageToListView(message);
        });
      }
    } else if ((message as JMNormalMessage).target is JMGroupInfo) {
      // 群聊
      print('----------------------> ${groupInfo.id}');

      if ((message as JMGroupInfo).targetType.groupId == groupInfo.id) {
        // 只有当接收的消息是当前会话（该群聊）时才将消息插入到会话中
        Future.delayed(Duration.zero, () {
          Provider.of<ChatProvider>(context, listen: false)
              .addMessageToListView(message);
        });
      }
    }
  }

  /// 当前会话撤回消息监听处理
  ///
  void messageRetractListener(retractedMessage) {
    print(
        'MessagePage    接收到新消息事件监听 => ${retractedMessage.toJson()}\n=================> ${(retractedMessage.from as JMUserInfo).username}');

    /// 消息撤回处理
    String messageId = (retractedMessage as JMNormalMessage).id;

    if ((retractedMessage as JMNormalMessage).target is JMUserInfo) {
      // 单聊
      print('----------------------> ${toUserInfo.username}');
      if ((retractedMessage.from as JMUserInfo).username ==
          toUserInfo.username) {
        Future.delayed(Duration.zero, () {
          Provider.of<ChatProvider>(context, listen: false)
              .retractedMessage(messageId);
        });
      }
    } else if ((retractedMessage as JMNormalMessage).target is JMGroupInfo) {
      // 群聊
      print('----------------------> ${groupInfo.id}');

      if ((retractedMessage.target as JMGroupInfo).id == groupInfo.id) {
        Future.delayed(Duration.zero, () {
          Provider.of<ChatProvider>(context, listen: false)
              .retractedMessage(messageId);
        });
      }
    }
  }
}
