import 'package:flutter/material.dart';
import 'package:flutter_chat/commons/index.dart';
import 'package:flutter_chat/generated/i18n.dart';

class GroupManagePage extends StatefulWidget {
  final bool isOwner;
  final String groupId;

  const GroupManagePage({Key key, this.isOwner: false, this.groupId})
      : super(key: key);

  @override
  createState() => _GroupManagePageState();
}

class _GroupManagePageState extends State<GroupManagePage> {
  @override
  void initState() {
    super.initState();
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
        body: Column(children: [
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
                  onTap: () async {
                    await jMessage.transferGroupOwner(
                        groupId: widget.groupId, username: "");
                  },
                  margin: EdgeInsets.only(left: 20, right: 5))),
          SizedBox(height: 5),
          SelectedText(
              title: "群管理员", margin: EdgeInsets.only(left: 20, right: 5)),
          SizedBox(height: 0.5)
        ]));
  }
}
