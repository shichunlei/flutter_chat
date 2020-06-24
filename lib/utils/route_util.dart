import 'package:flutter/material.dart';

void pushNewPage(BuildContext context, Widget routePage,
    {Function callBack, fullscreenDialog: false}) {
  /// 隐藏键盘
  FocusScope.of(context).requestFocus(FocusNode());

  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => routePage,
              fullscreenDialog: fullscreenDialog))
      .then((value) {
    if (value != null) {
      callBack(value);
    }
  });
}

void pushAndRemovePage(BuildContext context, Widget routePage) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => routePage),
      (route) => route == null);
}

void pushReplacementPage(BuildContext context, Widget routePage) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => routePage));
}
