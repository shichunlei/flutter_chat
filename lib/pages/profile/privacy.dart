import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/contacts/blacklist.dart';
import 'package:flutter_chat/provider/index.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import 'add_me_way.dart';
import 'hide_posts.dart';

/// 隐私设置
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key key}) : super(key: key);

  @override
  createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String viewable = '';

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
    Map<String, String> _map = {
      "half_year": S.of(context).half_year,
      "one_month": S.of(context).one_month,
      "three_days": S.of(context).three_days,
      "all": S.of(context).all
    };

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).privacy)),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, bottom: 5),
                  child: Text(S.of(context).tab_contacts)),
              SwitchTitleView(
                  padding: EdgeInsets.only(right: 5, left: 20),
                  title: S.of(context).require_friend_request,
                  onChanged: (bool value) {},
                  isChecked: false),
              SizedBox(height: .5),
              SwitchTitleView(
                  padding: EdgeInsets.only(right: 5, left: 20),
                  title: S.of(context).find_mobile_contacts,
                  onChanged: (bool value) {},
                  isChecked: false,
                  subTitle: S.of(context).enabling_tip),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () => pushNewPage(context, AddMeWayPage()),
                  title: S.of(context).methods_for_friending_me,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () => pushNewPage(context, BlacklistPage()),
                  title: S.of(context).blocked_list,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, bottom: 5),
                  child: Text(S.of(context).moments_and_time_capsule)),
              SelectedText(
                  onTap: () => pushNewPage(context, HidePostsPage(type: "my")),
                  title: S.of(context).hide_my_posts,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () =>
                      pushNewPage(context, HidePostsPage(type: "their")),
                  title: S.of(context).hide_their_posts,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SwitchTitleView(
                  padding: EdgeInsets.only(right: 5, left: 20),
                  title: S.of(context).make_last_moments_public,
                  onChanged: (bool value) {},
                  isChecked: false),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () => showViewableDialog(context, (value) {
                        setState(() {
                          viewable = _map["$value"];
                        });
                        Provider.of<ConfigProvider>(context, listen: false)
                            .setViewable(value);
                        Navigator.maybePop(context);
                      }),
                  content: viewable,
                  title: S.of(context).viewable,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: 5),
              SelectedText(
                  onTap: () {},
                  title: S.of(context).authorizations,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: 15)
            ], crossAxisAlignment: CrossAxisAlignment.start)));
  }
}
