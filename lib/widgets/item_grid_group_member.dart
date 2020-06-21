import 'package:flutter/material.dart';

import '../commons/index.dart';
import '../utils/jpush_util.dart';

class ItemGridGroupMember extends StatelessWidget {
  final JMGroupMemberInfo member;
  final bool showNickName;
  final VoidCallback onTap;

  const ItemGridGroupMember(
      {Key key, @required this.member, this.showNickName: false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: InkWell(
            onTap: onTap,
            child: Container(
              child: Column(children: [
                ImageView('${member.user.extras["avatarUrl"]}',
                    height: (Utils.width - 60) / 5.0,
                    width: (Utils.width - 60) / 5.0,
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
