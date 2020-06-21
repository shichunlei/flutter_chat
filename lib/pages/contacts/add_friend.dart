import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/search.dart';
import '../../generated/i18n.dart';

import '../../commons/index.dart';
import '../../provider/index.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key key}) : super(key: key);

  @override
  createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
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
        appBar: AppBar(title: Text(S.of(context).add_friend)),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: FlatButton(
                    onPressed: () => pushNewPage(context, SearchPage()),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.search, size: 20),
                          Text('微信号/手机号')
                        ]),
                    color: Colors.white)),
            Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                child: Row(children: <Widget>[
                  Text(S.of(context).id(
                      Provider.of<UserProvider>(context).identifier)),
                  SizedBox(width: 5),
                  IconButton(
                      icon: Image.asset('images/icon_qr.png',
                          width: 20, height: 20),
                      onPressed: () => showQRNameCardDialog(
                          context,
                          Provider.of<UserProvider>(context, listen: false)
                              .identifier,
                          title: S.of(context).my_qr_code))
                ], mainAxisAlignment: MainAxisAlignment.center)),
            SelectedText(
                leading: ImageView('images/icon_reda.png',
                    height: 35,
                    width: 35,
                    imageType: ImageType.assets,
                    radius: 3),
                margin: const EdgeInsets.only(
                    right: 10.0, left: 18.0, top: 5, bottom: 5),
                title: '雷达加好友',
                subTitle: '添加身边的朋友',
                onTap: () {}),
            SizedBox(height: 1),
            SelectedText(
                margin: const EdgeInsets.only(
                    right: 10.0, left: 18.0, top: 5, bottom: 5),
                leading: ImageView('images/icon_addgroup.png',
                    height: 35,
                    width: 35,
                    imageType: ImageType.assets,
                    radius: 3),
                title: '面对面建群',
                subTitle: '与身边的朋友进入同一个群',
                onTap: () {}),
            SizedBox(height: 1),
            SelectedText(
                margin: const EdgeInsets.only(
                    right: 10.0, left: 18.0, top: 5, bottom: 5),
                leading: ImageView('images/icon_scanqr.png',
                    height: 35,
                    width: 35,
                    imageType: ImageType.assets,
                    radius: 3),
                title: '扫一扫',
                subTitle: '扫二维码名片',
                onTap: () {}),
            SizedBox(height: 1),
            SelectedText(
                margin: const EdgeInsets.only(
                    right: 10.0, left: 18.0, top: 5, bottom: 5),
                leading: ImageView('images/icon_addFriend.png',
                    height: 35,
                    width: 35,
                    imageType: ImageType.assets,
                    radius: 3),
                title: '手机联系人',
                subTitle: '添加或邀请通讯录中的朋友',
                onTap: () {}),
            SizedBox(height: 1),
            SelectedText(
                margin: const EdgeInsets.only(
                    right: 10.0, left: 18.0, top: 5, bottom: 5),
                leading: ImageView('images/icon_offical.png',
                    height: 35,
                    width: 35,
                    imageType: ImageType.assets,
                    radius: 3),
                title: '公众号',
                subTitle: '获取更多资讯和服务',
                onTap: () {}),
            SizedBox(height: 1),
            SelectedText(
                margin: const EdgeInsets.only(
                    right: 10.0, left: 18.0, top: 5, bottom: 5),
                leading: ImageView('images/icon_search_wework.png',
                    height: 35,
                    width: 35,
                    imageType: ImageType.assets,
                    radius: 3),
                title: '企业微信联系人',
                subTitle: '通过手机号搜索企业微信用户',
                onTap: () {})
          ]),
        ));
  }
}
