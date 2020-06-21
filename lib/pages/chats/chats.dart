import 'package:flutter/material.dart';

import '../../provider/index.dart';

import '../../commons/index.dart';

import '../../widgets/index.dart';

import '../../generated/i18n.dart';

import '../scan.dart';
import 'group/message.dart';
import '../search.dart';
import 'single/message.dart';
import '../contacts/add_friend.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key key}) : super(key: key);

  @override
  createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool _showMenu = false;

  double _globalPositionX = 0.0; //长按位置的横坐标
  double _globalPositionY = 0.0; //长按位置的纵坐标

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).getChats();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive');
        break;

      case AppLifecycleState.paused:
        print('AppLifecycleState.paused');
        break;

      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed');

        /// 从后台切回来刷新会话
        Future.microtask(
            () => Provider.of<ChatProvider>(context, listen: false).getChats());
        break;

      case AppLifecycleState.detached:
        print('AppLifecycleState.detached');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChatProvider>(
        builder: (context, ChatProvider provider, child) {
      return Scaffold(
          appBar: AppBar(title: Text(S.of(context).tab_chat), actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => pushNewPage(context, SearchPage())),
            IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _showMenu = !_showMenu))
          ]),
          body: Stack(children: <Widget>[
            LoaderContainer(
                contentView: RefreshIndicator(
                    onRefresh: () async => provider.getChats(),
                    child: ListView.separated(
                        itemBuilder: (_, index) => ItemChat(
                            onTapDown: (TapDownDetails details) => setState(() {
                                  _globalPositionX = details.globalPosition.dx;
                                  _globalPositionY = details.globalPosition.dy;
                                }),
                            chat: provider.chats[index],
                            onPress: () {
                              provider.getCurrentChatBgImage(
                                  provider.chats[index]);

                              provider
                                  .getHistoryMessages(provider.chats[index], 0)
                                  .then((value) {
                                if (provider.chats[index].conversationType ==
                                    JMConversationType.single) {
                                  pushNewPage(
                                      context,
                                      SingleMessagePage(
                                          chat: provider.chats[index]));
                                } else if (provider
                                        .chats[index].conversationType ==
                                    JMConversationType.group) {
                                  pushNewPage(
                                      context,
                                      GroupMessagePage(
                                          chat: provider.chats[index]));
                                }
                              });
                            },
                            onLongPress: () {
                              showChatPopupMenu(
                                context,
                                (String value) {
                                  Navigator.pop(context);
                                  switch (value) {
                                    case "read":
                                      provider.resetUnreadMessageCount(
                                          provider.chats[index]);
                                      break;
                                    case "top":
                                      provider.setTopMessage(
                                          provider.chats[index],
                                          !JPushUtil.isTopChat(
                                              provider.chats[index]));
                                      break;
                                    case "delete":
                                      showDeleteChatDialog(context,
                                          callBack: (value) {
                                        if (value) {
                                          provider.deleteChat(
                                              provider.chats[index]);
                                        }
                                        Navigator.maybePop(context);
                                      });
                                      break;
                                  }
                                },
                                _globalPositionX,
                                _globalPositionY,
                                JPushUtil.isTopChat(provider.chats[index]),
                                provider.chats[index].unreadCount > 0,
                              );
                            }),
                        itemCount: provider.chats.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(height: .2, color: Colors.grey))),
                loaderState: provider.state),
            // 菜单
            Positioned(
                left: 0,
                right: 0,
                height: Utils.height - Utils.navigationBarHeight,
                top: 0,
                child: Menus(
                    show: _showMenu,
                    onCallback: (index) {
                      print('index is 👉 $index');
                      _showMenu = false;
                      setState(() {});

                      switch (index) {
                        case 0:
                          break;
                        case 1:
                          pushNewPage(context, AddFriendPage());
                          break;
                        case 2:
                          pushNewPage(context, ScanPage(), callBack: (value) {
                            print('===========>${value.toString()}');
                          });
                          break;
                        case 3:
                          break;
                      }
                    }))
          ]));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
