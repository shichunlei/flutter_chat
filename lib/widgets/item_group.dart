import 'package:flutter/material.dart';
import '../commons/index.dart';

import '../provider/index.dart';

class ItemGroup extends StatefulWidget {
  final String id;

  const ItemGroup({Key key, @required this.id}) : super(key: key);

  @override
  createState() => _ItemGroupState();
}

class _ItemGroupState extends State<ItemGroup>
    with AutomaticKeepAliveClientMixin {
  JMGroupInfo groupInfo;

  @override
  void initState() {
    super.initState();

    getGroupInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
        color: Colors.white,
        child: InkWell(
            child: Container(
                child: Row(children: <Widget>[
                  ImageView(groupHeaderImage,
                      radius: 5,
                      height: 35,
                      width: 35,
                      placeholder: 'images/header.jpeg'),
                  SizedBox(width: 20),
                  Text('${groupInfo?.name ?? ""}'),
                ]),
                padding: EdgeInsets.all(15.0)),
            onTap: () => Provider.of<ChatProvider>(context, listen: false)
                .jumpToConversationMessage(context, groupInfo.targetType)));
  }

  @override
  bool get wantKeepAlive => true;

  void getGroupInfo() async {
    await jMessage
        .getGroupInfo(id: widget.id)
        .then((JMGroupInfo value) => setState(() => groupInfo = value),
            onError: (error) {
      print('getGroupInfo error => ${error.toString()}');
    });
  }
}
