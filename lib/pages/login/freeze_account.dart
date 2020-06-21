import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FreezeAccountPage extends StatefulWidget {
  const FreezeAccountPage({Key key}) : super(key: key);

  @override
  createState() => _FreezeAccountPageState();
}

class _FreezeAccountPageState extends State<FreezeAccountPage> {
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
        appBar:
            AppBar(title: Text('冻结账号'), leading: CloseButton(), elevation: 0.0),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Container(
                  height: 90,
                  width: 90,
                  margin: EdgeInsets.only(top: 30),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
                  child: Icon(Icons.ac_unit, color: Colors.white, size: 70)),
              SizedBox(height: 20),
              Text(
                '发现微信被盗或手机丢失，你可以冻结微信号',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text('防止坏人窃取你的个人信息'),
              SizedBox(height: 5),
              Text('防止坏人冒用你的身份诈骗好友'),
              SizedBox(height: 5),
              Text('防止坏人盗刷你的微信支付资金'),
              SizedBox(height: 40),
              Container(
                  margin: EdgeInsets.only(top: 3.0),
                  width: double.infinity,
                  height: 40.0,
                  child: FlatButton(
                      onPressed: () {},
                      child:
                          Text('开始冻结', style: TextStyle(color: Colors.white)),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))))
            ])));
  }
}
