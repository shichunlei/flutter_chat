import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/login/update_password.dart';

import '../../provider/index.dart';
import '../../generated/i18n.dart';
import '../../commons/index.dart';

/// 账号与安全设置
class SafePage extends StatefulWidget {
  const SafePage({Key key}) : super(key: key);

  @override
  createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
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
        appBar: AppBar(title: Text(S.of(context).account_security)),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              SelectedText(
                  title: S.of(context).wechat_id,
                  content: Provider.of<UserProvider>(context).identifier,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).phone,
                  onTap: () {},
                  content: Provider.of<UserProvider>(context).identifier,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  title: S.of(context).wechat_password,
                  onTap: () => pushNewPage(context, UpdatePasswordPage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).voiceprint,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  title: S.of(context).emergency_contacts,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).manage_devices,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).more_setting,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  title: S.of(context).security_center,
                  subTitle: S.of(context).issues,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
            ])));
  }
}
