import '../../generated/i18n.dart';

import '../../commons/ui/image_view.dart';

import '../../provider/index.dart';
import '../../widgets/index.dart';

import 'package:flutter/material.dart';

class ChoiceContactsPage extends StatefulWidget {
  ChoiceContactsPage({Key key}) : super(key: key);

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

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<ContactProvider>(context, listen: false)
        ..getFriends()
        ..clear();
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
        appBar: AppBar(
            title: Text(S.of(context).send_to),
            leading: CloseButton()),
        body: Column(children: [
          Container(height: 1.0, color: Color(0xFFEFEFEF)),
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
                          },
                          child: ImageView(
                              '${provider.selectContacts[index].avatarUrl}',
                              radius: 20));
                    },
                    itemCount: provider.selectContacts.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(width: 3))),
          ),
          Container(height: 1.0, color: Color(0xFFEFEFEF)),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: S.of(context).title_contacts,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color(0xffcccccc))),
          ),
          Container(height: 1.0, color: Color(0xFFEFEFEF)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                Material(
                    color: Colors.white,
                    child: InkWell(
                        onTap: () {
                          debugPrint("${provider.selectContacts.length}");
                        },
                        child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                                children: <Widget>[
                                  Text(S.of(context).create_chat,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween)))),
                Container(height: 1.0, color: Color(0xFFEFEFEF)),
                Material(
                    color: Colors.white,
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                                children: <Widget>[
                                  Text(S.of(context).selection_group,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween)))),
                Container(height: 1.0, color: Color(0xFFEFEFEF)),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10.0),
                    itemBuilder: (_, index) => ItemContact(
                        user: provider.friends[index],
                        isShowCheck: true,
                        onTap: () {
                          Provider.of<ContactProvider>(context, listen: false)
                              .toggleContact(provider.friends[index]);
                        }),
                    itemCount: provider.friends.length)
              ]),
            ),
          )
        ]));
  }
}
