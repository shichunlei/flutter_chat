import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../model/user.dart';

import '../../contacts/choice_contacts.dart';

import '../../../widgets/index.dart';

import '../../../commons/index.dart';

import '../../../generated/i18n.dart';
import '../../profile/wallpaper.dart';
import '../../../provider/index.dart';

import '../../contacts/friend.dart';
import '../../mixin/chat_info_mixin.dart';

import 'manage.dart';
import 'members.dart';

class GroupChatInfoPage extends StatefulWidget {
  final JMConversationInfo chat;

  const GroupChatInfoPage({Key key, @required this.chat}) : super(key: key);

  @override
  createState() => _GroupChatInfoPageState();
}

class _GroupChatInfoPageState extends State<GroupChatInfoPage>
    with ChatInfoStateMixin {
  bool showNickName = false;

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
        appBar: AppBar(
            title: Text(S.of(context).title_group_chat_info("${list.length}"))),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: .75),
                    itemBuilder: (_, index) {
                      return ItemGridGroupMember(
                          showNickName: showNickName,
                          member: index < list.length ? list[index] : null,
                          onTap: () {
                            pushNewPage(
                                context,
                                FriendInfoPage(
                                    identifier: list[index].user.username));
                          },
                          showRemoveWidget: index == list.length + 1,
                          onRemoveTap: () => pushNewPage(
                                  context,
                                  MembersPage(
                                      members: list, groupId: groupInfo.id),
                                  callBack: (value) {
                                if (value) {
                                  getGroupUsers();
                                }
                              }),
                          showAddWidget: index == list.length,
                          onAddTap: () => pushNewPage(
                                  context,
                                  ChoiceContactsPage(
                                      users: userList, title: "选择联系人"),
                                  callBack: (List<UserBean> value) async {
                                if (null != value) {
                                  print(
                                      "=========================${value.toString()}");

                                  addMembersToGroup(value);
                                }
                              }));
                    },
                    itemCount: list.length + ((isAdmin || isOwner) ? 2 : 1))),
            SelectedText(
                title: S.of(context).group_name,
                content: groupInfo.name,
                onTap: () => pushNewPage(
                        context,
                        InputTextPage(
                            title: S.of(context).group_name,
                            hintText: '请填入新的群名称',
                            content: groupInfo.name,
                            maxLines: 1), callBack: (value) {
                      print('======================$value');
                      if (Utils.isNotEmpty(value)) updateGroupName(value);
                    }),
                margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 0.5),
            SelectedText(
                rightWidget: ImageView('images/icon_qr.png',
                    imageType: ImageType.assets, width: 20, height: 20),
                title: S.of(context).group_qr,
                onTap: () => showQRNameCardDialog(context, '',
                    title: S.of(context).group_qr),
                margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 0.5),
            SelectedText(
                title: S.of(context).group_notice,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 0.5),
            SelectedText(
                title: S.of(context).remark,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 0.5),
            Visibility(
                visible: isAdmin || isOwner,
                child: SelectedText(
                    title: S.of(context).group_manager,
                    onTap: () => pushNewPage(
                            context,
                            GroupManagePage(
                                isOwner: isOwner,
                                groupId: groupInfo.id), callBack: (bool value) {
                          if (value) init(widget.chat); // 刷新群信息
                        }),
                    margin: EdgeInsets.only(left: 20, right: 5))),
            SizedBox(height: 5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).mute_notifications,
                onChanged: (bool value) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .setDisturb(widget.chat, value);
                },
                isChecked: isNoDisturb),
            SizedBox(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).top_chat,
                onChanged: (bool value) {
                  /// todo 消息置顶
                  Provider.of<ChatProvider>(context, listen: false)
                      .setTopMessage(widget.chat, value);
                },
                isChecked: isTop),
            SizedBox(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).save_to_contacts,
                onChanged: (bool value) {},
                isChecked: false),
            SizedBox(height: 5),
            SelectedText(
                title: S.of(context).my_alias_in_group,
                content: groupNickname,
                onTap: () => pushNewPage(
                        context,
                        InputTextPage(
                            title: S.of(context).my_alias_in_group,
                            hintText: '请填入新的群昵称',
                            content: groupNickname,
                            maxLines: 1), callBack: (value) {
                      if (Utils.isNotEmpty(value)) setGroupNickname(value);
                    }),
                margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).on_screen_names,
                onChanged: (bool value) => setState(() => showNickName = value),
                isChecked: false),
            SizedBox(height: 5),
            SelectedText(
                title: S.of(context).set_background,
                onTap: () =>
                    pushNewPage(context, WallpaperPage(chat: widget.chat)),
                margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 5),
            SelectedText(
                title: S.of(context).clear_messages,
                onTap: () {
                  /// todo 清空聊天记录
                  Provider.of<ChatProvider>(context, listen: false)
                      .deleteChat(widget.chat);
                },
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(top: 5, bottom: 30),
                child: FlatButton(
                    color: Colors.white,
                    onPressed: () async {
                      showLoadingDialog(context);

                      await jMessage.exitGroup(id: groupInfo.id).then((value) {
                        Toast.show(context, '已退出群聊');
                        Navigator.of(context).pop();
                      }, onError: (error) {
                        Toast.show(context, '退出群聊失败');
                        Navigator.of(context).pop();
                        if (error is PlatformException) {
                          print('exitGroup error => ${error.toString()}');
                        }
                      });
                    },
                    child: Text(S.of(context).delete_and_leave,
                        style: TextStyle(color: Colors.red))))
          ]),
        ));
  }

  /// 添加好友到群
  void addMembersToGroup(List<UserBean> members) async {
    if (isOwner || isAdmin) {
      // 群主或群管理可以直接拉进群
      List<String> usernames = [];
      members.forEach((element) {
        usernames.add(element.identifier);
      });

      await jMessage
          .addGroupMembers(id: groupInfo.id, usernameArray: usernames)
          .then((value) {
        getGroupUsers();
      }, onError: (error) {
        print("addGroupMembers error => ${error.toString()}");
      });
    } else {
      // 普通群成员只能发送进群邀请
      members.forEach((element) async {
        /// 获取会话
        await jMessage
            .getConversation(
                target: JMSingle.fromJson({"username": element.identifier}))
            .then((JMConversationInfo conversation) {
          /// 发送进群邀请
          Provider.of<ChatProvider>(context, listen: false)
              .sendGroupInvitationMessage(
                  conversation, groupInfo.id, groupInfo.name);
        }, onError: (error) async {
          print("getConversation error => ${error.toString()}");

          if (error is PlatformException) {
            if (error.code == "2") {
              /// 没有改会话，创建一个会话
              await jMessage
                  .createConversation(
                      target:
                          JMSingle.fromJson({"username": element.identifier}))
                  .then((JMConversationInfo conversation) {
                /// 发送进群邀请
                Provider.of<ChatProvider>(context, listen: false)
                    .sendGroupInvitationMessage(
                        conversation, groupInfo.id, groupInfo.name);
              }, onError: (error) {
                print("createConversation error => ${error.toString()}");
              });
            }
          }
        });
      });
    }
  }
}
