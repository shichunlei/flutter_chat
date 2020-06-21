import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../commons/index.dart';
import '../../provider/index.dart';

import '../../generated/i18n.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key key}) : super(key: key);

  @override
  createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController oldPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  FocusNode newPwdFocusNode = FocusNode();
  FocusNode confirmPwdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    oldPwdController?.dispose();
    newPwdController?.dispose();
    confirmPwdController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: Text(S.of(context).title_password), actions: <Widget>[]),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).set_password_tip,
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                Row(children: <Widget>[
                  Container(
                      child: Text(S.of(context).wechat_id,
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      width: 80,
                      height: 50,
                      alignment: Alignment.centerLeft),
                  Expanded(
                      child: Text(Provider.of<UserProvider>(context).identifier,
                          style: TextStyle(color: Colors.grey, fontSize: 16)))
                ]),
                Container(height: .5, color: colorGrey_de),
                Row(children: <Widget>[
                  Container(
                      child: Text(S.of(context).old_password,
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      width: 80,
                      height: 50,
                      alignment: Alignment.centerLeft),
                  Expanded(
                      child: TextField(
                          obscureText: true,
                          controller: oldPwdController,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(color: colorGrey_6, fontSize: 14),
                          decoration: InputDecoration(
                              hintText: S.of(context).enterOldPassword,
                              hintStyle:
                                  TextStyle(color: colorGrey_9, fontSize: 14),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colorGrey_de))),
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(newPwdFocusNode);
                          }))
                ]),
                Row(children: <Widget>[
                  Container(
                      child: Text(S.of(context).new_password,
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      width: 80,
                      height: 50,
                      alignment: Alignment.centerLeft),
                  Expanded(
                      child: TextField(
                          controller: newPwdController,
                          focusNode: newPwdFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: TextStyle(color: colorGrey_6, fontSize: 14),
                          decoration: InputDecoration(
                              hintText: S.of(context).enterNewPassword,
                              hintStyle:
                                  TextStyle(color: colorGrey_9, fontSize: 14),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colorGrey_de))),
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(confirmPwdFocusNode);
                          }))
                ]),
                Row(children: <Widget>[
                  Container(
                      child: Text(S.of(context).confirm_password,
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      width: 80,
                      height: 50,
                      alignment: Alignment.centerLeft),
                  Expanded(
                      child: TextField(
                          focusNode: confirmPwdFocusNode,
                          controller: confirmPwdController,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(color: colorGrey_6, fontSize: 14),
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: S.of(context).confirmPassword,
                              hintStyle:
                                  TextStyle(color: colorGrey_9, fontSize: 14),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorGrey_de)))))
                ]),
                SizedBox(height: 5),
                Text(S.of(context).password_tip),
                GestureDetector(
                    child: Text(S.of(context).forgetPassword,
                        style: TextStyle(color: Colors.blue)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return SimpleDialog(
                              title: Text(
                                S.of(context).send_verification_code_tip(
                                    Provider.of<UserProvider>(context)
                                        .identifier),
                                style:
                                    TextStyle(fontSize: 16, color: colorGrey_6),
                              ),
                              children: [
                                Container(height: .5, color: colorGrey_de),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: FlatButton(
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            Navigator.maybePop(context);
                                          },
                                          child: Text(S.of(context).cancel,
                                              style: TextStyle(
                                                  color: Colors.grey)))),
                                  Expanded(
                                      child: FlatButton(
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            Navigator.maybePop(context);
                                          },
                                          child: Text(S.of(context).sure,
                                              style: TextStyle(
                                                  color: Colors.blue))))
                                ])
                              ],
                              contentPadding:
                                  EdgeInsets.only(left: 8, right: 8, top: 10),
                            );
                          });
                    })
              ],
            )));
  }
}
