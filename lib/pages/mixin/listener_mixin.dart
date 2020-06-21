import 'package:flutter/material.dart';

import '../../commons/index.dart';
import '../../provider/index.dart';

mixin ListenerStateMixin<T extends StatefulWidget> on State<T> {
  JMUserInfo currentUserInfo;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      currentUserInfo =
          Provider.of<UserProvider>(context, listen: false).userInfo;
    });

    addListener();
  }

  void addListener() async {
    print('HomePage 消息事件监听');

    await jMessage.addReceiveMessageListener(receiveMessageListener);

    await jMessage.addContactNotifyListener(contactNotifyListener);

    await jMessage.addLoginStateChangedListener(loginStateChangedListener);

    await jMessage.addMessageRetractListener(messageRetractListener);

    await jMessage
        .addReceiveGroupAdminRejectListener(receiveGroupAdminRejectListener);

    await jMessage.addReceiveGroupAdminApprovalListener(
        receiveGroupAdminApprovalListener);

    await jMessage.addReceiveApplyJoinGroupApprovalListener(
        receiveApplyJoinGroupApprovalListener);
  }

  /// 接收到新消息事件监听
  void receiveMessageListener(message) async {
    print('HomePage    接收到新消息事件监听 => ${message.toJson()}');

    Future.delayed(Duration.zero, () {
      /// 监听到消息后重新加载会话列表来刷新会话列表
      Provider.of<ChatProvider>(context, listen: false).getChats();
    });
  }

  /// 消息撤回事件监听
  void messageRetractListener(message) async {
    print('HomePage    消息撤回事件监听 => ${message.toString()}');

    if (null != message) {
      Future.delayed(Duration.zero, () {
        /// 监听到消息后重新加载会话列表来刷新会话列表
        Provider.of<ChatProvider>(context, listen: false).getChats();
      });
    }
  }

  /// 好友相关通知事件
  void contactNotifyListener(JMContactNotifyEvent event) async {
    print('HomePage    好友相关通知事件 => ${event.toJson()}');

    JMUserInfo userInfo =
        await jMessage.getUserInfo(username: event.fromUserName);

    switch (event.type) {
      case JMContactNotifyType.invite_received:
        // 申请添加好友
        print('${userInfo.nickname}申请添加你为好友');
        break;
      case JMContactNotifyType.invite_accepted:
        // 申请已接受
        print('${userInfo.nickname}已经接受你的好友申请，现在可以尽情聊天了');
        Future.delayed(Duration.zero, () {
          /// 监听到好友接受申请，将对方添加到好友列表内
          Provider.of<ContactProvider>(context, listen: false)
              .addUserToFriends(userInfo);
        });
        break;
      case JMContactNotifyType.invite_declined:
        // 申请被拒绝
        print('${userInfo.nickname}决绝了你的好友申请');
        break;
      case JMContactNotifyType.contact_deleted:
        // 删除好友
        print('${userInfo.nickname}解除了你们的好友关系');

        break;
      default:
        break;
    }

    Provider.of<ContactProvider>(context, listen: false).postNotify(
        userInfo.username,
        currentUserInfo.username,
        event.reason,
        "${event.type}".split(".")[1]);
  }

  /// 登录状态变更事件，例如在其他设备登录把当前设备挤出，会触发这个事件。
  void loginStateChangedListener(JMLoginStateChangedType type) async {
    print('登录状态变更事件 => $type');

    switch (type) {
      case JMLoginStateChangedType.user_logout: // 被踢、被迫退出

        Future.delayed(Duration.zero, () {
          showLogoutDialog(context);
        });

        break;
      case JMLoginStateChangedType.user_deleted: // 用户被删除
        break;
      case JMLoginStateChangedType.user_password_change: // 非客户端修改密码
        break;
      case JMLoginStateChangedType.user_login_status_unexpected: // 用户登录状态异常
        break;
      case JMLoginStateChangedType.user_disabled: // 用户被禁用
        break;
      default:
        break;
    }
  }

  /// 监听接收入群申请事件
  void receiveApplyJoinGroupApprovalListener(
      JMReceiveApplyJoinGroupApprovalEvent event) async {
    // 群ID
    String groupId = event.groupId;
    // 发送申请的用户
    JMUserInfo sendApplyUser = event.sendApplyUser;
    // 原因
    String reason = event.reason;

    print(
        '监听接收入群申请事件==============>${event.toString()}\n$groupId\n${sendApplyUser.toJson()}\n$reason');
  }

  /// 监听管理员拒绝入群申请事件
  void receiveGroupAdminRejectListener(
      JMReceiveGroupAdminRejectEvent event) async {}

  /// 监听管理员同意入群申请事件
  void receiveGroupAdminApprovalListener(
      JMReceiveGroupAdminApprovalEvent event) async {}

  @override
  void dispose() {
    jMessage.removeReceiveMessageListener(receiveMessageListener);
    jMessage.removeReceiveMessageListener(contactNotifyListener);
    jMessage.removeLoginStateChangedListener(loginStateChangedListener);
    jMessage.removeMessageRetractListener(messageRetractListener);
    jMessage
        .removeReceiveGroupAdminRejectListener(receiveGroupAdminRejectListener);
    jMessage.removeReceiveGroupAdminApprovalListener(
        receiveGroupAdminApprovalListener);
    jMessage.removeReceiveApplyJoinGroupApprovalListener(
        receiveApplyJoinGroupApprovalListener);
    super.dispose();
  }
}
