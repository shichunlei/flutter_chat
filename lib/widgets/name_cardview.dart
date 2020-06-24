import '../utils/utils.dart';

import '../generated/i18n.dart';

import '../commons/ui/image_view.dart';

import '../model/user.dart';

import 'package:flutter/material.dart';

/// 名片弹框
///
class NameCardDialog extends Dialog {
  final String avatar;
  final String name;
  final UserBean cardUser;
  final Function(String message) callBack;

  NameCardDialog({
    Key key,
    this.name,
    this.avatar,
    this.cardUser,
    this.callBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(children: [
          NameCardView(
              name: name,
              cardUser: cardUser,
              callBack: callBack,
              avatar: avatar)
        ], mainAxisAlignment: MainAxisAlignment.center));
  }
}

class NameCardView extends StatefulWidget {
  const NameCardView(
      {Key key, @required this.cardUser, this.callBack, this.name, this.avatar})
      : super(key: key);

  final UserBean cardUser;
  final Function(String message) callBack;
  final String avatar;
  final String name;

  @override
  createState() => _NameCardViewState();
}

class _NameCardViewState extends State<NameCardView> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Utils.width * 0.85,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Column(children: [
          Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${S.of(context).send_to}:',
                        style: TextStyle(color: Colors.black)),
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      ImageView(widget.avatar,
                          radius: 20, placeholder: 'images/header.jpeg'),
                      SizedBox(width: 20),
                      Text(widget.name),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right)
                    ]),
                    SizedBox(height: 20),
                    Text(S.of(context).name_card(widget.cardUser?.name)),
                    SizedBox(height: 10),
                    TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: S.of(context).hint_leave_message,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Color(0xfff7f7f7))),
                  ])),
          Container(
              height: 1.0,
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 5)),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                    child: FlatButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: Text(S.of(context).cancel))),
                Expanded(
                    child: FlatButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                          widget.callBack(controller.text.toString());
                        },
                        child: Text(S.of(context).send_out,
                            style: TextStyle(color: Colors.green))))
              ]))
        ]));
  }
}
