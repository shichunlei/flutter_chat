import 'package:flutter/services.dart';
import 'package:flutter_chat/model/user.dart';

import '../pages/chats/group/message.dart';
import '../pages/chats/single/message.dart';

import '../commons/index.dart';

import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  LoaderState _state = LoaderState.Loading;

  LoaderState get state => _state;

  List<JMConversationInfo> _chats = [];

  List<JMConversationInfo> get chats => _chats;

  String _bgImage = '';

  String get bgImage => _bgImage;

  /// 得到聊天会话列表数据
  ///
  Future getChats() async {
    await jMessage.getConversations().then((List<JMConversationInfo> value) {
      List<JMConversationInfo> list = value;

      _chats.clear();
      _chats.addAll(list);

      _chats.forEach((element) {
        print("JMConversationInfo => ${element.toJson()}");

        print("JMConversationInfo extras => ${element.extras}");

        print(
            "JMConversationInfo extras bgImage => ${element.extras["bgImage"]}");
      });

      if (_chats.length > 0) {
        _state = LoaderState.Succeed;
      } else {
        _state = LoaderState.NoData;
      }

      print("=====================>${_chats.length}");

      notifyListeners();
    }, onError: (error) {
      _state = LoaderState.Failed;
      notifyListeners();
      if (error is PlatformException) {
        print('getConversations error => ${error.toString()}');
      }
    });
  }

  Future getCurrentConversationInfo(JMConversationInfo conversation) async {
    _chats.forEach((element) {
      print(element.toJson());
      if (element.target == conversation.target) {
        _bgImage = element.extras["bgImage"] ?? '';

        print('当前聊天的背景图片 => $_bgImage');
      }
    });

    notifyListeners();
  }

  /// 置顶消息
  ///
  /// [chat] 会话
  /// [isTop] 是否置顶
  ///
  Future setTopMessage(JMConversationInfo chat, bool isTop) async {
    _chats.forEach((element) {
      print("会话-----============> ${element.toJson()}");
      if (element.target == chat.target) {
        Map<dynamic, dynamic> extras = chat.extras;

        extras["isTop"] = isTop ? "1" : "0";

        chat.setExtras(extras);
      }
    });

    /// todo 排序：先按置顶-再按时间排序

    notifyListeners();
  }

  /// 消息免打扰
  ///
  /// [chat] 会话
  /// [isDisturb] 是否免打扰
  ///
  Future setDisturb(JMConversationInfo chat, bool isNoDisturb) async {
    var target;

    if (chat.conversationType == JMConversationType.single) {
      target = (chat.target as JMUserInfo).targetType;
    } else if (chat.conversationType == JMConversationType.group) {
      target = (chat.target as JMGroupInfo).targetType;
    }

    jMessage.setNoDisturb(target: target, isNoDisturb: isNoDisturb).then(
        (value) {
      /// 更新会话列表
      getChats();
    }, onError: (error) {
      if (error is PlatformException) {
        print('setNoDisturb error => ${error.toString()}');
      }
    });
  }

  /// 设置会话的背景图片
  ///
  /// [chat] 会话
  /// [bgImage] 背景图片
  ///
  Future setChatBackground(JMConversationInfo chat, String bgImage) async {
    _chats.forEach((element) {
      print(element.toJson());
      if (element.target == chat.target) {
        Map<dynamic, dynamic> extras = chat.extras;

        extras["bgImage"] = bgImage;

        chat.setExtras(extras);
      }
    });

    _bgImage = bgImage;

    notifyListeners();
  }

  /// 清空聊天记录
  ///
  /// [chat] 会话
  ///
  Future cleanMessages(JMConversationInfo chat) async {
//    int index = _chats.indexOf(chat);
//
//    JMUserInfo userInfo = chat.target;
//
//    await jMessage.deleteConversation(target: userInfo.targetType).then(
//        (value) {
//      JMConversationInfo element;
//      _chats.insert(index, element);
//    }, onError: (error) {
//      if (error is PlatformException) {
//        print('cleanMessages error => ${error.toString()}');
//      }
//    });
  }

  /// 删除会话（同时删除聊天记录）
  ///
  /// [chat] 会话
  ///
  Future deleteChat(JMConversationInfo chat) async {
    var target;

    if (chat.conversationType == JMConversationType.single) {
      target = (chat.target as JMUserInfo).targetType;
    } else if (chat.conversationType == JMConversationType.group) {
      target = (chat.target as JMGroupInfo).targetType;
    }

    await jMessage.deleteConversation(target: target).then((value) {
      _chats.remove(chat);

      if (_chats.length == 0) {
        _state = LoaderState.NoData;
      }

      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        print('deleteConversation error => ${error.toString()}');
      }
    });
  }

  /// 重置会话的未读消息数
  ///
  /// [chat] 会话
  ///
  Future resetUnreadMessageCount(JMConversationInfo chat) async {
    var target;

    if (chat.conversationType == JMConversationType.single) {
      target = (chat.target as JMUserInfo).targetType;
    } else if (chat.conversationType == JMConversationType.group) {
      target = (chat.target as JMGroupInfo).targetType;
    }

    await jMessage
        .resetUnreadMessageCount(target: target)
        .then((value) => getChats(), onError: (error) {
      if (error is PlatformException) {
        print('resetUnreadMessageCount error => ${error.toString()}');
      }
    });
  }

  /// 获取会话详情
  ///
  /// [context] 上下文
  /// [targetType] 会话类型(JMSingle | JMGroup | JMChatRoom)
  /// [isJump] 是否跳转到会话聊天页
  /// [isCreate] 如果会话不存在是否创建会话
  ///
  Future jumpToConversationMessage(BuildContext context, dynamic targetType,
      {bool isJump: true, bool isCreate: true}) async {
    await jMessage.getConversation(target: targetType).then(
        (JMConversationInfo conversation) {
      print('getConversation ${conversation.toJson()}');

      if (isJump) {
        getHistoryMessages(conversation, 0).then((_) {
          if (targetType is JMSingle) {
            pushNewPage(context, SingleMessagePage(chat: conversation));
          } else {
            pushNewPage(context, GroupMessagePage(chat: conversation));
          }
        });
      }
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '2') {
          print('没有该会话');
          if (isCreate) {
            /// 创建会话
            createConversation(context, targetType, isJump: isJump);
          }
        }
        print('getConversation error => ${error.toString()}');
      }
    });
  }

  /// 创建一个会话
  ///
  /// [context] 上线文
  /// [targetType] 会话类型(JMSingle | JMGroup | JMChatRoom)
  /// [isJump] 是否跳转到会话聊天页
  ///
  Future createConversation(BuildContext context, dynamic targetType,
      {bool isJump: true}) async {
    await jMessage.createConversation(target: targetType).then(
        (JMConversationInfo conversation) {
      print("createConversation => ${conversation.toJson()}");

      getChats().then((_) {
        if (isJump) {
          getHistoryMessages(conversation, 0).then((__) {
            if (targetType is JMSingle) {
              pushNewPage(context, SingleMessagePage(chat: conversation));
            } else {
              pushNewPage(context, GroupMessagePage(chat: conversation));
            }
          });
        }
      });
    }, onError: (error) {
      print('createConversation error => ${error.toString()}');

      if (error is PlatformException) {}
    });
  }

  List _messages = [];

  List get messages => _messages;

  /// 获取当前会话的历史聊天记录
  ///
  /// [chat] 会话
  /// [from] 起始位置
  ///
  Future<void> getHistoryMessages(JMConversationInfo chat, int from) async {
    _messages.clear();

    await chat.getHistoryMessages(from: 0, limit: 50, isDescend: true).then(
        (List value) {
      print('getHistoryMessages length => ${value.length}');

      value.forEach((element) {
        print("getHistoryMessages => ${(element.from as JMUserInfo).toJson()}");

        if (element is JMTextMessage) {
          print('getHistoryMessages     =>      ${element.text}');
        }
        if (element is JMNormalMessage) {
          print('getHistoryMessages     =>      ${element.id}');
        }
      });

      if (value.length > 0) {
        _messages.addAll(value);
      }
      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        print('getHistoryMessages error => ${error.toString()}');
      }
    });
  }

  /// 发送或接收到消息后刷新会话列表项中最后一条消息
  ///
  /// [chat] 会话
  ///
  Future<void> updateChat(JMConversationInfo chat) async {
    int index = _chats.indexOf(chat);

    JMConversationInfo _chat;

    if (index == -1) {
      print('----------------------> $index');
      _chats.forEach((element) {
        if (element.target == chat.target) {
          _chat = element;
        }
      });

      index = _chats.indexOf(_chat);
    } else {
      _chat = chat;
    }

    print('----------------------> $index');

    var target;

    if (_chat.conversationType == JMConversationType.single) {
      target = (_chat.target as JMUserInfo).targetType;
    } else if (_chat.conversationType == JMConversationType.group) {
      target = (_chat.target as JMGroupInfo).targetType;
    }

    await jMessage.getConversation(target: target).then(
        (JMConversationInfo value) {
      print('getConversation ${value.toJson()}');

      /// 重置该消息
      _chats.setRange(index, index + 1, [value]);
      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '2') {
          print('没有该会话');
        }
        print('getConversation error => ${error.toString()}');
      }
    });
  }

  /// 添加消息到列表
  ///
  /// [message] 消息
  ///
  Future addMessageToListView(message) async {
    print('=========================================');

    _messages.insert(0, message);
    notifyListeners();
  }

  /// 监听消息撤回处理
  ///
  /// [messageId] 消息处理
  ///
  Future retractedMessage(String messageId) async {
    var message = _messages.firstWhere((element) => element.id == messageId);

    _messages.remove(message);
  }

  /// 根据ID获取消息
  ///
  /// [chat] 会话
  /// [messageId] 消息Id
  ///
  Future getMessageById(JMConversationInfo chat, String messageId) async {
    print('===========$messageId');

    var target;

    if (chat.conversationType == JMConversationType.single) {
      target = (chat.target as JMUserInfo).targetType;
    } else if (chat.conversationType == JMConversationType.group) {
      target = (chat.target as JMGroupInfo).targetType;
    }

    jMessage.getMessageById(type: target, messageId: messageId).then((value) {
      print('getMessageById => ${value.toJson()}');
      _messages.insert(0, value);
      getChats();
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '2') {
          print('没有该会话');
        }
        print('getMessageById error => ${error.toString()}');
      }
    });
  }

  /// 发送文本消息
  ///
  /// [chat] 会话
  /// [text] 文本
  ///
  Future sendTextMessage(JMConversationInfo chat, String text) async {
    await chat
        .sendTextMessage(text: text)
        .then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendTextMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送图片消息
  ///
  /// [chat] 会话
  /// [path] 图片本地绝对路径
  ///
  Future sendImageMessage(JMConversationInfo chat, String path) async {
    await chat
        .sendImageMessage(path: path)
        .then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendImageMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送语音消息
  ///
  /// [chat] 会话
  /// [path] 语音本地绝对路径
  ///
  Future sendVoiceMessage(
      JMConversationInfo chat, String path, int seconds) async {
    await chat.sendVoiceMessage(path: path, extras: {"seconds": seconds}).then(
        (value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendVoiceMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送位置消息
  ///
  /// [chat] 会话
  /// [scale] 地图缩放比例
  /// [longitude] 经度
  /// [latitude] 纬度
  /// [address] 地址
  ///
  Future sendLocationMessage(JMConversationInfo chat, int scale,
      double longitude, double latitude, String address) async {
    await chat
        .sendLocationMessage(
            scale: 15,
            longitude: longitude,
            latitude: latitude,
            address: address)
        .then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendLocationMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送位置消息
  ///
  /// [chat] 会话
  /// [path] 文件路径
  /// [suffix] 文件后缀
  /// [size] 文件大小
  ///
  Future sendFileMessage(
      JMConversationInfo chat, String path, String suffix, String size) async {
    var targetType;

    print("path==============>$path");

    if (chat.target is JMGroupInfo) {
      // 群组
      targetType = (chat.target as JMGroupInfo).targetType;
    } else if (chat.target is JMUserInfo) {
      // 单聊
      targetType = (chat.target as JMUserInfo).targetType;
    }

    await chat.sendFileMessage(type: targetType, path: path, extras: {
      "suffix": suffix,
      "size": size,
      "filePath": path
    }).then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendFileMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送名片消息
  ///
  /// [chat] 会话
  /// [user] 名片用户
  ///
  Future sendNameCardMessage(JMConversationInfo chat, UserBean user) async {
    await chat.sendCustomMessage(customObject: {
      "type": "namecard",
      "nickname": user.name,
      "identifier": user.identifier,
      "avatar": user.avatarUrl
    }).then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendNameCardMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送拍了拍消息
  ///
  /// [chat] 会话
  /// [toUser] 被拍拍的用户
  ///
  Future sendShakeMessage(JMConversationInfo chat, JMUserInfo toUser) async {
    await chat.sendCustomMessage(customObject: {
      "type": "shake",
      "toUser": toUser.toJson()
    }).then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendShakeMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送群聊邀请消息
  ///
  /// [chat] 会话
  /// [groupId] 群ID
  /// [groupId] 群名称
  ///
  Future sendGroupInvitationMessage(
      JMConversationInfo chat, String groupId, String groupName) async {
    await chat.sendCustomMessage(customObject: {
      "type": "groupInvitation",
      "groupId": groupId,
      "groupName": groupName,
      "groupImage": '',
    }).then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendNameCardMessage error => ${error.toString()}');
      }
    });
  }

  /// 发送自定义消息
  ///
  /// [chat] 会话
  /// [customObject] 自定义消息体
  ///
  Future sendCustomMessage(JMConversationInfo chat, Map customObject) async {
    await chat
        .sendCustomMessage(customObject: customObject)
        .then((value) => getMessageById(chat, value.id), onError: (error) {
      if (error is PlatformException) {
        print('sendCustomMessage error => ${error.toString()}');
      }
    });
  }

  /// 删除消息
  ///
  /// [message] 要删除的消息
  ///
  Future deleteMessageById(dynamic message) async {
    if (message is JMNormalMessage) {
      var targetType;

      if (message.target is JMGroupInfo) {
        // 群组
        targetType = (message.target as JMGroupInfo).targetType;
      } else if (message.target is JMUserInfo) {
        // 单聊
        targetType = (message.target as JMUserInfo).targetType;
      }

      await jMessage
          .deleteMessageById(type: targetType, messageId: message.id)
          .then((value) => deleteMessageFromList(message.id), onError: (error) {
        if (error is PlatformException) {
          print('deleteMessageById error => ${error.toString()}');
        }
      });
    }
  }

  /// 消息撤回
  ///
  /// [message] 要撤回的消息
  ///
  Future retractMessage(dynamic message) async {
    if (message is JMNormalMessage) {
      var targetType;

      if (message.target is JMGroupInfo) {
        // 群组
        targetType = (message.target as JMGroupInfo).targetType;
      } else if (message.target is JMUserInfo) {
        // 单聊
        targetType = (message.target as JMUserInfo).targetType;
      }

      await jMessage
          .retractMessage(
              serverMessageId: message.serverMessageId, target: targetType)
          .then((value) => deleteMessageFromList(message.id), onError: (error) {
        if (error is PlatformException) {
          print('retractMessage error => ${error.toString()}');
          if (error.code == "855001") {}
        }
      });
    }
  }

  /// 从列表中删除消息
  ///
  /// [messageId] 消息Id
  ///
  Future deleteMessageFromList(String messageId) async {
    /// 在列表中删除该消息
    _messages.removeWhere((element) => element.id == messageId);

    /// 更新会话列表
    getChats();
  }
}
