import 'package:flutter/services.dart';

import 'package:jmessage_flutter/jmessage_flutter.dart';

import 'package:platform/platform.dart';

export 'package:jmessage_flutter/jmessage_flutter.dart';

import '../commons/config.dart';

import 'utils.dart';

MethodChannel channel = MethodChannel('jmessage_flutter');
JmessageFlutter jMessage =
    JmessageFlutter.private(channel, const LocalPlatform());

class JPushUtil {
  /// 初始化 JMessage
  static Future<void> jMessageInit() async {
    /// 设置是否开启 debug 模式，开启后 SDK 将会输出更多日志信息，推荐在应用对外发布时关闭。
    jMessage.setDebugMode(enable: true);
    jMessage.init(isOpenMessageRoaming: true, appkey: Config.JPUSH_APPKEY);

    /// iOS 端注册 apns 通知
    jMessage.applyPushAuthority(
        new JMNotificationSettingsIOS(sound: true, alert: true, badge: true));
  }

  /// 得到用户/群组名称
  ///
  static String getName(target) {
    if (target == null) return "";

    if (target is JMUserInfo) {
      JMUserInfo userInfo = target;

      return Utils.isEmpty(userInfo?.noteName)
          ? Utils.isEmpty(userInfo?.nickname)
              ? userInfo?.username
              : userInfo?.nickname
          : userInfo?.noteName;
    } else if (target is JMGroupInfo) {
      JMGroupInfo groupInfo = target;

      return groupInfo.name;
    } else {
      return "";
    }
  }

  /// 会话最后一条信息
  ///
  static String getLastMessageStr(JMConversationInfo conversationInfo) {
    var latestMessage = conversationInfo.latestMessage;
    if (latestMessage != null) {
      if (latestMessage is JMTextMessage) {
        JMTextMessage textMessage = latestMessage;
        return textMessage.text; // 文本
      } else if (latestMessage is JMVoiceMessage) {
        return '[语音]';
      } else if (latestMessage is JMLocationMessage) {
        return '[位置]';
      } else if (latestMessage is JMFileMessage) {
        return '[文件]';
      } else if (latestMessage is JMImageMessage) {
        return '[图片]';
      } else if (latestMessage is JMCustomMessage) {
        if (latestMessage.customObject["type"] == "namecard") {
          return '[名片]';
        } else {
          return '';
        }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  /// 会话是否置顶
  ///
  static bool isTopChat(JMConversationInfo conversationInfo) {
    if (null == conversationInfo.extras["isTop"]) {
      return false;
    } else {
      if (Utils.isEmpty(conversationInfo.extras["isTop"])) {
        return false;
      } else {
        print("================>${conversationInfo.extras["isTop"]}");

        if (conversationInfo.extras["isTop"] == "\"1\"" ||
            conversationInfo.extras["isTop"] == "1") {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  static dynamic getMessage(message) async {
    if (message is JMTextMessage) {
      // 文本消息
      print('JMTextMessage => ${message.text}');
      return message;
    } else if (message is JMImageMessage) {
      // 图片消息
      print('JMImageMessage => ${message.thumbPath}');
      return message;
    } else if (message is JMVoiceMessage) {
      // 语音消息
      print('JMVoiceMessage => ${message.path}');
      return message;
    } else if (message is JMLocationMessage) {
      // 地址消息
      print(
          'JMLocationMessage => ${message.longitude},${message.latitude},${message.scale}');
      return message;
    } else if (message is JMFileMessage) {
      // 文件消息
      print('JMFileMessage => ${message.fileName}');
      return message;
    } else if (message is JMCustomMessage) {
      // 自定义消息
      print('JMCustomMessage => ${message.extras["type"]}');

      if (message.extras["type"] == "namecard") {
        // 发送名片
        return message;
      }
      return message;
    }
  }
}
