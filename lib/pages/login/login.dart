import 'package:flutter/material.dart';

import '../../generated/i18n.dart';
import '../../utils/route_util.dart';

import 'input_phone.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      body: Stack(children: <Widget>[
        Positioned.fill(
            child: Image.asset('images/splash.png', fit: BoxFit.fitHeight)),
        Positioned(
            child: Row(children: <Widget>[
              Expanded(
                  child: RaisedButton(
                      child: Text(S.of(context).sign_in,
                          style: TextStyle(color: Color(0xFF06AD56))),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      highlightColor: Color(0xd9d9d9),
                      onPressed: () =>
                          pushAndRemovePage(context, PhoneLoginFirstPage()))),
              SizedBox(width: 30),
              Expanded(
                  child: RaisedButton(
                      child: Text(S.of(context).sign_up,
                          style: TextStyle(color: Colors.white)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Color(0xFF06AD56),
                      highlightColor: Color(0xFF06AD56),
                      onPressed: () =>
                          pushAndRemovePage(context, RegisterPage())))
            ]),
            bottom: 50,
            left: 30,
            right: 30)
      ]),
    );
  }
}
