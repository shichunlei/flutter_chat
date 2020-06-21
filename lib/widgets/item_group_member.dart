import 'package:flutter/material.dart';

import '../commons/index.dart';
import '../utils/jpush_util.dart';

class ItemGroupMember extends StatefulWidget {
  final JMGroupMemberInfo member;
  final Function(bool isCheck) callBack;

  const ItemGroupMember({Key key, this.member, this.callBack})
      : super(key: key);

  @override
  createState() => _ItemGroupMemberState();
}

class _ItemGroupMemberState extends State<ItemGroupMember> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: isCheck,
            onChanged: (value) {
              widget.callBack(value);

              setState(() {
                isCheck = value;
              });
            },
            title: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(children: <Widget>[
                  ImageView(widget.member.user.extras["avatarUrl"],
                      width: 40,
                      height: 40,
                      radius: 10),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(Utils.isEmpty(widget.member.groupNickname)
                          ? JPushUtil.getName(widget.member.user)
                          : widget.member.groupNickname))
                ]))));
  }
}
