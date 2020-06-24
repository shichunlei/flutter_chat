import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../commons/index.dart';
import '../model/notify.dart';

import '../model/user.dart';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  LoaderState _state = LoaderState.Loading;

  LoaderState get state => _state;

  List<UserBean> _selectContacts = [];

  List<UserBean> get selectContacts => _selectContacts;

  void toggleContact(UserBean user) {
    if (_selectContacts.contains(user)) {
      _selectContacts.remove(user);
    } else {
      _selectContacts.add(user);
    }

    notifyListeners();
  }

  void clear() {
    _selectContacts = [];
  }

  List<UserBean> _choiceContacts = [];

  List<UserBean> get choiceContacts => _choiceContacts;

  Future initChoiceContacts(List<UserBean> choiceContacts) async {
    clear();
    _choiceContacts.clear();

    if (_friends.length == 0) {
      await getFriends();
    }

    _friends.forEach((element) {
      element.checkedState = 0;
      _choiceContacts.add(element);
    });

    _choiceContacts.forEach((friend) {
      choiceContacts.forEach((choiceContact) {
        if (choiceContact.identifier == friend.identifier)
          friend.checkedState = 2;
      });
    });

    notifyListeners();
  }

  Future checkChoiceContacts(bool checked, int index) async {
    _choiceContacts[index].checkedState = checked ? 1 : 0;

    toggleContact(_choiceContacts[index]);

    notifyListeners();
  }

  List<UserBean> _friends = [];

  List<UserBean> get friends => _friends;

  /// 获取好友列表
  Future<void> getFriends() async {
    await jMessage.getFriends().then((List<JMUserInfo> friends) {
      /// 排序
      // _friends.sort((a, b) => a.username.compareTo(b.username));

      _friends.clear();

      friends.forEach((element) {
        _friends.add(JPushUtil.getUserBean(element));
      });

      /// 排序
      SuspensionUtil.sortListBySuspensionTag(_friends);

      _state = LoaderState.Succeed;

      notifyListeners();
    }, onError: (error) {
      print('getFriends error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  /// 添加用户到好友列表
  ///
  /// [user] 要添加的用户
  ///
  Future addUserToFriends(JMUserInfo user) async {
    if (_friends
            .where((element) => user.username == element.identifier)
            .length ==
        0) {
      _friends.add(JPushUtil.getUserBean(user));

      /// 排序
      SuspensionUtil.sortListBySuspensionTag(_friends);

      notifyListeners();
    }
  }

  /// 从好友列表移除好友
  ///
  /// [user] 要移除的用户
  ///
  Future deleteUserFromFriends(JMUserInfo user) async {
    _friends.removeWhere((element) => user.username == element.identifier);

    /// 排序
    SuspensionUtil.sortListBySuspensionTag(_friends);

    notifyListeners();
  }

  /// 修改好友备注名
  ///
  /// [userInfo] 好友对象
  /// [noteName] 要修改的备注名
  ///
  Future<void> updateFriendNoteName(
      JMUserInfo userInfo, String noteName) async {
    await jMessage
        .updateFriendNoteName(
            username: userInfo.username,
            appKey: Config.JPUSH_APPKEY,
            noteName: noteName)
        .then((value) {}, onError: (error) {
      print('updateFriendNoteName error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  /// 修改好友备注名
  ///
  /// [userInfo] 好友对象
  /// [noteText] 要修改的备信息
  ///
  Future<void> updateFriendNoteText(
      JMUserInfo userInfo, String noteText) async {
    await jMessage
        .updateFriendNoteText(
            username: userInfo.username,
            appKey: Config.JPUSH_APPKEY,
            noteText: noteText)
        .then((value) => null, onError: (error) {
      print('declineInvitation error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  /// 接受好友申请
  ///
  /// [username] 好友用户名（唯一的标志）
  /// [identifier] 当前用户用户名（唯一的标志）
  ///
  Future<void> acceptInvitation(String username, [String identifier]) async {
    await jMessage
        .acceptInvitation(username: username, appKey: Config.JPUSH_APPKEY)
        .then((value) {
      getFriends();
      postNotify(username, identifier, "", "invite_accepted");
    }, onError: (error) {
      print('acceptInvitation error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  /// 拒绝好友申请
  ///
  /// [username] 好友用户名（唯一的标志）
  /// [reason] 拒绝理由
  /// [identifier] 当前用户用户名（唯一的标志）
  ///
  Future<void> declineInvitation(String username,
      [String reason, String identifier]) async {
    await jMessage
        .declineInvitation(
            username: username, appKey: Config.JPUSH_APPKEY, reason: reason)
        .then(
            (value) =>
                postNotify(username, identifier, reason, "invite_declined"),
            onError: (error) {
      print('declineInvitation error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  /// 添加好友消息
  ///
  /// [from_user] 推送消息者
  /// [identifier] 接收消息者
  /// [reason] 原因
  /// [type] 类型
  ///
  Future postNotify(
      String fromUserIdentifier, String identifier, String reason, String type,
      [bool isReceive = true]) async {
    await HttpUtils().post(APIs.ADD_NOTIFY,
        (value) => getNotify(isReceive ? identifier : fromUserIdentifier),
        params: FormData.fromMap({
          "from_user": fromUserIdentifier,
          "identifier": identifier,
          "reason": reason,
          "status": type
        }));
  }

  List<Notify> _notifications = [];

  List<Notify> get notifications => _notifications;

  Future getNotify(String identifier) async {
    await HttpUtils().get(APIs.NOTIFICATIONS, (value) {
      _notifications.clear();

      _notifications
          .addAll((value as List ?? []).map((o) => Notify.fromMap(o)));

      notifyListeners();
    }, params: {"identifier": identifier});
  }
}
