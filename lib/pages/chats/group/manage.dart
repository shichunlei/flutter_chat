import 'package:flutter/material.dart';

import '../../contacts/friend.dart';
import '../../../commons/index.dart';
import '../../../generated/i18n.dart';
import '../../../widgets/index.dart';

class GroupManagePage extends StatefulWidget {
  final bool isOwner;
  final String groupId;

  const GroupManagePage({Key key, this.isOwner: false, this.groupId})
      : super(key: key);

  @override
  createState() => _GroupManagePageState();
}

class _GroupManagePageState extends State<GroupManagePage> {
  /// 管理员列表
  List<JMGroupMemberInfo> admins = [];

  /// 所有群成员
  List<JMGroupMemberInfo> allMembers = [];

  /// 记录多选框的值（0为未选中，1为选中，2为已选中但不可修改）
  List<int> addAdminChecked = [];

  /// 新增加的管理员
  List<JMGroupMemberInfo> newAdmins = [];

  List<bool> adminChecked = [];

  /// 要去除的管理员
  List<JMGroupMemberInfo> removeAdmins = [];

  String groupValue = "";

  @override
  void initState() {
    super.initState();

    getMembersOfGroup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).group_manager)),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 0.5),
            SwitchTitleView(
                padding: EdgeInsets.only(left: 20, right: 5),
                title: "群聊邀请确认",
                onChanged: (bool value) {},
                isChecked: false,
                subTitle: "启用后，群成员需群主或群管理员确认才能邀请朋友进群，扫描二维码进群将同时停用"),
            SizedBox(height: 0.5),
            Visibility(
                visible: widget.isOwner,
                child: SelectedText(
                    title: "群主管理权转让",
                    onTap: () => _showAllModalBottomSheet(),
                    margin: EdgeInsets.only(left: 20, right: 5))),
            SizedBox(height: 5),
            SelectedText(
                title: "群管理员", margin: EdgeInsets.only(left: 20, right: 5)),
            SizedBox(height: 0.5),
            Container(
                color: Colors.white,
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
                          showNickName: true,
                          member: index < admins.length ? admins[index] : null,
                          onTap: () => pushNewPage(
                              context,
                              FriendInfoPage(
                                  identifier: admins[index].user.username)),
                          showAddWidget: index == admins.length,
                          onAddTap: () {
                            addAdminChecked.clear();

                            /// 添加群管理
                            allMembers.forEach((element) {
                              if (element.memberType !=
                                  JMGroupMemberType.ordinary) {
                                addAdminChecked.add(2);
                              } else {
                                addAdminChecked.add(0);
                              }
                            });
                            newAdmins.clear();

                            showAddAdminModalBottomSheet();
                          },
                          showRemoveWidget: index == admins.length + 1,
                          onRemoveTap: () {
                            adminChecked.clear();

                            admins.forEach((element) {
                              adminChecked.add(false);
                            });

                            removeAdmins.clear();

                            showRemoveAdminModalBottomSheet();
                          });
                    },
                    itemCount: admins.length +
                        (!widget.isOwner ? 0 : admins.length > 0 ? 2 : 1))),
          ]),
        ));
  }

  void getMembersOfGroup() async {
    await jMessage.getGroupMembers(id: widget.groupId).then(
        (List<JMGroupMemberInfo> list) {
      allMembers.clear();
      allMembers.addAll(list);

      admins.clear();
      allMembers.forEach((element) {
        if (element.memberType == JMGroupMemberType.admin) {
          admins.add(element);
        }
      });

      setState(() {});
    }, onError: (error) {
      print("getGroupMembers    error => ${error.toString()}");
    });
  }

  /// 待转让群主人员列表
  void _showAllModalBottomSheet() async {
    groupValue = "";

    showModalBottomSheet(
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: modalBottomSheet(),
            child: Container(
              height: 60.0 * allMembers.length,
              constraints: BoxConstraints(maxHeight: 250),
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return RadioListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: ValueKey("$index").value,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value;
                          });
                          Navigator.pop(context);

                          showTransferDialog(context);
                        },
                        title: Row(children: <Widget>[
                          ImageView(allMembers[index].user.extras["avatarUrl"],
                              radius: 18, placeholder: 'images/header.jpeg'),
                          SizedBox(width: 8),
                          Text(JPushUtil.getName(allMembers[index].user))
                        ]));
                  },
                  separatorBuilder: (_, index) =>
                      Container(height: .1, color: Colors.grey),
                  itemCount: allMembers.length),
            ),
          );
        },
        context: context,
        shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
  }

  /// 转让群主待确认对话框
  void showTransferDialog(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("转让群"),
              content: Text(
                  "您确定将群主转让给${JPushUtil.getName(allMembers[int.parse(groupValue)].user)}"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      /// 群主转让
                      await jMessage
                          .transferGroupOwner(
                              groupId: widget.groupId,
                              username: allMembers[int.parse(groupValue)]
                                  .user
                                  .username)
                          .then((value) => Navigator.maybePop(context, true),
                              onError: (error) {
                        print(
                            "transferGroupOwner error => ${error.toString()}");
                      });
                    },
                    child: Text(S.of(context).sure)),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).cancel)),
              ]);
        });
  }

  /// 添加管理员
  void showAddAdminModalBottomSheet() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return ClipRRect(
                borderRadius: modalBottomSheet(),
                child: Container(
                    height: 60.0 * allMembers.length + 40,
                    constraints: BoxConstraints(maxHeight: 250),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              newAdmins.clear();
                              Navigator.pop(context);
                            },
                            child: Text(S.of(context).cancel)),
                        FlatButton(
                            onPressed: newAdmins.length > 0
                                ? () async {
                                    Navigator.pop(context);

                                    List<String> usernames = [];
                                    newAdmins.forEach((element) {
                                      usernames.add(element.user.username);
                                    });

                                    await jMessage
                                        .addGroupAdmins(
                                            groupId: widget.groupId,
                                            usernames: usernames)
                                        .then((value) {
                                      setState(() {
                                        newAdmins.clear();
                                      });

                                      getMembersOfGroup();
                                    }, onError: (error) {
                                      print(
                                          "addGroupAdmins error => ${error.toString()}");
                                    });
                                  }
                                : null,
                            child: Text(S.of(context).sure),
                            textColor: Colors.green),
                        SizedBox(width: 10)
                      ], mainAxisAlignment: MainAxisAlignment.end),
                      Container(height: .1, color: Colors.grey),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (_, index) {
                                return CheckboxListTile(
                                    value: addAdminChecked[index] != 0,
                                    onChanged: addAdminChecked[index] == 2
                                        ? null
                                        : (value) {
                                            if (value) {
                                              newAdmins.add(allMembers[index]);
                                            } else {
                                              newAdmins
                                                  .remove(allMembers[index]);
                                            }
                                            state(() {
                                              addAdminChecked[index] =
                                                  value ? 1 : 0;
                                            });
                                          },
                                    selected: addAdminChecked[index] == 2,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Row(children: <Widget>[
                                      ImageView(
                                          allMembers[index]
                                              .user
                                              .extras["avatarUrl"],
                                          radius: 18,
                                          placeholder: 'images/header.jpeg'),
                                      SizedBox(width: 8),
                                      Text(JPushUtil.getName(
                                          allMembers[index].user))
                                    ]));
                              },
                              separatorBuilder: (_, index) =>
                                  Container(height: .1, color: Colors.grey),
                              itemCount: allMembers.length))
                    ])));
          });
        },
        shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
  }

  /// 删除管理员
  void showRemoveAdminModalBottomSheet() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return ClipRRect(
                borderRadius: modalBottomSheet(),
                child: Container(
                  height: 60.0 * admins.length + 40,
                  constraints: BoxConstraints(maxHeight: 250),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            removeAdmins.clear();
                            Navigator.pop(context);
                          },
                          child: Text(S.of(context).cancel)),
                      FlatButton(
                          onPressed: removeAdmins.length > 0
                              ? () async {
                                  Navigator.pop(context);

                                  List<String> usernames = [];
                                  removeAdmins.forEach((element) {
                                    usernames.add(element.user.username);
                                  });

                                  jMessage
                                      .removeGroupAdmins(
                                          groupId: widget.groupId,
                                          usernames: usernames)
                                      .then((value) {
                                    setState(() {
                                      removeAdmins.clear();
                                    });

                                    getMembersOfGroup();
                                  }, onError: (error) {
                                    print(
                                        "removeGroupAdmins error => ${error.toString()}");
                                  });
                                }
                              : null,
                          child: Text(S.of(context).sure),
                          textColor: Colors.green),
                      SizedBox(width: 10)
                    ], mainAxisAlignment: MainAxisAlignment.end),
                    Container(height: .1, color: Colors.grey),
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (_, index) {
                              return CheckboxListTile(
                                  value: adminChecked[index],
                                  onChanged: (value) {
                                    if (value) {
                                      removeAdmins.add(admins[index]);
                                    } else {
                                      removeAdmins.remove(admins[index]);
                                    }

                                    state(() {
                                      adminChecked[index] = value;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Row(children: <Widget>[
                                    ImageView(
                                        admins[index].user.extras["avatarUrl"],
                                        radius: 18,
                                        placeholder: 'images/header.jpeg'),
                                    SizedBox(width: 8),
                                    Text(JPushUtil.getName(admins[index].user))
                                  ]));
                            },
                            separatorBuilder: (_, index) =>
                                Container(height: .1, color: Colors.grey),
                            itemCount: admins.length))
                  ]),
                ));
          });
        },
        shape: RoundedRectangleBorder(borderRadius: modalBottomSheet()));
  }
}
