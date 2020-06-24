import '../../provider/index.dart';
import '../../generated/i18n.dart';
import '../../commons/ui/loader.dart';
import '../../model/user.dart';
import '../../widgets/index.dart';

import 'package:flutter/material.dart';

/// 发送名片时选择好友列表操作
class SelectContactsPage extends StatefulWidget {
  SelectContactsPage({Key key}) : super(key: key);

  @override
  createState() => _SelectContactsPageState();
}

class _SelectContactsPageState extends State<SelectContactsPage> {
  /// 所有的好友
  List<UserBean> allContacts = [];

  /// 搜索出的
  List<UserBean> contacts = [];

  LoaderState state = LoaderState.Loading;

  TextEditingController controller;

  String keywords = '';

  @override
  void initState() {
    super.initState();

    controller = TextEditingController()
      ..addListener(() {
        contacts.clear();
        setState(() {
          keywords = controller.text.toString();
          if (keywords == '' || keywords.length == 0 || keywords == null) {
            contacts.addAll(allContacts);
            setState(() {});
          } else {
            allContacts.forEach((item) {
              if (item.name.toLowerCase().contains(keywords.toLowerCase())) {
                contacts.add(item);
              }
            });

            setState(() {});
          }
        });
      });

    getContacts();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: Text(S.of(context).title_select_contacts),
            actions: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: FlatButton(
                      shape: StadiumBorder(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(S.of(context).cancel)))
            ]),
        body: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: S.of(context).title_contacts,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color(0xfff5f6f8)))),
          Expanded(
              child: LoaderContainer(
                  contentView: ListView.builder(
                      itemBuilder: (_, index) {
                        return ItemContact(
                            user: contacts[index],
                            onTap: () {
                              Navigator.pop(context, contacts[index]);
                            });
                      },
                      itemCount: contacts.length),
                  loaderState: state))
        ]));
  }

  void getContacts() async {
    allContacts.clear();
    contacts.clear();

    Future.delayed(Duration.zero, () async {
      var provider = Provider.of<ContactProvider>(context, listen: false);

      if (provider.friends.length == 0) {
        await provider.getFriends();
      }

      allContacts = provider.friends;

      contacts.addAll(allContacts);

      setState(() {
        state = LoaderState.Succeed;
      });
    });
  }
}
