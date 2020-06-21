import 'package:flutter/material.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import '../../provider/index.dart';

/// 字体大小设置
class TextSizeSettingPage extends StatefulWidget {
  const TextSizeSettingPage({Key key}) : super(key: key);

  @override
  createState() => _TextSizeSettingPageState();
}

class _TextSizeSettingPageState extends State<TextSizeSettingPage> {
  double textSize = 16.0;

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
        appBar: AppBar(title: Text(S.of(context).textSize)),
        body: Column(children: [
          Expanded(
            child: ListView(children: <Widget>[
              Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        constraints:
                            BoxConstraints(maxWidth: Utils.width - 100),
                        decoration: BoxDecoration(
                            color: sendMessageColor,
                            borderRadius: borderRadius(MessageSendType.send)),
                        padding: EdgeInsets.all(8.0),
                        child: Text('预览字体大小',
                            style: TextStyle(
                                color: Colors.white, fontSize: textSize))),
                    ImageView(
                        '${Provider.of<UserProvider>(context).userInfo.extras["avatarUrl"]}',
                        radius: 5,
                        height: 35,
                        width: 35,
                        placeholder: 'images/header.jpeg')
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start),
              SizedBox(height: 10),
              Row(children: <Widget>[
                ImageView('images/Icon-logo.png',
                    radius: 5,
                    height: 35,
                    width: 35,
                    placeholder: 'images/header.jpeg',
                    imageType: ImageType.assets),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    constraints: BoxConstraints(maxWidth: Utils.width - 100),
                    decoration: BoxDecoration(
                        color: Color(0xFFEEF7FD),
                        borderRadius: borderRadius(MessageSendType.receive)),
                    padding: EdgeInsets.all(8.0),
                    child: Text('拖动下面滑块，可设置字体大小',
                        style: TextStyle(
                            color: Color(0xff666666), fontSize: textSize)))
              ], crossAxisAlignment: CrossAxisAlignment.start),
              SizedBox(height: 10),
              Row(children: <Widget>[
                ImageView('images/Icon-logo.png',
                    radius: 5,
                    height: 35,
                    width: 35,
                    placeholder: 'images/header.jpeg',
                    imageType: ImageType.assets),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    constraints: BoxConstraints(maxWidth: Utils.width - 100),
                    decoration: BoxDecoration(
                        color: Color(0xFFEEF7FD),
                        borderRadius: borderRadius(MessageSendType.receive)),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        '设置后，会改变聊天、菜单和朋友圈的字体大小。如果在使用过程中存在问题或意见，课反馈给微信团队',
                        style: TextStyle(
                            color: Color(0xff666666), fontSize: textSize)))
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ], padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
          ),
          Container(
              color: Colors.white,
              child: Column(children: [
                Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text('A', style: TextStyle(fontSize: 12)))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text('标准', style: TextStyle(fontSize: 16)))),
                  Expanded(
                      flex: 5,
                      child: Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: Text('A', style: TextStyle(fontSize: 40)))),
                ], crossAxisAlignment: CrossAxisAlignment.end),
                Slider(
                    value: textSize,
                    onChanged: (value) {
                      setState(() {
                        textSize = value;
                      });

                      print("=============>$value");
                    },
                    max: 40,
                    min: 12,
                    divisions: 7)
              ]))
        ]));
  }
}
