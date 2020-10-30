import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import '../../model/user.dart';
import '../../model/zone_code.dart';
import '../../provider/index.dart';
import '../home.dart';
import '../webview.dart';
import 'area_code.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  FocusNode phoneFocusNode = FocusNode();
  FocusNode pwdFocusNode = FocusNode();

  // 手机区号对应的国家名称
  String _zoneCodeName = '中国大陆';
  String _zoneCode = '+86';

  bool isCheck = false;

  String imgPath = '';

  @override
  void initState() {
    super.initState();

    phoneController.addListener(() {
      setState(() {});
    });

    pwdController.addListener(() {
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
                  Text(S.of(context).numberRegister,
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(
                      child: Row(children: <Widget>[
                        Container(
                            height: 40,
                            width: 70,
                            child: Text(S.of(context).name),
                            alignment: Alignment.centerLeft),
                        Expanded(
                            child: TextField(
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(phoneFocusNode),
                                style:
                                    TextStyle(color: colorGrey_6, fontSize: 14),
                                controller: nameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: S.of(context).enterNickName,
                                    hintStyle: TextStyle(
                                        color: colorGrey_9, fontSize: 14),
                                    fillColor: Colors.transparent,
                                    filled: true)))
                      ]),
                    ),
                    Material(
                        color: Colors.grey[200],
                        child: InkWell(
                            onTap: () {},
                            child: Container(
                                height: 60.0,
                                width: 60.0,
                                child: Stack(children: <Widget>[
                                  Positioned(
                                      child: Icon(Icons.add_a_photo),
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0)
                                ]))))
                  ], crossAxisAlignment: CrossAxisAlignment.end),
                  Container(height: .5, color: Colors.grey[300]),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(children: <Widget>[
                        Container(
                            child: Text('国家/地区'),
                            width: 70,
                            alignment: Alignment.centerLeft),
                        SizedBox(width: 10),
                        Expanded(
                            child: GestureDetector(
                                child: Text(
                                  "$_zoneCodeName ($_zoneCode)",
                                  style: TextStyle(color: Colors.green),
                                ),
                                onTap: () =>
                                    pushNewPage(context, ZoneCodePage(),
                                        callBack: (ZoneCode zoneCode) {
                                      if (zoneCode != null) {
                                        _zoneCode = "+${zoneCode.code}";
                                        _zoneCodeName = zoneCode.name;

                                        setState(() {});
                                      }
                                    }))),
                        Icon(Icons.arrow_forward_ios, size: 10)
                      ])),
                  Container(height: .5, color: Colors.grey[300]),
                  Row(children: <Widget>[
                    Container(
                        height: 40,
                        width: 70,
                        child: Text(S.of(context).mobile),
                        alignment: Alignment.centerLeft),
                    Expanded(
                        child: TextField(
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(pwdFocusNode),
                            focusNode: phoneFocusNode,
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
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11)
                        ]))
                  ]),
                  Container(height: .5, color: Colors.grey[300]),
                  Row(children: <Widget>[
                    Container(
                        height: 40,
                        width: 70,
                        child: Text('密码'),
                        alignment: Alignment.centerLeft),
                    Expanded(
                        child: TextField(
                            focusNode: pwdFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            controller: pwdController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(context).enterPassword,
                                hintStyle:
                                    TextStyle(color: colorGrey_9, fontSize: 14),
                                fillColor: Colors.transparent,
                                filled: true),
                            obscureText: true))
                  ]),
                  Container(
                      height: .5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(bottom: 30)),
                  Row(children: <Widget>[
                    Checkbox(
                        onChanged: (bool value) =>
                            setState(() => isCheck = value),
                        value: isCheck),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: S.of(context).readAgree,
                          style: TextStyle(color: Colors.grey[500])),
                      TextSpan(
                          text: S.of(context).terms_service,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async => pushNewPage(
                                context,
                                WebViewPage(
                                    title: S.of(context).terms_service,
                                    url: S.of(context).protocolUrl)),
                          style: TextStyle(color: Colors.blue)),
                    ], style: TextStyle(color: Colors.blue)))
                  ]),
                  Container(
                      margin: EdgeInsets.only(top: 3.0),
                      width: double.infinity,
                      height: 40.0,
                      child: FlatButton(
                          onPressed: phoneController.text.length == 11 &&
                                  pwdController.text.length >= 6 &&
                                  isCheck
                              ? () {
                                  showLoadingDialog(context);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  register(
                                      phoneController.text.toString(),
                                      pwdController.text.toString(),
                                      nameController.text.toString(),
                                      imgPath);
                                }
                              : null,
                          child: Text(S.of(context).sign_up,
                              style: TextStyle(color: Colors.white)),
                          color: Colors.green,
                          disabledColor: Colors.green[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)))),
                ], crossAxisAlignment: CrossAxisAlignment.start))));
  }

  /// 注册
  ///
  /// [mobile] 手机号码
  /// [password] 密码
  /// [name] 昵称
  /// [path] 头像路径
  ///
  Future register(String mobile, String password,
      [String name = "", String path = ""]) async {
    Map<String, dynamic> params = {};

    params["mobile"] = mobile;
    params["password"] = password;

    if (Utils.isNotEmpty(path)) {
      String filename = path.substring(path.lastIndexOf("/") + 1, path.length);
      debugPrint(filename);

      params["avatar"] = MultipartFile.fromFileSync(path, filename: filename);
    }

    if (Utils.isNotEmpty(name)) {
      params["name"] = name;
    }

    print(params.toString());

    /// 在自己的服务器注册一个账号，获取一个用户唯一标识符用来注册极光IM
    await HttpUtils().post(
      APIs.REGISTER,
      (data) async {
        UserBean user = UserBean.fromMap(data);

        print(user.toString());

        /// 注册极光IM
        await jMessage
            .userRegister(
                username: user.identifier,
                password: Config
                    .JMESSAGE_PASSWORD) // 此处密码统一为“123456”是因为当用户使用验证码登录时根本获取不到用户的密码所以在这儿使用统一的密码，当然也可以在设置复杂一点的密码，但是这儿的面膜一定要与登录JMessage时的密码一致
            .then((value) async {
          /// 登录极光IM
          await jMessage
              .login(
                  username: user.identifier, password: Config.JMESSAGE_PASSWORD)
              .then((value) async {
            if (user?.name != null || user?.avatarUrl != null) {
              /// 添加极光IM昵称,头像等
              await jMessage.updateMyInfo(
                nickname: user?.name ?? "",
                gender: JMGender.unknown, // 初始默认性别为“未知”
                extras: {"avatarUrl": user?.avatarUrl ?? ""},
              );
            }

            /// 获取用户信息
            Provider.of<UserProvider>(context, listen: false).getUserInfo();

            /// 记录登录状态
            SpUtil.setBool(Config.IS_LOGIN, true);

            /// 这儿延迟500毫秒在进入主页是为了获取用户信息请求完成
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.of(context).pop();
              pushAndRemovePage(context, HomePage());
            });
          }, onError: (error) {
            Navigator.of(context).pop();
            print("login error => ${error.toString()}");
          });
        }, onError: (error) {
          Navigator.of(context).pop();
          print("userRegister error => ${error.toString()}");
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
