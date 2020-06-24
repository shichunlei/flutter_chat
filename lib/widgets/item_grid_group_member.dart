import 'package:flutter/material.dart';

import '../commons/index.dart';
import '../utils/jpush_util.dart';

class ItemGridGroupMember extends StatelessWidget {
  final JMGroupMemberInfo member;
  final bool showNickName;
  final VoidCallback onTap;
  final bool showAddWidget;
  final VoidCallback onAddTap;
  final bool showRemoveWidget;
  final VoidCallback onRemoveTap;
  final double height;
  final double width;

  const ItemGridGroupMember(
      {Key key,
      @required this.member,
      this.showNickName: false,
      this.onTap,
      this.showAddWidget: false,
      this.onAddTap,
      this.showRemoveWidget: false,
      this.onRemoveTap,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showAddWidget) {
      /// 添加
      return GestureDetector(
          onTap: onAddTap,
          child: Column(children: <Widget>[
            Container(
                height: height ?? (Utils.width - 60) / 5.0,
                width: width ?? (Utils.width - 60) / 5.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500], width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.add, size: 50, color: Colors.grey[500]))
          ]));
    }

    if (showRemoveWidget) {
      /// 移除
      return GestureDetector(
          onTap: onRemoveTap,
          child: Column(children: <Widget>[
            Container(
                height: height ?? (Utils.width - 60) / 5.0,
                width: width ?? (Utils.width - 60) / 5.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500], width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.remove, size: 50, color: Colors.grey[500]))
          ]));
    }

    return Material(
        type: MaterialType.transparency,
        child: InkWell(
            onTap: onTap,
            child: Container(
              child: Column(children: [
                ImageView('${member.user.extras["avatarUrl"]}',
                    height: height ?? (Utils.width - 60) / 5.0,
                    width: width ?? (Utils.width - 60) / 5.0,
                    radius: 5,
                    placeholder: 'images/header.jpeg'),
                Text(
                    showNickName
                        ? '${Utils.isEmpty(member.groupNickname) ? JPushUtil.getName(member.user) : member.groupNickname}'
                        : JPushUtil.getName(member.user),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
              ]),
            )));
  }
}
