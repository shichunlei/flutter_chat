import 'package:flutter/material.dart';

import '../../../commons/index.dart';
import '../../../generated/i18n.dart';

import '../../../provider/index.dart';
import '../../../model/user.dart';

import '../../contacts/choice_contacts.dart';
import '../../contacts/friend.dart';
import '../../mixin/chat_info_mixin.dart';
import '../../profile/wallpaper.dart';

class SingleChatInfoPage extends StatefulWidget {
  final JMConversationInfo chat;

  const SingleChatInfoPage({Key key, @required this.chat}) : super(key: key);

  @override
  createState() => _SingleChatInfoPageState();
}

class _SingleChatInfoPageState extends State<SingleChatInfoPage>
    with ChatInfoStateMixin {
  @override
  void initState() {
    super.initState();

    init(widget.chat);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('${S.of(context).title_chat_info}')),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(children: <Widget>[
                  GestureDetector(
                      child: ImageView('${userInfo.extras["avatarUrl"]}',
                          height: 60,
                          width: 60,
                          radius: 10.0,
                          margin: EdgeInsets.only(right: 10),
                          placeholder: 'images/header.jpeg'),
                      onTap: () => pushNewPage(context,
                          FriendInfoPage(identifier: userInfo.username))),
                  GestureDetector(
                      onTap: () {
                        pushNewPage(
                            context, ChoiceContactsPage(users: [userBean],title: "发起群聊"),
                            callBack: (List<UserBean> value) async {
                          print("==================${value.toString()}");

                          if (value != null) {
                            showLoadingDialog(context);

                            List<String> usernames = [];

                            usernames.add(userInfo.username);

                            value.forEach((element) {
                              usernames.add(element.identifier);
                            });

                            /// 创建群聊，添加群成员，创建一个会话,然后跳转到该群聊会话页面
                            await jMessage
                                .createGroup(name: "这是一个群聊", desc: "这是新创建的一个群聊")
                                .then((groupId) async {
                              /// 添加群成员
                              await jMessage
                                  .addGroupMembers(
                                      id: groupId, usernameArray: usernames)
                                  .then((value) async {
                                /// 创建群聊会话并跳转到群聊会话中
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .jumpToConversationMessage(context,
                                        JMGroup.fromJson({"groupId": groupId}),
                                        hiddenLoading: true);
                              }, onError: (error) {
                                Navigator.pop(context);
                                print(
                                    "addGroupMembers error => ${error.toString()}");
                              });
                            }, onError: (error) {
                              Navigator.pop(context);
                              print("createGroup error => ${error.toString()}");
                            });
                          }
                        });
                      },
                      child: Image.asset('images/picture_box.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.fill,
                          color: Colors.grey))
                ])),
            SwitchTitleView(
                title: S.of(context).mute_notifications,
                onChanged: (bool value) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .setDisturb(widget.chat, value);
                },
                isChecked: isNoDisturb),
            Container(height: 0.5),
            SwitchTitleView(
                title: S.of(context).top_chat,
                onChanged: (bool value) {
                  /// todo 消息置顶
                  Provider.of<ChatProvider>(context, listen: false)
                      .setTopMessage(widget.chat, value);
                },
                isChecked: isTop),
            Container(height: 5),
            SelectedText(
                title: S.of(context).set_background,
                onTap: () =>
                    pushNewPage(context, WallpaperPage(chat: widget.chat)),
                margin: EdgeInsets.symmetric(horizontal: 20)),
            Container(height: 5),
            SelectedText(
                title: S.of(context).clear_messages,
                onTap: () {
                  /// todo 清空聊天记录
                  Provider.of<ChatProvider>(context, listen: false)
                      .cleanMessages(widget.chat);
                },
                margin: EdgeInsets.symmetric(horizontal: 20))
          ]),
        ));
  }
}
