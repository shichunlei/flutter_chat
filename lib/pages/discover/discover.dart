import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';

import '../scan.dart';
import '../search.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key key}) : super(key: key);

  @override
  createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).tab_discover)),
        body: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(children: [
              SelectedText(
                  leading:
                      SvgPicture.asset('images/icon_moment.svg', height: 25),
                  title: S.of(context).moments,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5),
                  rightWidget: Container(
                      height: 42,
                      width: 42,
                      child: Stack(children: <Widget>[
                        Positioned(
                            child: ImageView(
                                'https://randomuser.me/api/portraits/men/90.jpg',
                                height: 40,
                                placeholder: 'images/header.jpeg',
                                width: 40,
                                radius: 5),
                            left: 0,
                            bottom: 0),
                        Positioned(
                            child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red)),
                            top: 0,
                            right: 0)
                      ]))),
              Container(height: 5),
              SelectedText(
                  leading: Image.asset('images/Icon_album.png', height: 25),
                  title: S.of(context).channels,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_scan.svg',
                      height: 25, color: Color(0xFF3d83e6)),
                  title: S.of(context).scan,
                  onTap: () =>
                      pushNewPage(context, ScanPage(), callBack: (value) {
                        print('===========>${value.toString()}');
                      }),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_shake.svg',
                      height: 25, color: Color(0xFF3d83e6)),
                  title: S.of(context).shake,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  leading: Image.asset('images/Icon_browse.png', height: 25),
                  title: S.of(context).top_stories,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  leading: Image.asset('images/Icon_search.png', height: 25),
                  title: S.of(context).discover_search,
                  onTap: () => pushNewPage(context, SearchPage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_nearby.svg',
                      height: 25, color: Color(0xFF3d83e6)),
                  title: S.of(context).people_nearby,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_bottle.svg',
                      height: 25, color: Color(0xFF3d83e6)),
                  title: S.of(context).current_bottle,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_shop.svg',
                      height: 25, color: Color(0xFFE75E58)),
                  title: S.of(context).shopping,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_game.svg', height: 25),
                  title: S.of(context).games,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  leading: SvgPicture.asset('images/icon_miniprogram.svg',
                      height: 25, color: Color(0xFF6467e8)),
                  title: S.of(context).mini_programs,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5)),
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}
