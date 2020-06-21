import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

import '../../provider/index.dart';
import '../../commons/index.dart';

import '../../model/user.dart';

import '../../widgets/index.dart';

import '../../generated/i18n.dart';

import 'friend.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  List<UserBean> contacts = [];

  int _suspensionHeight = 25;
  String _suspensionTag = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<ContactProvider>(context, listen: false).getFriends());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ContactProvider>(
        builder: (context, ContactProvider contacts, child) {
      return Scaffold(
          appBar: AppBar(title: Text(S.of(context).tab_contacts)),
          body: LoaderContainer(
              contentView: AzListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  header: AzListViewHeader(
                      builder: (BuildContext context) => ContactHeaderView(),
                      height: 200),
                  isUseRealIndex: true,
                  itemHeight: 60,
                  suspensionHeight: _suspensionHeight,
                  data: contacts.friends,
                  itemBuilder: (_, model) => buildItemContactView(model),
                  indexBarBuilder: (BuildContext context, List<String> tags,
                          IndexBarTouchCallback onTouch) =>
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  color: Colors.grey[300], width: .5)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: IndexBar(
                                  data: tags,
                                  itemHeight: 20,
                                  onTouch: (details) => onTouch(details)))),
                  suspensionWidget: SuspensionTag(
                      susTag: _suspensionTag, susHeight: _suspensionHeight),
                  onSusTagChanged: (value) => setState(() => _suspensionTag = value)),
              loaderState: contacts.state));
    });
  }

  Widget buildItemContactView(UserBean model) {
    String susTag = model.getSuspensionTag();
    return Column(children: <Widget>[
      Visibility(
          visible: model.isShowSuspension,
          child: SuspensionTag(susTag: susTag, susHeight: _suspensionHeight)),
      ItemContact(
          user: model,
          onTap: () => pushNewPage(
              context, FriendInfoPage(identifier: model.identifier)))
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
