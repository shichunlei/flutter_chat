import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/index.dart';

import '../../../commons/index.dart';

import '../../../generated/i18n.dart';
import '../../profile/wallpaper.dart';
import '../../../provider/index.dart';

import '../../contacts/choice_contacts.dart';
import '../../contacts/friend.dart';
import '../../mixin/chat_info_mixin.dart';

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
                      if (isAdmin || isOwner) {
                        if (index == list.length) {
                          /// 添加用户到群
                          return GestureDetector(
                              onTap: () =>
                                  pushNewPage(context, ChoiceContactsPage()),
                              child: Column(children: <Widget>[
                                Container(
                                    height: (Utils.width - 60) / 5.0,
                                    width: (Utils.width - 60) / 5.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[500],
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(Icons.add,
                                        size: 50, color: Colors.grey[500]))
                              ]));
                        }
                        if (index == list.length + 1) {
                          /// 减去群成员
                          return GestureDetector(
                              onTap: () => pushNewPage(
                                      context,
                                      MembersPage(
                                          members: list, groupId: groupInfo.id),
                                      callBack: (value) async {
                                    // 重新拉去群成员
                                    getGroupUsers();
                                  }),
                              child: Column(children: <Widget>[
                                Container(
                                    height: (Utils.width - 60) / 5.0,
                                    width: (Utils.width - 60) / 5.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[500],
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(Icons.remove,
                                        size: 50, color: Colors.grey[500]))
                              ]));
                        }
                      } else {
                        if (index == list.length) {
                          /// 添加用户到群
                          return GestureDetector(
                              onTap: () =>
                                  pushNewPage(context, ChoiceContactsPage()),
                              child: Column(children: <Widget>[
                                Image.asset('images/picture_box.png',
                                    height: (Utils.width - 60) / 5.0,
                                    width: (Utils.width - 60) / 5.0,
                                    fit: BoxFit.fill,
                                    color: Colors.grey)
                              ]));
                        }
                      }

                      return ItemGridGroupMember(
                          showNickName: showNickName,
                          member: list[index],
                          onTap: () {
                            /// todo 进入好友详情页面
                            pushNewPage(
                                context,
                                FriendInfoPage(
                                    identifier: list[index].user.username));
                          });
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
            Container(height: 0.5),
            SelectedText(
                rightWidget: ImageView('images/icon_qr.png',
                    imageType: ImageType.assets, width: 20, height: 20),
                title: S.of(context).group_qr,
                onTap: () => showQRNameCardDialog(context, '',
                    title: S.of(context).group_qr),
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: 0.5),
            SelectedText(
                title: S.of(context).group_notice,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: 0.5),
            SelectedText(
                title: S.of(context).remark,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: 0.5),
            Visibility(
                visible: isAdmin || isOwner,
                child: SelectedText(
                    title: S.of(context).group_manager,
                    onTap: () {},
                    margin: EdgeInsets.only(left: 20, right: 5))),
            Container(height: 5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).mute_notifications,
                onChanged: (bool value) {
                  /// todo 设置这个消息免打扰
                  Provider.of<ChatProvider>(context, listen: false)
                      .setDisturb(widget.chat, value);
                },
                isChecked: isNoDisturb),
            Container(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).top_chat,
                onChanged: (bool value) {
                  /// todo 消息置顶
                  Provider.of<ChatProvider>(context, listen: false)
                      .setTopMessage(widget.chat, value);
                },
                isChecked: isTop),
            Container(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).save_to_contacts,
                onChanged: (bool value) {},
                isChecked: false),
            Container(height: 5),
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
            Container(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: S.of(context).on_screen_names,
                onChanged: (bool value) => setState(() => showNickName = value),
                isChecked: false),
            Container(height: 5),
            SelectedText(
                title: S.of(context).set_background,
                onTap: () =>
                    pushNewPage(context, WallpaperPage(chat: widget.chat)),
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: 5),
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
}
