import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/zone_code.dart';

import '../../generated/i18n.dart';

import '../../commons/index.dart';

import 'area_code.dart';
import 'forget_password.dart';
import 'next_login.dart';

class PhoneLoginFirstPage extends StatefulWidget {
  const PhoneLoginFirstPage({Key key}) : super(key: key);

  @override
  createState() => _PhoneLoginFirstPageState();
}

class _PhoneLoginFirstPageState extends State<PhoneLoginFirstPage> {
  TextEditingController phoneController = TextEditingController();

  // 手机区号对应的国家名称
  String _zoneCodeName = '中国大陆';
  String _zoneCode = '+86';

  @override
  void initState() {
    super.initState();

    phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(leading: CloseButton(), elevation: 0.0),
        body: SingleChildScrollView(
            child: Container(
                height: Utils.height - Utils.navigationBarHeight,
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  SizedBox(height: 50),
                  Text(S.of(context).mobileNumberLogin, style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(children: <Widget>[
                        Container(child: Text('国家/地区'), width: 70),
                        SizedBox(width: 20),
                        Expanded(
                            child: GestureDetector(
                                child: Text(_zoneCodeName),
                                onTap: () {
                                  pushNewPage(context, ZoneCodePage(),
                                      callBack: (ZoneCode zoneCode) {
                                    if (zoneCode != null) {
                                      _zoneCode = "+${zoneCode.code}";
                                      _zoneCodeName = zoneCode.name;

                                      setState(() {});
                                    }
                                  });
                                })),
                        Icon(Icons.arrow_forward_ios, size: 10)
                      ])),
                  Container(height: .5, color: Colors.grey[300]),
                  Row(children: <Widget>[
                    Container(
                        width: 70,
                        child: Text(_zoneCode),
                        alignment: Alignment.center),
                    Container(height: 40, width: .5, color: Colors.grey[300]),
                    Expanded(
                        child: TextField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: colorGrey_6, fontSize: 14),
                            controller: phoneController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(context).enterPhoneNumber,
                                hintStyle:
                                    TextStyle(color: colorGrey_9, fontSize: 14),
                                fillColor: Colors.transparent,
                                filled: true),
                            inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11)
                        ]))
                  ]),
                  Container(
                      height: .5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(bottom: 30)),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: '用', style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: '微信号',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async =>
                              pushNewPage(context, PhoneLoginFirstPage())),
                    TextSpan(text: '/', style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: 'QQ号码',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async =>
                              pushNewPage(context, PhoneLoginFirstPage())),
                    TextSpan(text: '/', style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: '电子邮箱',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async =>
                              pushNewPage(context, PhoneLoginFirstPage())),
                    TextSpan(text: '登录', style: TextStyle(color: Colors.grey)),
                  ], style: TextStyle(color: Colors.blue))),
                  Container(
                      margin: EdgeInsets.only(top: 35.0),
                      width: double.infinity,
                      height: 40.0,
                      child: FlatButton(
                          onPressed: phoneController.text.length == 11
                              ? () {
                                  String username =
                                      phoneController.text.toString();

                                  if (Utils.isNotEmpty(username)) {
                                    /// 隐藏键盘
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    pushNewPage(
                                        context,
                                        PhoneLoginNextPage(
                                            phone: username, code: _zoneCode));
                                  }
                                }
                              : null,
                          child: Text('${S.of(context).next}',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.green,
                          disabledColor: Colors.green[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)))),
                  Spacer(),
                  Container(
                      margin: EdgeInsets.only(bottom: 30),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '找回密码',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async =>
                                  pushNewPage(context, ForgetPasswordPage())),
                        TextSpan(
                            text: '    |    ',
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: '更多选项',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {}),
                      ], style: TextStyle(color: Colors.blue))))
                ], crossAxisAlignment: CrossAxisAlignment.start))));
  }
}
