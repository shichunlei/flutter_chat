import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

import '../../../commons/ui/loader.dart';
import '../../../provider/index.dart';
import '../../../utils/date_util.dart';
import '../../../utils/utils.dart';

import '../../../utils/route_util.dart';
import '../../../utils/jpush_util.dart';

import '../../../widgets/index.dart';

import 'chat_info.dart';
import '../../mixin/message_mixin.dart';

class GroupMessagePage extends StatefulWidget {
  final JMConversationInfo chat;

  const GroupMessagePage({Key key, @required this.chat}) : super(key: key);

  @override
  createState() => _GroupMessagePageState();
}

class _GroupMessagePageState extends State<GroupMessagePage>
    with WidgetsBindingObserver, MessageStateMixin {
  @override
  void initState() {
    super.initState();

    init(widget.chat);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive');
        break;
      case AppLifecycleState.paused:
        jMessage.exitConversation(target: groupInfo.targetType);
        print('AppLifecycleState.paused');
        break;
      // 从后台切回来刷新会话
      case AppLifecycleState.resumed:
        jMessage.enterConversation(target: groupInfo.targetType);
        print('AppLifecycleState.resumed');
        break;
      case AppLifecycleState.detached:
        print('AppLifecycleState.detached');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    jMessage.exitConversation(target: groupInfo.targetType).catchError((error) {
      print('退出会话失败');
    }).whenComplete(() {
      print('退出会话成功了');
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, ChatProvider chat, child) {
      return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(title: Text('${groupInfo.name}'), actions: <Widget>[
            IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () =>
                    pushNewPage(context, GroupChatInfoPage(chat: widget.chat)))
          ]),
          body: Stack(children: <Widget>[
            SingleChildScrollView(
                child: Container(
                    width: Utils.width,
                    height: Utils.height - Utils.navigationBarHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(chat.bgImage),
                            fit: BoxFit.fill)))),
            LoaderContainer(
                loaderState: chat.state,
                contentView: Column(children: [
                  Expanded(
                      child: EasyRefresh(
                          child: ListView.separated(
                              reverse: true,
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              itemBuilder: (_, index) {
                                String lastTime;
                                if (index % 3 == 0) {
                                  lastTime = formatDateByMs(
                                      (chat.messages[index] as JMNormalMessage)
                                          .createTime);
                                }

                                if ((chat.messages[index] as JMNormalMessage)
                                    .isSend) {
                                  return MessageSendView(
                                      message: chat.messages[index],
                                      time: lastTime,
                                      player: player,
                                      chat: widget.chat);
                                } else {
                                  return MessageReceiveView(
                                      message: chat.messages[index],
                                      time: lastTime,
                                      player: player,
                                      chat: widget.chat);
                                }
                              },
                              itemCount: chat.messages.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      SizedBox(height: 10)),
                          footer: MaterialFooter(),
                          onLoad: () async {
                            /// todo 加载更多消息
                          })),
                  MessageComposerView(chat: widget.chat)
                ]))
          ]));
    });
  }
}
