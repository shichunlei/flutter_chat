import '../commons/index.dart';
import '../provider/index.dart';

import 'package:flutter/material.dart';

import 'home.dart';
import 'login/login.dart';

/// 启动页
class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      isLogin = SpUtil.getBool(Config.IS_LOGIN, defValue: false);

      if (isLogin) {
        Provider.of<UserProvider>(context, listen: false).getUserInfo();

        pushReplacementPage(context, HomePage());
      } else {
        pushReplacementPage(context, LoginPage());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Image.asset('images/splash.jpg', fit: BoxFit.fitHeight),
            height: double.infinity));
  }
}
