import 'package:flutter/material.dart';

import '../../commons/index.dart';
import '../../widgets/item_friend_notify.dart';
import '../../provider/index.dart';
import '../../generated/i18n.dart';

import '../search.dart';
import 'add_friend.dart';

class NewFriendsPage extends StatefulWidget {
  const NewFriendsPage({Key key}) : super(key: key);

  @override
  createState() => _NewFriendsPageState();
}

class _NewFriendsPageState extends State<NewFriendsPage> {
  String identifier;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        identifier =
            Provider.of<UserProvider>(context, listen: false).identifier;
      });

      var provider = Provider.of<ContactProvider>(context, listen: false);

      if (provider.notifications.length == 0) provider.getNotify(identifier);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).new_friend), actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: FlatButton(
                  onPressed: () => pushNewPage(context, AddFriendPage()),
                  child: Text(S.of(context).add_friend)))
        ]),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: FlatButton(
                    onPressed: () => pushNewPage(context, SearchPage()),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.search, size: 20),
                          Text('微信号/手机号')
                        ]),
                    color: Colors.white)),
            SelectedText(
                title: '添加手机联系人',
                leading: Icon(Icons.phone, color: Colors.green),
                onTap: () {}),
            Consumer<ContactProvider>(
                builder: (context, ContactProvider notify, child) {
              return ListView.separated(
                  padding: EdgeInsets.only(top: 20),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) =>
                      ItemFriendNotify(
                          notify: notify.notifications[index],
                          isReceive:
                              notify.notifications[index].user.identifier ==
                                  identifier),
                  itemCount: notify.notifications.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 2));
            })
          ]),
        ));
  }
}
