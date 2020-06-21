import '../utils/toast_util.dart';

import '../generated/i18n.dart';
import 'package:flutter/material.dart';

import 'chats/chats.dart';
import 'contacts/contacts.dart';
import 'discover/discover.dart';
import 'mine/mine.dart';
import 'mixin/listener_mixin.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, ListenerStateMixin {
  /// 上次点击时间
  DateTime _lastPressedAt;

  int _currentIndex = 0;

  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 2)) {
            debugPrint("点击时间");

            /// 两次点击间隔超过2秒则重新计时
            _lastPressedAt = DateTime.now();
            Toast.show(context, S.of(context).pressAgain);
            return false;
          }
          return true;
        },
        child: Scaffold(
            body: PageView(
                children: <Widget>[
                  ChatsPage(),
                  ContactsPage(),
                  DiscoverPage(),
                  MinePage()
                ],
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                physics: NeverScrollableScrollPhysics()),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  _controller.animateToPage(index,
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 100));
                  setState(() => _currentIndex = index);
                },
                selectedItemColor: Colors.green,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset('images/tabbar_mainframe.png',
                          fit: BoxFit.fitHeight, height: 23),
                      activeIcon: Image.asset('images/tabbar_mainframeHL.png',
                          fit: BoxFit.fitHeight, height: 23),
                      title: Text(S.of(context).tab_chat)),
                  BottomNavigationBarItem(
                      icon: Image.asset('images/tabbar_contacts.png',
                          fit: BoxFit.fitHeight, height: 23),
                      activeIcon: Image.asset('images/tabbar_contactsHL.png',
                          fit: BoxFit.fitHeight, height: 23),
                      title: Text(S.of(context).tab_contacts)),
                  BottomNavigationBarItem(
                      icon: Image.asset('images/tabbar_discover.png',
                          fit: BoxFit.fitHeight, height: 23),
                      activeIcon: Image.asset('images/tabbar_discoverHL.png',
                          fit: BoxFit.fitHeight, height: 23),
                      title: Text(S.of(context).tab_discover)),
                  BottomNavigationBarItem(
                      icon: Image.asset('images/tabbar_me.png',
                          fit: BoxFit.fitHeight, height: 23),
                      activeIcon: Image.asset('images/tabbar_meHL.png',
                          fit: BoxFit.fitHeight, height: 23),
                      title: Text(S.of(context).tab_mine)),
                ])));
  }
}
