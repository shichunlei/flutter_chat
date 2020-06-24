import 'package:flutter/material.dart';
import 'package:flutter_chat/provider/index.dart';

import '../commons/index.dart';
import '../generated/i18n.dart';
import '../model/notify.dart';
import '../pages/contacts/friend.dart';

class ItemFriendNotify extends StatelessWidget {
  final Notify notify;
  final bool isReceive;

  const ItemFriendNotify({Key key, this.notify, this.isReceive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: InkWell(
            onTap: () => pushNewPage(
                context,
                FriendInfoPage(
                    identifier: isReceive
                        ? notify.from.identifier
                        : notify.user.identifier)),
            onLongPress: () {},
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(children: <Widget>[
                  ImageView(
                      isReceive ? notify.from.avatarUrl : notify.user.avatarUrl,
                      height: 40,
                      width: 40,
                      radius: 8,
                      placeholder: 'images/header.jpeg'),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(isReceive ? notify.from.name : notify.user.name,
                            style: Theme.of(context).textTheme.subtitle1),
                        Text('${notify.reason}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.grey)),
                      ])),
                  buildStateView(context, notify.status)
                ], crossAxisAlignment: CrossAxisAlignment.center))));
  }

  Widget buildStateView(context, String status) {
    switch (status) {
      case "invite_received":
        return isReceive
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MaterialButton(
                      minWidth: 50,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        /// 同意添加好友
                        Provider.of<ContactProvider>(context, listen: false)
                            .acceptInvitation(
                                notify.from.identifier, notify.user.identifier);
                      },
                      child: Text(S.of(context).add,
                          style: TextStyle(color: Colors.white)),
                      color: Colors.green),
                  SizedBox(width: 5),
                  MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 50,
                      onPressed: () {
                        /// 拒绝好友申请
                        Provider.of<ContactProvider>(context, listen: false)
                            .declineInvitation(notify.from.identifier, "拒绝好友申请",
                                notify.user.identifier);
                      },
                      child: Text("拒绝", style: TextStyle(color: Colors.white)),
                      color: Colors.red)
                ],
              )
            : Text('等待验证');
        break;
      case "invite_accepted":
        return Text('已添加');
        break;
      case "invite_declined":
        return Text('已拒绝');
        break;
      default:
        return Container();
        break;
    }
  }
}
