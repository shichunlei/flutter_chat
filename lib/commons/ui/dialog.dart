import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

import '../../pages/login/input_phone.dart';
import '../../commons/index.dart';

import '../../generated/i18n.dart';
import '../../provider/index.dart';

import '../../model/user.dart';

import '../../widgets/name_cardview.dart';

/// 撤回消息底部弹窗
///
void showRecallMessageDialog(BuildContext context,
    {Function(bool confirm) callBack}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
            borderRadius: modalBottomSheet(),
            child: Container(
                padding: EdgeInsets.only(bottom: Utils.bottomSafeHeight),
                height: 167.0 + Utils.bottomSafeHeight,
                decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
                child: Column(children: [
                  Container(
                      color: Colors.white,
                      child: Text('Do you want to recall this message?'),
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center),
                  SizedBox(height: 2),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).confirm,
                                  style: TextStyle(color: Color(0xFF4FA16D))),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(true))),
                  SizedBox(height: 15),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).cancel),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(false)))
                ])));
      },
      shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
}

/// 删除消息底部弹窗
///
void showDeleteMessageDialog(BuildContext context,
    {Function(bool confirm) callBack}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
            borderRadius: modalBottomSheet(),
            child: Container(
                padding: EdgeInsets.only(bottom: Utils.bottomSafeHeight),
                height: 167.0 + Utils.bottomSafeHeight,
                decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
                child: Column(children: [
                  Container(
                      color: Colors.white,
                      child: Text('Delete this message or not?'),
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center),
                  SizedBox(height: 2),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).confirm,
                                  style: TextStyle(color: Color(0xFF4FA16D))),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(true))),
                  SizedBox(height: 15),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).cancel),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(false)))
                ])));
      },
      shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
}

/// 选择地址底部弹窗
///
void showLocationMessageDialog(BuildContext context,
    {Function(bool confirm, String way) callBack}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
            borderRadius: modalBottomSheet(),
            child: Container(
                padding: EdgeInsets.only(bottom: Utils.bottomSafeHeight),
                height: 167.0 + Utils.bottomSafeHeight,
                decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
                child: Column(children: [
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).send_location,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(true, 'send'))),
                  SizedBox(height: 2),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).share_location,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(true, 'share'))),
                  SizedBox(height: 15),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).cancel),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () => callBack(false, 'cancel')))
                ])));
      },
      shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
}

/// 名片
///
/// [context] 上下文
/// [cardUser] 要发送的名片用户
/// [chat] 会话
/// [snapshot] 状态管理provider
///
void showNameCardDialog(BuildContext context,
    [UserBean cardUser, JMConversationInfo chat, ChatProvider snapshot]) {
  showDialog(
      context: context,
      builder: (_) {
        return NameCardDialog(
            name: chat.target is JMUserInfo
                ? JPushUtil.getName((chat.target is JMUserInfo))
                : (chat.target as JMGroupInfo).name,
            avatar: chat.target is JMUserInfo
                ? (chat.target as JMUserInfo).extras["avatarUrl"]
                : groupHeaderImage,
            cardUser: cardUser,
            callBack: (String message) {
              /// 发送名片消息
              snapshot.sendNameCardMessage(chat, cardUser);

              /// 发送文本消息
              if (Utils.isNotEmpty(message))
                snapshot.sendTextMessage(chat, message);
            });
      });
}

/// 加载对话款
///
void showLoadingDialog(BuildContext context, {String text}) {
  showDialog<Null>(
      context: context, //BuildContext对象
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(text: text ?? S.of(context).loading);
      });
}

class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
                height: 140.0,
                width: 140.0,
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.greenAccent)),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(text,
                              style:
                                  TextStyle(decoration: TextDecoration.none)))
                    ]))));
  }
}

/// 修改头像底部弹框
///
/// [context] 上下文
/// [callBack] 资源回调
///
void showUpdateAvatarDialog(
    BuildContext context, Function(ImageSource source) callBack) async {
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) => Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(S.of(context).camera),
                  onTap: () {
                    callBack(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: Icon(Icons.photo),
                  title: Text(S.of(context).gallery),
                  onTap: () {
                    callBack(ImageSource.gallery);
                    Navigator.pop(context);
                  })
            ]),
            padding: EdgeInsets.only(bottom: Utils.bottomSafeHeight),
          ));
}

