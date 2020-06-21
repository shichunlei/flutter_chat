import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../pages/chats/single/message.dart';

import '../../commons/index.dart';

import '../../generated/i18n.dart';
import '../../provider/index.dart';

import 'package:flutter/material.dart';

import '../photo_view.dart';

class FriendInfoPage extends StatefulWidget {
  final String identifier;

  const FriendInfoPage({Key key, @required this.identifier}) : super(key: key);

  @override
  createState() => _FriendInfoPageState();
}

class _FriendInfoPageState extends State<FriendInfoPage> {
  JMUserInfo friendInfo;

  String avatarPath = '';

  bool isMyself = false;

  bool isFriend = true;
  bool isInBlackList = false;
  bool isStar = false;

  @override
  void initState() {
    super.initState();

    String currentIdentifier = SpUtil.getString(Config.CURRENT_USERNAME);

    setState(() {
      isMyself = currentIdentifier == widget.identifier;
    });

    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            actions: isMyself
                ? []
                : <Widget>[
                    IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () => showCupertinoModalDialog(context,
                                isFriend: isFriend,
                                blacklist: isInBlackList,
                                star: isStar, callBack: (String type) {
                              Navigator.pop(context);

                              switch (type) {
                                case 'star':
                                  print('===========>star');
                                  setState(() {
                                    isStar = !isStar;
                                  });
                                  break;
                                case 'delete':
                                  print('===========>delete');
                                  deleteFriend(friendInfo.username);
                                  break;
                                case 'blacklist':
                                  print('===========>blacklist');
                                  funBlacklist();
                                  break;
                                case 'remarks':
                                  print('===========>remarks');
                                  pushNewPage(
                                      context,
                                      InputTextPage(
                                        title: S.of(context).edit_remarks,
                                        hintText: S.of(context).remark,
                                        content: friendInfo?.noteName ?? '',
                                        maxLines: 1,
                                      ), callBack: (value) {
                                    if (Utils.isNotEmpty(value)) {
                                      showLoadingDialog(context);
                                      updateNoteName(value);
                                    }
                                  });
                                  break;
                                case 'recommend':
                                  print('===========>recommend');
                                  break;
                                case 'authority':
                                  print('===========>authority');
                                  break;
                                case 'complaint':
                                  print('===========>complaint');
                                  break;
                                default:
                                  break;
                              }
                            }))
                  ]),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  GestureDetector(
                      child: Hero(
                          tag: "header",
                          child: ImageView(avatarPath,
                              height: 60,
                              width: 60,
                              radius: 10.0,
                              margin: EdgeInsets.only(right: 10),
                              placeholder: 'images/header.jpeg')),
                      onTap: () => pushNewPage(
                          context,
                          PhotoViewPage(
                              photos: <String>[avatarPath],
                              heroTag: "header"))),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: <Widget>[
                          /// 昵称
                          Text(JPushUtil.getName(friendInfo),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),

                          /// 性别
                          Icon(
                              friendInfo?.gender == JMGender.female
                                  ? IconFont.women
                                  : friendInfo?.gender == JMGender.male
                                      ? IconFont.man
                                      : Icons.help,
                              size: 15,
                              color: friendInfo?.gender == JMGender.female
                                  ? Color(0xFFEC6A52)
                                  : Colors.blue),
                          Spacer(),
                          Visibility(
                              visible: !isMyself,
                              child: IconButton(
                                  icon: Icon(
                                      isStar ? Icons.star : Icons.star_border,
                                      color:
                                          isStar ? Colors.yellow : Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      isStar = !isStar;
                                    });
                                  }))
                        ]),
                        SizedBox(height: 5),

                        /// ID
                        Text(S.of(context).id(friendInfo?.username ?? "")),
                        SizedBox(height: 5),

                        /// 地区
                        Text(S.of(context).Region(friendInfo?.region ?? ""))
                      ]))
                ])),

            SizedBox(height: .5),

            SelectedText(
                onTap: () {},
                title: S.of(context).phone,
                content: friendInfo?.username ?? ''),
            SizedBox(height: 5),

            Material(
                color: Colors.white,
                child: InkWell(
                    onTap: () {},
                    child: Container(
                        height: 60.0,
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8),
                        child: Row(children: <Widget>[
                          SizedBox(
                              width: 80,
                              child: Text(S.of(context).moments,
                                  style:
                                      Theme.of(context).textTheme.subtitle1)),
                          Expanded(
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    return ImageView(
                                        'http://up.enterdesk.com/edpic/31/c3/fd/31c3fdc63511cabedd6415d121fa2d58.jpg',
                                        width: 44,
                                        height: 44);
                                  },
                                  itemCount: 4,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(width: 5))),
                          Icon(Icons.chevron_right, size: 22.0)
                        ])))),

            SizedBox(height: 5),
            SelectedText(
                onTap: isFriend
                    ? () => pushNewPage(
                            context,
                            InputTextPage(
                                title: S.of(context).edit_remarks,
                                hintText: S.of(context).remark,
                                content: friendInfo?.noteName ?? '',
                                maxLines: 1), callBack: (value) {
                          if (Utils.isNotEmpty(value)) {
                            showLoadingDialog(context);
                            updateNoteName(value);
                          }
                        })
                    : null,
                title: S.of(context).set_notes_and_tags,
                content: friendInfo?.noteName ?? ''),
            SizedBox(height: .5),
            SelectedText(
                title: S.of(context).whats_up,
                content: friendInfo?.signature ?? ''),

            /// 发送消息按钮
            Visibility(
                visible: isFriend,
                child: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                        color: Colors.white,
                        onPressed: () =>
                            Provider.of<ChatProvider>(context, listen: false)
                                .jumpToConversationMessage(
                                    context, friendInfo.targetType),
                        child: Text(S.of(context).send_message)))),

            /// 音视频通话
            Visibility(
                visible: isFriend,
                child: Container(
                    margin: EdgeInsets.only(top: .5),
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                        color: Colors.white,
                        onPressed: () {},
                        child: Text("音视频通话")))),

            /// 添加好友按钮
            Visibility(
                visible: !isFriend && !isMyself,
                child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(top: 5),
                    child: FlatButton(
                        color: Colors.white,
                        onPressed: () async {
                          showLoadingDialog(context);

                          await jMessage
                              .sendInvitationRequest(
                                  username: friendInfo.username,
                                  appKey: Config.JPUSH_APPKEY,
                                  reason: '请求添加好友')
                              .then((value) {
                            Toast.show(context, '请求已发送');
                            Navigator.of(context).pop();
                          }, onError: (error) {
                            Toast.show(context, '请求发送失败');
                            Navigator.of(context).pop();
                            if (error is PlatformException)
                              print(
                                  'sendInvitationRequest error => ${error.toString()}');
                          });
                        },
                        child: Text(S.of(context).add_friend2)))),
          ]),
        ));
  }

  /// 获取朋友详情
  ///
  void getUserInfo() async {
    await jMessage.getUserInfo(username: widget.identifier).then((value) async {
      friendInfo = value;

      print("getUserInfo => ${friendInfo.toJson()}");

      avatarPath = friendInfo.extras["avatarUrl"] ?? "";

      isFriend = friendInfo.isFriend;
      isInBlackList = friendInfo.isInBlackList;

      setState(() {});
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('getUserInfo error => ${error.toString()}');
      }
    });
  }

  /// 创建一个会话
  ///
  void createChat(BuildContext context) async {
    await jMessage.createConversation(target: friendInfo?.targetType).then(
        (JMConversationInfo value) {
      print("createConversation => ${value.toJson()}");

      Provider.of<ChatProvider>(context, listen: false).getChats().then((_) {
        pushNewPage(context, SingleMessagePage(chat: value));
      });
    }, onError: (error) {
      print('createConversation error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  /// 修改备注名
  ///
  void updateNoteName(String noteName) async {
    await jMessage
        .updateFriendNoteName(username: friendInfo.username, noteName: noteName)
        .then((value) {
      getUserInfo();
      Navigator.of(context).pop();
    }, onError: (error) {
      Navigator.of(context).pop();

      print('updateFriendNoteName error => ${error.toString()}');

      if (error is PlatformException) {
        if (error.code == '805003') {
          print('不是好友关系，不能修改备注名');
          Toast.show(context, '不是好友关系，不能修改备注名');
        }
      }
    });
  }

  /// 修改备注信息
  ///
  void updateNoteText(String noteText) async {
    await jMessage
        .updateFriendNoteText(username: friendInfo.username, noteText: noteText)
        .then((value) {
      getUserInfo();
      Navigator.of(context).pop();
    }, onError: (error) {
      Navigator.of(context).pop();
      print('updateFriendNoteName error => ${error.toString()}');

      if (error is PlatformException) {
        if (error.code == '805003') print('不是好友关系，不能修改备信息');
      }
    });
  }

  void funBlacklist() async {
    showLoadingDialog(context);

    isInBlackList
        ? await jMessage.removeUsersFromBlacklist(
            usernameArray: [friendInfo.username]).then((value) {
            setState(() => isInBlackList = false);
            Toast.show(context, '已经移除黑名单');
            Navigator.of(context).pop();
          }, onError: (error) {
            Toast.show(context, '移除黑名单失败');
            Navigator.of(context).pop();
            if (error is PlatformException)
              print('removeUsersFromBlacklist error => ${error.toString()}');
          })
        : await jMessage.addUsersToBlacklist(
            usernameArray: [friendInfo.username]).then((value) {
            setState(() => isInBlackList = true);
            Toast.show(context, '添加黑名单成功');
            Navigator.of(context).pop();
          }, onError: (error) {
            Toast.show(context, '添加黑名单是失败');
            Navigator.of(context).pop();
            if (error is PlatformException)
              print('addUsersToBlacklist error => ${error.toString()}');
          });
  }

  /// 删除好友关系
  ///
  /// [username] 好友唯一ID
  ///
  void deleteFriend(String username) async {
    showLoadingDialog(context);

    if (isFriend) {
      jMessage.removeFromFriendList(username: username).then((value) {
        setState(() => isFriend = false);
        Toast.show(context, S.of(context).deleteSuccess);
        Navigator.of(context).pop();
      }, onError: (error) {
        Toast.show(context, S.of(context).deleteFailed);
        Navigator.of(context).pop();
        if (error is PlatformException) {
          print('removeFromFriendList error => ${error.toString()}');
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
