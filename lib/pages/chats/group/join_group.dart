import 'package:flutter/material.dart';
import 'package:flutter_chat/commons/index.dart';

class JoinGroupPage extends StatefulWidget {
  final String groupId;
  final JMUserInfo fromUser;
  final JMUserInfo currentUser;

  const JoinGroupPage({Key key, this.groupId, this.fromUser, this.currentUser})
      : super(key: key);

  @override
  createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  bool isJoin = false;

  JMGroupInfo jmGroupInfo;

  List<JMGroupMemberInfo> _list = [];

  @override
  void initState() {
    super.initState();

    getGroupData(widget.groupId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('群聊邀请')),
        body: Column(children: [
          Container(
              width: double.infinity,
              color: Colors.white,
              height: 170,
              child: Column(children: [
                ImageView(groupHeaderImage, height: 80, width: 80, radius: 5),
                SizedBox(height: 5),
                Text('${jmGroupInfo?.name ?? ""}',
                    style: TextStyle(fontSize: 17)),
                SizedBox(height: 5),
                Text('${_list?.length}人')
              ], mainAxisSize: MainAxisSize.min),
              alignment: Alignment.center),
          Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text('${JPushUtil.getName(widget.fromUser)}邀请你入群',
                  style: TextStyle(fontSize: 20, color: Colors.grey[500]))),
          !isJoin
              ? Column(children: <Widget>[
                  MaterialButton(
                      height: 45,
                      elevation: 0.0,
                      onPressed: () {},
                      minWidth: 220,
                      color: Colors.green,
                      child: Text('加入群聊',
                          style: TextStyle(color: Colors.white, fontSize: 18))),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 18.0, right: 18, top: 30),
                      child: Text(
                          '1.你和群里其他人都不是好友关系，请注意隐私安全。\n2.该群聊人数较多，为减少新消息给你带来的打扰，建议谨慎加入',
                          style: TextStyle(color: Colors.grey[500])))
                ])
              : Text('你已接受邀请',
                  style: TextStyle(color: Colors.green, fontSize: 18))
        ]));
  }

  void getGroupData(String groupId) async {
    await jMessage.getGroupInfo(id: groupId).then((value) {
      setState(() {
        jmGroupInfo = value;
      });
    }, onError: (error) {});

    await jMessage.getGroupMembers(id: groupId).then((value) {
      _list.addAll(value);

      isJoin = _list
              .where((element) =>
                  element?.user?.username == widget.currentUser?.username)
              .length >
          0;

      setState(() {});
    }, onError: (error) {});

    setState(() {});
  }
}
