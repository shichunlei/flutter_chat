import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/model/user.dart';
import 'package:flutter_chat/provider/index.dart';
import 'package:mobsms/mobsms.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import '../home.dart';
import 'forget_password.dart';
import 'freeze_account.dart';

class PhoneLoginNextPage extends StatefulWidget {
  final String code;
  final String phone;

  const PhoneLoginNextPage({Key key, @required this.code, @required this.phone})
      : super(key: key);

  @override
  createState() => _PhoneLoginNextPageState();
}

class _PhoneLoginNextPageState extends State<PhoneLoginNextPage> {
  bool pwsLogin = false;

  TextEditingController controller = TextEditingController();

  Timer timer;

  /// 倒计时数值
  var _countdownTime = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String handleCodeAutoSizeText() {
    if (_countdownTime > 0)
      return '$_countdownTime s后重新发送';
    else
      return '获取验证码';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                height: Utils.height,
                padding:
                    EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 30),
                child: Column(children: [
                  ImageView(
                      'http://pic2.zhimg.com/50/v2-fb824dbb6578831f7b5d92accdae753a_hd.jpg',
                      height: 70.0,
                      width: 70.0,
                      radius: 8,
                      placeholder: 'images/header.jpeg'),
                  SizedBox(height: 20),
                  Text('${widget.code} ${Utils.formatMobile344(widget.phone)}'),
                  SizedBox(height: 30),
                  Row(children: <Widget>[
                    Container(child: Text(pwsLogin ? '密码' : '验证码'), width: 50),
                    Expanded(
                        child: TextField(
                            style: TextStyle(color: colorGrey_6, fontSize: 14),
                            controller: controller,
                            keyboardType: pwsLogin
                                ? TextInputType.visiblePassword
                                : TextInputType.number,
                            obscureText: pwsLogin,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: pwsLogin ? '请输入密码' : "请输入验证码",
                                hintStyle:
                                    TextStyle(color: colorGrey_9, fontSize: 14),
                                fillColor: Colors.transparent,
                                filled: true),
                            inputFormatters: pwsLogin
                                ? []
                                : <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6)
                                  ])),
                    Visibility(
                        visible: !pwsLogin,
                        child: Container(
                            width: 120,
                            child: OutlineButton(
                                textColor: Colors.green,
                                disabledTextColor: Colors.green[200],
                                padding: EdgeInsets.zero,
                                onPressed: _countdownTime > 0
                                    ? null
                                    : () => startCountdown(),
                                child:
                                    Text(handleCodeAutoSizeText(), maxLines: 1),
                                borderSide: BorderSide(color: Colors.green))))
                  ]),
                  Container(
                      height: .5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(bottom: 30)),
                  SizedBox(height: 30),
                  GestureDetector(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(pwsLogin ? '验证码登录' : '密码登录',
                              style: TextStyle(color: Colors.blue))),
                      onTap: () => setState(() {
                            controller.text = '';
                            pwsLogin = !pwsLogin;

                            _countdownTime = 0;
                            timer?.cancel();
                            timer = null;

                            /// 隐藏键盘
                            FocusScope.of(context).requestFocus(FocusNode());
                          })),
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.only(top: 35.0),
                      width: double.infinity,
                      height: 40.0,
                      child: FlatButton(
                          onPressed: () {
                            /// 隐藏键盘
                            FocusScope.of(context).requestFocus(FocusNode());
                            showLoadingDialog(context);
                            if (pwsLogin) {
                              login(widget.phone, password: controller.text);
                            } else {
                              /// 提交验证码
                              Smssdk.commitCode(widget.phone, widget.code,
                                  controller.text.toString(),
                                  (dynamic ret, Map err) {
                                if (err != null) {
                                  print('err => ${err.toString()}');
                                  Navigator.maybePop(context);
                                  Toast.show(context, err['msg']);
                                } else {
                                  print('ret => ${ret.toString()}');
                                  // 验证通过
                                  login(widget.phone, code: controller.text);
                                }
                              });
                            }
                          },
                          child: Text('${S.of(context).sign_in}',
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
                            text: '紧急冻结',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async =>
                                  pushNewPage(context, FreezeAccountPage())),
                        TextSpan(
                            text: '    |    ',
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: '更多选项',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {}),
                      ], style: TextStyle(color: Colors.blue))))
                ]))));
  }

  /// 倒计时方法
  startCountdown() {
    /// 倒计时时间
    _countdownTime = 60;

    if (timer == null) {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (_countdownTime < 1) {
          timer?.cancel();
          timer = null;
        } else {
          setState(() => _countdownTime -= 1);
        }
      });
    }

    /// 获取文本验证码
    Smssdk.getTextCode(widget.phone, widget.code, '', (dynamic ret, Map err) {
      if (err != null) {
        Toast.show(context, '${err.toString()}');
        print("err => ${err.toString()}");
      } else {
        Toast.show(context, '获取验证码成功!');

        print("ret => " "${ret.toString()}");
      }
    });
  }

  void login(String username, {String password = "", String code = ""}) async {
    String urlPath;
    Map<String, dynamic> params = {};

    params["mobile"] = username;

    if (password == "") {
      /// 验证码登录
      urlPath = APIs.LOGIN_QUICKLY;
      params["code"] = code;
    }

    if (code == "") {
      /// 密码登录
      urlPath = APIs.LOGIN;
      params["password"] = password;
    }

    await HttpUtils().post(
      urlPath,
      (data) async {
        UserBean user = UserBean.fromMap(data);

        await jMessage
            .login(
                username: user.identifier, password: Config.JMESSAGE_PASSWORD)
            .then((value) {
          Navigator.maybePop(context);
          Toast.show(context, S.of(context).loginSuccess);
          SpUtil.setBool(Config.IS_LOGIN, true);
          Provider.of<UserProvider>(context, listen: false).getUserInfo();

          pushAndRemovePage(context, HomePage());
        }, onError: (error) {
          print(error.toString());
          if (error is PlatformException) {
            Toast.show(context, error.message);
            if (error.code == '801004') {
              // 密码错误

            } else if (error.code == '801003') {
              // 账号不存在

            }
          } else {
            Toast.show(context, S.of(context).loginFailed);
          }

          Navigator.maybePop(context);
        });
      },
      params: FormData.fromMap(params),
      errorCallBack: (error) {
        Toast.show(context, error.message);
        Navigator.of(context).pop();
      },
    );
  }
}
