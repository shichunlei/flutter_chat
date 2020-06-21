import 'package:flutter/material.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';

class AddMeWayPage extends StatefulWidget {
  const AddMeWayPage({Key key}) : super(key: key);

  @override
  createState() => _AddMeWayPageState();
}

class _AddMeWayPageState extends State<AddMeWayPage> {
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
        appBar: AppBar(title: Text(S.of(context).methods_for_friending_me)),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 10),
                child: Text(S.of(context).find_me_tip)),
            SwitchTitleView(
                padding: EdgeInsets.only(right: 5, left: 20),
                title: S.of(context).wechat_id,
                onChanged: (bool value) {},
                isChecked: true),
            SwitchTitleView(
                padding: EdgeInsets.only(right: 5, left: 20),
                title: S.of(context).mobile,
                onChanged: (bool value) {},
                isChecked: true,
                margin: EdgeInsets.symmetric(vertical: .5)),
            SwitchTitleView(
                padding: EdgeInsets.only(right: 5, left: 20),
                title: S.of(context).qq,
                onChanged: (bool value) {},
                isChecked: true),
            Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                child: Text(S.of(context).not_find_me_tip)),
            Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Text(S.of(context).add_me)),
            SwitchTitleView(
                padding: EdgeInsets.only(right: 5, left: 20),
                title: S.of(context).group_chat,
                onChanged: (bool value) {},
                isChecked: true),
            SwitchTitleView(
                padding: EdgeInsets.only(right: 5, left: 20),
                title: S.of(context).qr_code,
                onChanged: (bool value) {},
                isChecked: true,
                margin: EdgeInsets.symmetric(vertical: .5)),
            SwitchTitleView(
                padding: EdgeInsets.only(right: 5, left: 20),
                title: S.of(context).contact_card,
                onChanged: (bool value) {},
                isChecked: true),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ));
  }
}
