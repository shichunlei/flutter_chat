import 'package:flutter/material.dart';
import 'package:flutter_chat/generated/i18n.dart';
import '../../commons/index.dart';

class AboutWechatPage extends StatefulWidget {
  const AboutWechatPage({Key key}) : super(key: key);

  @override
  createState() => _AboutWechatPageState();
}

/// 关于微信
class _AboutWechatPageState extends State<AboutWechatPage> {
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
        backgroundColor: Colors.white,
        appBar: AppBar(elevation: 0.0),
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 18.0, top: 50, left: 20, right: 20),
          child: Column(children: [
            Image.asset('images/Icon-logo.png', height: 70, width: 70),
            Text(S.of(context).wechat,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(S.of(context).version("7.0.15"),
                style: Theme.of(context).textTheme.subtitle2),
            SizedBox(height: 50),
            Container(height: .5, color: Colors.grey[200]),
            SelectedText(
                title: S.of(context).fresh,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: .5, color: Colors.grey[200]),
            SelectedText(
                title: S.of(context).complaint,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: .5, color: Colors.grey[200]),
            SelectedText(
                title: S.of(context).check_updates,
                onTap: () {},
                margin: EdgeInsets.only(left: 20, right: 5)),
            Container(height: .5, color: Colors.grey[200]),
            Spacer(),
            Text(S.of(context).terms_service,
                style: TextStyle(color: Colors.blue, fontSize: 13)),
            Text(S.of(context).policy,
                style: TextStyle(color: Colors.blue, fontSize: 13)),
            Text('XX公司 版权所有',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            Text('Copyright @ 2011-2020 Chingtech',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            Text('All Rights Reserved.',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ]),
        ));
  }
}
