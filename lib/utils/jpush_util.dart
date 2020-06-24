import 'package:flutter/services.dart';
import 'package:flutter_chat/model/user.dart';

import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:lpinyin/lpinyin.dart';

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

  /// 将JMUserInfo转化成UserBean
  static UserBean getUserBean(JMUserInfo userInfo) {
    String firstLetter;

    String name = JPushUtil.getName(userInfo);

    String tag = PinyinHelper.getPinyinE(name).toUpperCase();
    if (RegExp("[A-Z]").hasMatch(tag)) {
      firstLetter = tag[0];
    } else {
      firstLetter = "#";
    }

    return UserBean(
        name: name,
        avatarUrl: userInfo.extras['avatarUrl'] ?? "",
        identifier: userInfo.username,
        firstLetter: firstLetter);
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
        } else if (latestMessage.customObject["type"] == "shake") {
          return '[拍一拍]';
        } else if (latestMessage.customObject["type"] == "groupInvitation") {
          return '[入群邀请]';
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
}
