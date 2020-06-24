import '../../model/user.dart';

import '../../generated/i18n.dart';

import '../../commons/index.dart';

import '../../provider/index.dart';

import 'package:flutter/material.dart';

class ChoiceContactsPage extends StatefulWidget {
  final List<UserBean> users;
  final String title;

  ChoiceContactsPage({Key key, this.users, @required this.title})
      : super(key: key);

  @override
  createState() => _ChoiceContactsPageState();
}

class _ChoiceContactsPageState extends State<ChoiceContactsPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      var provider = Provider.of<ContactProvider>(context, listen: false);
      provider.initChoiceContacts(widget.users ?? []);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContactProvider>(context);

    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              child: FlatButton(
                  disabledColor: Color(0xFFB6DFC9),
                  shape: StadiumBorder(),
                  onPressed: provider.selectContacts.length > 0
                      ? () {
                          Navigator.pop(context, provider.selectContacts);
                        }
                      : null,
                  color: Color(0xFF60B47A),
                  child: Text(S.of(context).done,
                      style: TextStyle(color: Colors.white))))
        ]),
        body: Column(children: [
          Container(height: .5, color: Color(0xFFEFEFEF)),
          Visibility(
              visible: provider.selectContacts.length > 0,
              child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                            onTap: () {
                              print('${provider.selectContacts[index].name}');
                              int _index = provider.choiceContacts
                                  .indexOf(provider.selectContacts[index]);

                              provider.checkChoiceContacts(false, _index);
                            },
                            child: ImageView(
                                '${provider.selectContacts[index].avatarUrl}',
                                radius: 5,
                                height: 40,
                                width: 40,
                                placeholder: 'images/header.jpeg'));
                      },
                      itemCount: provider.selectContacts.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(width: 3)))),
          Container(height: .5, color: Color(0xFFEFEFEF)),
          Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: S.of(context).title_contacts,
                      prefixIcon: Icon(Icons.search),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color(0xffcccccc)))),
          Container(height: .5, color: Color(0xFFEFEFEF)),
          Expanded(
              child:
//              SingleChildScrollView(
//            child: Column(children: [
//              Material(
//                  color: Colors.white,
//                  child: InkWell(
//                      onTap: () {
//                        debugPrint("${provider.selectContacts.length}");
//                      },
//                      child: Container(
//                          height: 50,
//                          padding: EdgeInsets.symmetric(horizontal: 15),
//                          child: Row(
//                              children: <Widget>[
//                                Text(S.of(context).create_chat,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold)),
//                                Icon(Icons.keyboard_arrow_right)
//                              ],
//                              mainAxisAlignment:
//                                  MainAxisAlignment.spaceBetween)))),
//              Container(height: 1.0, color: Color(0xFFEFEFEF)),
//              Material(
//                  color: Colors.white,
//                  child: InkWell(
//                      onTap: () {},
//                      child: Container(
//                          height: 50,
//                          padding: EdgeInsets.symmetric(horizontal: 15),
//                          child: Row(
//                              children: <Widget>[
//                                Text(S.of(context).selection_group,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold)),
//                                Icon(Icons.keyboard_arrow_right)
//                              ],
//                              mainAxisAlignment:
//                                  MainAxisAlignment.spaceBetween)))),
//              Container(height: 1.0, color: Color(0xFFEFEFEF)),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10.0),
                      itemBuilder: (_, index) => CheckboxListTile(
                          onChanged:
                              provider.choiceContacts[index].checkedState == 2
                                  ? null
                                  : (bool value) => provider
                                      .checkChoiceContacts(value, index),
                          value:
                              provider.choiceContacts[index].checkedState != 0,
                          selected:
                              provider.choiceContacts[index].checkedState == 2,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Row(children: <Widget>[
                            ImageView(provider.choiceContacts[index].avatarUrl,
                                radius: 18, placeholder: 'images/header.jpeg'),
                            SizedBox(width: 8),
                            Text(provider.choiceContacts[index].name)
                          ])),
                      itemCount: provider.choiceContacts.length)
//            ]),
//          )
              )
        ]));
  }
}