/// 修改性别底部弹框
///
/// [context] 上下文
/// [callBack] 回调
///
void showUpdateGenderDialog(BuildContext context,
    {Function(JMGender gender) callBack}) {
  var snapshot = Provider.of<UserProvider>(context, listen: false);

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
            borderRadius: modalBottomSheet(),
            child: Container(
                padding: EdgeInsets.only(bottom: Utils.bottomSafeHeight),
                height: 202.0 + Utils.bottomSafeHeight,
                decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
                child: Column(children: [
                  Container(
                      color: Colors.white,
                      child: Text('update gender'),
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center),
                  SizedBox(height: 2),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).female,
                                  style: TextStyle(
                                      color: snapshot.userInfo.gender ==
                                              JMGender.female
                                          ? Color(0xFF4FA16D)
                                          : Colors.grey)),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () {
                            callBack(JMGender.female);
                            Navigator.maybePop(context);
                          })),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).male,
                                  style: TextStyle(
                                      color: snapshot.userInfo.gender ==
                                              JMGender.male
                                          ? Color(0xFF4FA16D)
                                          : Colors.grey)),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () {
                            callBack(JMGender.male);
                            Navigator.maybePop(context);
                          })),
                  Material(
                      color: Colors.white,
                      child: InkWell(
                          child: Container(
                              child: Text(S.of(context).unknown,
                                  style: TextStyle(
                                      color: snapshot.userInfo.gender ==
                                              JMGender.unknown
                                          ? Color(0xFF4FA16D)
                                          : Colors.grey)),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center),
                          onTap: () {
                            callBack(JMGender.unknown);
                            Navigator.maybePop(context);
                          }))
                ])));
      },
      shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
}

/// 账号被挤下线对话框
///
/// [context] 上下文
///
void showLogoutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            title: Text('账号异常'),
            actions: <Widget>[
              FlatButton(
                  child: Text(S.of(context).logout),
                  onPressed: () async {
                    SpUtil.clear();

                    await Utils.pop();
                  }),
              FlatButton(
                  child: const Text('重新登录'),
                  onPressed: () async {
                    String username =
                        SpUtil.getString(Config.CURRENT_USERNAME, defValue: "");

                    if (username != "") {
                      await jMessage
                          .login(
                              username: username,
                              password: Config.JMESSAGE_PASSWORD)
                          .then((value) {}, onError: (error) {
                        print(
                            "login==============>error => ${error.toString()}");
                      });

                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                      pushAndRemovePage(context, PhoneLoginFirstPage());
                    }
                  })
            ],
            content: Text('你的账号在其他设备登录，如非本人操作，请修改密码'));
      });
}

/// 退出账号
///
/// [context] 上下文
///
void showLogoutAccountDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            title: Text(S.of(context).exit_tip),
            actions: <Widget>[
              FlatButton(
                  child: Text(S.of(context).logout),
                  onPressed: () async {
                    SpUtil.clear();

                    jMessage.logout();
                    await Utils.pop();
                  }),
              FlatButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () => Navigator.of(context).pop())
            ]);
      });
}

/// 删除会话提示对话框
///
void showDeleteChatDialog(BuildContext context,
    {Function(bool delete) callBack}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(content: Text('删除后，将清空该群聊的消息记录'), actions: <Widget>[
          FlatButton(
              child: Text(S.of(context).cancel),
              onPressed: () => callBack(false)),
          FlatButton(
              child: Text(S.of(context).delete,
                  style: TextStyle(color: Colors.red)),
              onPressed: () => callBack(true))
        ]);
      });
}

/// 好友详情操作弹框
///
/// [context] 上下文
/// [isFriend] 是否好友关系
/// [blacklist] 黑名单状态
/// [star] 星标朋友状态
/// [callBack] 回调
///
void showCupertinoModalDialog(BuildContext context,
    {Function(String type) callBack,
    bool blacklist: false,
    bool star: false,
    bool isFriend: false}) {
  List<Widget> widgets = [];

  if (isFriend) {
    widgets = [
      CupertinoActionSheetAction(
          child: Text(S.of(context).set_notes_and_tags),
          onPressed: () => callBack('remarks')),
      CupertinoActionSheetAction(
          child: Text(S.of(context).share_contact),
          onPressed: () => callBack('recommend')),
      CupertinoActionSheetAction(
          child:
              Text(star ? S.of(context).remove_star : S.of(context).add_star),
          onPressed: () => callBack('star')),
      CupertinoActionSheetAction(
          child: const Text('朋友权限'), onPressed: () => callBack('authority')),
      CupertinoActionSheetAction(
          child: Text(
              blacklist ? S.of(context).remove_block : S.of(context).add_block),
          onPressed: () => callBack('blacklist')),
      CupertinoActionSheetAction(
          child: Text(S.of(context).complaint),
          onPressed: () => callBack('complaint')),
      CupertinoActionSheetAction(
          child: Text(S.of(context).delete),
          onPressed: () => callBack('delete'))
    ];
  } else {
    widgets = [
      CupertinoActionSheetAction(
          child: Text(S.of(context).set_notes_and_tags),
          onPressed: () => callBack('remarks')),
      CupertinoActionSheetAction(
          child: Text(
              blacklist ? S.of(context).remove_block : S.of(context).add_block),
          onPressed: () => callBack('blacklist'))
    ];
  }

  showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => CupertinoActionSheet(
          actions: widgets,
          cancelButton: CupertinoActionSheetAction(
              child: Text(S.of(context).cancel),
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context))));
}

