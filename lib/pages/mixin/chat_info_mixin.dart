import 'package:flutter/material.dart';

import '../../commons/index.dart';
import '../../provider/index.dart';
import '../../utils/jpush_util.dart';

mixin ChatInfoStateMixin<T extends StatefulWidget> on State<T> {
  bool isTop = false; // 是否置顶
  bool isNoDisturb = false; // 是否免打扰

  /// 单聊对方对象
  JMUserInfo userInfo;

  /// 群聊对象
  JMGroupInfo groupInfo;

  /// 当前用户对象
  JMUserInfo currentUserInfo;

  /// 群管理
  bool isAdmin = false;

  /// 群主
  bool isOwner = false;

  String groupNickname = '';

  /// 群聊用户列表
  List<JMGroupMemberInfo> list = [];

  Future<void> init(JMConversationInfo chat) async {
    if (chat.conversationType == JMConversationType.single) {
      userInfo = chat.target;
      isNoDisturb = userInfo.isNoDisturb;
    } else if (chat.conversationType == JMConversationType.group) {
      groupInfo = chat.target;

      print('groupInfo => ${groupInfo.toJson()}');

      isNoDisturb = groupInfo.isNoDisturb;
      Future.delayed(Duration.zero, () {
        getGroupUsers();
      });
    }

    isTop = JPushUtil.isTopChat(chat);
  }

  /// 获取群成员
  void getGroupUsers() async {
    List<JMGroupMemberInfo> _list =
        await jMessage.getGroupMembers(id: groupInfo.id);

    list.clear();
    list.addAll(_list);

    list.forEach((element) {
      print("群成员=======>${element.toJson()}");
    });

    currentUserInfo =
        Provider.of<UserProvider>(context, listen: false).userInfo;

    JMGroupMemberInfo groupMemberInfo = list.firstWhere(
        (element) => currentUserInfo.username == element.user.username);

    groupNickname = groupMemberInfo.groupNickname;

    if (groupNickname.isEmpty) {
      groupNickname = JPushUtil.getName(currentUserInfo);
    }

    isOwner = groupMemberInfo.memberType == JMGroupMemberType.owner;

    isAdmin = groupMemberInfo.memberType == JMGroupMemberType.admin;

    print('groupNickname================>$groupNickname');
    print('isOwner================>$isOwner');
    print('isAdmin================>$isAdmin');

    setState(() {});
  }

  /// 修改群名称
  ///
  /// [name] 要修改的名称
  ///
  void updateGroupName(name) async {
    showLoadingDialog(context);

    groupInfo.updateGroupInfo(newName: name).then((value) {
      getGroupInfo();
      Navigator.pop(context);
    }, onError: (error) {
      Navigator.pop(context);
      print('updateGroupName error => ${error.toString()}');
    });
  }

  /// 修改自己在群里的昵称
  ///
  /// [nickname] 要修改的昵称
  ///
  void setGroupNickname(nickname) async {
    showLoadingDialog(context);

    jMessage
        .setGroupNickname(
            username: currentUserInfo.username,
            groupId: groupInfo.id,
            nickName: nickname)
        .then((value) {
      setState(() {
        groupNickname = nickname;
      });
      Navigator.pop(context);
    }, onError: (error) {
      Navigator.pop(context);
      print('setGroupNickname error => ${error.toString()}');
    });
  }

  /// 得到群聊详情
  void getGroupInfo() async {
    jMessage.getGroupInfo(id: groupInfo.id).then((JMGroupInfo value) {
      print('-----------------------------------------------${value.toJson()}');

      setState(() {
        groupInfo = value;
      });
    }, onError: (error) {
      print('getGroupInfo error => ${error.toString()}');
    });
  }
}
