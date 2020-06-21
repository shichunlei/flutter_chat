import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../generated/i18n.dart';
import '../../../commons/index.dart';
import '../../../utils/jpush_util.dart';
import '../../../widgets/index.dart';

class MembersPage extends StatefulWidget {
  final List<JMGroupMemberInfo> members;
  final String groupId;

  const MembersPage({Key key, @required this.members, @required this.groupId})
      : super(key: key);

  @override
  createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  List<String> usernames = [];
  List<JMGroupMemberInfo> _members = [];

  @override
  void initState() {
    super.initState();

    _members.addAll(widget.members);
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
            title: Text(S.of(context).title_chat_member('${_members.length}')),
            elevation: 1.0,
            actions: <Widget>[
              Container(
                  width: 70,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(right: 10),
                  child: FlatButton(
                      onPressed: usernames.length > 0
                          ? () => removeGroupMembers()
                          : null,
                      child: Text(S.of(context).delete),
                      color: Colors.green,
                      disabledColor: Colors.green[200],
                      textColor: Colors.white))
            ]),
        body: ListView.separated(
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) => ItemGroupMember(
                member: _members[index],
                callBack: (bool isCheck) {
                  if (isCheck) {
                    usernames.add(_members[index].user.username);
                  } else {
                    usernames.removeWhere(
                        (element) => element == _members[index].user.username);
                  }

                  setState(() {
                    print('${usernames.length}');
                  });
                }),
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: .5),
            itemCount: _members.length));
  }

  void removeGroupMembers() async {
    await jMessage
        .removeGroupMembers(
            id: widget.groupId,
            usernames: usernames,
            appKey: Config.JPUSH_APPKEY)
        .then((value) {
      Toast.show(context, '已退出群聊');

      usernames.forEach((username) {
        _members.retainWhere((element) => element.user.username == username);
      });

      Navigator.of(context).pop();
    }, onError: (error) {
      Toast.show(context, '退出群聊失败');
      Navigator.of(context).pop();
      if (error is PlatformException) {
        print('removeGroupMembers error => ${error.toString()}');
      }
    });
  }
}