showQRNameCardDialog(BuildContext context, String text, {String title}) {
  showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(title: Text(title ?? 'Title'), children: <Widget>[
          ImageView('images/icon_qr.png',
              imageType: ImageType.assets,
              width: Utils.width * 0.75,
              height: Utils.width * 0.75)
        ]);
      });
}

showChatPopupMenu(BuildContext context, Function(String value) callBack,
    [double globalPositionX = 0,
    double globalPositionY = 0,
    bool isTop = false,
    bool isRead = false]) {
  bool isLeft =
      globalPositionX > MediaQuery.of(context).size.width / 2 ? false : true;
  bool isTop =
      globalPositionY > MediaQuery.of(context).size.height / 2 ? false : true;

  showDialog(
      context: context,
      builder: (context) {
        return Stack(children: <Widget>[
          Positioned(
              top: isTop ? globalPositionY : globalPositionY - 200.0,
              left: isLeft ? globalPositionX : globalPositionX - 120.0,
              width: 150.0,
              child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  child: Material(
                    child: Column(children: [
                      InkWell(
                          onTap: () => callBack('read'),
                          child: Container(
                              height: 50.0,
                              child: Text(isRead
                                  ? S.of(context).make_unread
                                  : S.of(context).make_read),
                              alignment: Alignment.center)),
                      Container(height: .5, color: Colors.grey[500]),
                      InkWell(
                          onTap: () => callBack('top'),
                          child: Container(
                              height: 50.0,
                              child: Text(isTop ? '取消置顶' : '置顶聊天'),
                              alignment: Alignment.center)),
                      Container(height: .5, color: Colors.grey[500]),
                      InkWell(
                          onTap: () => callBack('delete'),
                          child: Container(
                              height: 50.0,
                              child: Text(S.of(context).delete_chat),
                              alignment: Alignment.center))
                    ]),
                  )))
        ]);
      });
}

showAutoUpdateDialog(BuildContext context, Function(bool value) callBack) {
  var provider = Provider.of<ConfigProvider>(context, listen: false);

  showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
            title: Container(
                child: Text(S.of(context).autoUpdate),
                alignment: Alignment.center),
            children: <Widget>[
              RadioListTile(
                  title: Text('仅Wi-Fi网络'),
                  onChanged: (bool value) => callBack(value),
                  value: true,
                  groupValue: provider.autoUpdate),
              RadioListTile(
                  title: Text('从不'),
                  onChanged: (bool value) => callBack(value),
                  value: false,
                  groupValue: provider.autoUpdate),
              Container(
                  height: .5,
                  color: colorGrey_de,
                  margin: EdgeInsets.only(top: 20)),
              FlatButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: Text(S.of(context).cancel,
                      style: TextStyle(color: Colors.grey)))
            ],
            contentPadding: EdgeInsets.only(top: 12));
      });
}

/// 允许朋友查看朋友圈范围的选择对话框
showViewableDialog(BuildContext context, Function(String value) callBack) {
  var provider = Provider.of<ConfigProvider>(context, listen: false);

  showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
            title: Container(
                child: Text(S.of(context).viewable),
                alignment: Alignment.center),
            children: <Widget>[
              RadioListTile(
                  title: Text(S.of(context).half_year),
                  onChanged: (value) => callBack(value),
                  value: "half_year",
                  groupValue: provider.viewable),
              RadioListTile(
                  title: Text(S.of(context).one_month),
                  onChanged: (value) => callBack(value),
                  value: "one_month",
                  groupValue: provider.viewable),
              RadioListTile(
                  title: Text(S.of(context).three_days),
                  onChanged: (value) => callBack(value),
                  value: "three_days",
                  groupValue: provider.viewable),
              RadioListTile(
                  title: Text(S.of(context).all),
                  onChanged: (value) => callBack(value),
                  value: "all",
                  groupValue: provider.viewable),
              Container(
                  height: .5,
                  color: colorGrey_de,
                  margin: EdgeInsets.only(top: 20)),
              FlatButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: Text(S.of(context).cancel,
                      style: TextStyle(color: Colors.grey)))
            ],
            contentPadding: EdgeInsets.only(top: 12));
      });
}
