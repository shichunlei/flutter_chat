import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/profile/take_video.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import '../../provider/index.dart';

import 'myinfo.dart';
import '../profile/setting.dart';

/// 我
class MinePage extends StatefulWidget {
  const MinePage({Key key}) : super(key: key);

  @override
  createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController;

  double offset = .0;

  Animation animation, animation1, animation2;
  AnimationController _controller;

  bool showSecondFloor = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                showSecondFloor = true;
                offset = .0;
              });
            } else if (status == AnimationStatus.dismissed) {
              setState(() {
                showSecondFloor = false;
                offset = .0;
              });
            }
          })
          ..addListener(() {
            setState(() {});
          });

    animation =
        Tween<double>(begin: -offset, end: Utils.height).animate(_controller);

    animation1 = Tween<double>(begin: 0, end: 1).animate(_controller);

    animation2 = Tween<double>(begin: 1, end: 0).animate(_controller);

    scrollController = ScrollController()
      ..addListener(() {
        offset = scrollController.offset;

        print("====================>$offset");

        if (offset < -Utils.topSafeHeight) {
          /// 执行动画，页面向下滑动，显示出底层页面
          _controller?.forward();
        }
      });
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = Provider.of<UserProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Stack(children: <Widget>[
          Transform.scale(
              scale: animation1.value,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print('===============');
                    setState(() {
                      showSecondFloor = false;
                    });
                    _controller.reverse();
                  },
                  child: Container(
                      height: Utils.height,
                      padding: EdgeInsets.only(top: Utils.height * 0.55),
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              showSecondFloor = false;
                            });
                            _controller.reverse();

                            /// TODO跳转到拍摄视频页面
                            pushNewPage(context, TakeVideoPage());
                          },
                          child: Row(children: <Widget>[
                            Icon(Icons.camera_alt, color: Colors.blue),
                            SizedBox(width: 10),
                            Text('拍一个视频动态',
                                style: TextStyle(color: Colors.blue))
                          ], mainAxisSize: MainAxisSize.min)),
                      alignment: Alignment.center))),
          Visibility(
            visible: !showSecondFloor,
            child: Transform.translate(
              offset: Offset(.0, animation.value),
              child: SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Container(
                    color: Colors.grey[200],
                    height: Utils.height,
                    child: Column(children: [
                      GestureDetector(
                          child: Container(
                              padding: EdgeInsets.only(
                                  top: Utils.navigationBarHeight,
                                  bottom: 30,
                                  left: 20,
                                  right: 5),
                              color: Colors.white,
                              child: Row(children: <Widget>[
                                ImageView(
                                    '${snapshot.userInfo.extras["avatarUrl"]}',
                                    height: 60,
                                    width: 60,
                                    radius: 10,
                                    placeholder: 'images/header.jpeg'),
                                SizedBox(width: 20),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                          '${JPushUtil.getName(snapshot.userInfo)}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      SizedBox(height: 10),
                                      Row(children: <Widget>[
                                        Text(
                                            '${S.of(context).id(snapshot.identifier)}'),
                                        Spacer(),
                                        ImageView('images/icon_qr.png',
                                            imageType: ImageType.assets,
                                            width: 16,
                                            height: 16),
                                        SizedBox(width: 5),
                                        Icon(Icons.arrow_forward_ios, size: 15)
                                      ])
                                    ]))
                              ])),
                          onTap: () => pushNewPage(context, MyInfoPage())),
                      Container(height: 5),
                      SelectedText(
                          leading: SvgPicture.asset('images/icon_wechatpay.svg',
                              height: 25),
                          title: '${S.of(context).pay}',
                          onTap: () {},
                          margin: EdgeInsets.only(left: 20, right: 5)),
                      Container(height: 5),
                      SelectedText(
                          leading: SvgPicture.asset('images/icon_favorites.svg',
                              height: 25),
                          title: '${S.of(context).favorites}',
                          onTap: () {},
                          margin: EdgeInsets.only(left: 20, right: 5)),
                      Container(height: .5),
                      SelectedText(
                          leading: SvgPicture.asset('images/icon_album.svg',
                              height: 25, color: Color(0xFF3d83e6)),
                          title: '${S.of(context).setting_gallery}',
                          onTap: () {},
                          margin: EdgeInsets.only(left: 20, right: 5)),
                      Container(height: .5),
                      SelectedText(
                          leading: SvgPicture.asset('images/icon_cards.svg',
                              height: 25),
                          title: '${S.of(context).cards_offers}',
                          onTap: () {},
                          margin: EdgeInsets.only(left: 20, right: 5)),
                      Container(height: .5),
                      SelectedText(
                          leading: SvgPicture.asset('images/icon_sticker.svg',
                              height: 25, color: Color(0xFFEDA150)),
                          title: '${S.of(context).expression}',
                          onTap: () {},
                          margin: EdgeInsets.only(left: 20, right: 5)),
                      Container(height: 5),
                      SelectedText(
                          leading: SvgPicture.asset('images/icon_setting.svg',
                              height: 25, color: Color(0xFF3d83e6)),
                          title: '${S.of(context).settings}',
                          onTap: () => pushNewPage(context, SettingPage()),
                          margin: EdgeInsets.only(left: 20, right: 5)),
                    ]),
                  )),
            ),
          ),
          Container(
              child: AppBar(actions: <Widget>[
                Transform.scale(
                    scale: animation2.value,
                    child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => pushNewPage(context, TakeVideoPage())))
              ], backgroundColor: Colors.transparent, elevation: 0.0),
              alignment: Alignment.centerRight,
              height: Utils.navigationBarHeight)
        ]));
  }
}
