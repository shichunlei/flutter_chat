import 'package:flutter/material.dart';
import '../login/input_phone.dart';

import '../../generated/i18n.dart';
import '../../commons/index.dart';

import 'general.dart';
import 'privacy.dart';
import 'safe.dart';
import 'about_wechat.dart';

/// 设置
class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
        appBar: AppBar(title: Text(S.of(context).settings)),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              SelectedText(
                  title: S.of(context).account_security,
                  onTap: () => pushNewPage(context, SafePage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: 5),
              SelectedText(
                  title: S.of(context).notifications,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).do_not_disturb,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).chats,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).privacy,
                  onTap: () => pushNewPage(context, PrivacyPage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).general,
                  onTap: () => pushNewPage(context, GeneralPage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: 5),
              SelectedText(
                  title: S.of(context).about,
                  onTap: () => pushNewPage(context, AboutWechatPage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).help_feedback,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: 5),
              SelectedText(
                  title: S.of(context).wechat_services,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: FlatButton(
                      color: Colors.white,
                      onPressed: () {
                        SpUtil.clear();
                        pushAndRemovePage(context, PhoneLoginFirstPage());
                      },
                      child: Text(S.of(context).switch_account))),
              Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(top: 5, bottom: 30),
                  child: FlatButton(
                      color: Colors.white,
                      onPressed: () => showLogoutAccountDialog(context),
                      child: Text(S.of(context).logout)))
            ])));
  }
}
