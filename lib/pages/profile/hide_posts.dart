import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/contacts/friend.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import '../../model/user.dart';
import '../../widgets/index.dart';

class HidePostsPage extends StatefulWidget {
  final String type;

  const HidePostsPage({Key key, @required this.type}) : super(key: key);

  @override
  createState() => _HidePostsPageState();
}

class _HidePostsPageState extends State<HidePostsPage> {
  String content;

  /// 记录原始数据
  List<UserBean> users = [];

  ///
  List<UserBean> _users = [];

  List<UserBean> addUsers = [];

  List<UserBean> removeUsers = [];

  int count = 0;

  bool isRemove = false;

  @override
  void initState() {
    super.initState();

    if (widget.type == "my") {
      content = S.of(context).hide_my_posts_tip;
    }
    if (widget.type == "their") {
      content = S.of(context).hide_their_posts_tip;
    }

    getUsersList();
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
          title: Text(widget.type == "my"
              ? S.of(context).title_hide_my_posts("$count")
              : S.of(context).title_hide_their_posts("$count")),
          actions: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                child: MaterialButton(
                    minWidth: 50,
                    disabledColor: Colors.grey[200],
                    onPressed: removeUsers.length > 0 || addUsers.length > 0
                        ? () {
                            /// todo
                            Navigator.maybePop(context);
                          }
                        : null,
                    child: Text(S.of(context).complete,
                        style: TextStyle(color: Colors.white)),
                    color: Colors.green))
          ]),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 10, bottom: 5),
              child: Text(content,
                  style: TextStyle(color: Colors.grey, fontSize: 13))),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
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
                    if (index == _users.length) {
                      /// 添加用户到群
                      return GestureDetector(
                          onTap: () {},
                          child: Column(children: <Widget>[
                            Container(
                                height: (Utils.width - 60) / 5.0,
                                width: (Utils.width - 60) / 5.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[500], width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.add,
                                    size: 50, color: Colors.grey[500]))
                          ]));
                    }
                    if (index == _users.length + 1) {
                      /// 减去群成员
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              isRemove = true;
                            });
                          },
                          child: Column(children: <Widget>[
                            Container(
                                height: (Utils.width - 60) / 5.0,
                                width: (Utils.width - 60) / 5.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[500], width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.remove,
                                    size: 50, color: Colors.grey[500]))
                          ]));
                    }

                    return ItemGridMember(
                        user: _users[index],
                        onTap: () => pushNewPage(
                            context,
                            FriendInfoPage(
                                identifier: _users[index].identifier)),
                        showDel: isRemove,
                        onDelTap: () {
                          setState(() {
                            if (!removeUsers.contains(_users[index])) {
                              removeUsers.add(_users[index]);
                            }

                            _users.removeAt(index);
                          });
                        });
                  },
                  itemCount: _users.length +
                      (_users.length == 0 ? 1 : isRemove ? 0 : 2)))
        ]),
      ),
    );
  }

  void getUsersList() async {
    users.add(UserBean(
        id: 1,
        name: "张三",
        identifier: "18601952581",
        avatarUrl:
            "http://b-ssl.duitang.com/uploads/item/201610/09/20161009144543_ZcUKG.jpeg"));
    users.add(UserBean(
        id: 2,
        name: "李四",
        identifier: "13522038091",
        avatarUrl:
            "http://img.zcool.cn/community/01d46755af53306ac7258178c57254.jpg@1280w_1l_2o_100sh.png"));
    users.add(UserBean(
        id: 3,
        name: "王五",
        identifier: "18601952581",
        avatarUrl:
            "http://www.cpnic.com/UploadFiles/img_0_4093598632_1611583068_26.jpg"));
    users.add(UserBean(
        id: 4,
        name: "赵六",
        identifier: "13522038091",
        avatarUrl:
            "http://dingyue.ws.126.net/2020/0514/f2b1df29j00qablbq000lc000b400b4c.jpg"));

    _users.addAll(users);

    setState(() {
      count = users.length;
    });
  }
}
