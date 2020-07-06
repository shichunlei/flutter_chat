import 'package:flutter/material.dart';
import 'dart:ui' as ui show window;

import 'package:flutter/services.dart';

class Utils {
  /// 屏幕宽
  ///
  static double get width {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.width;
  }

  /// 屏幕高
  ///
  static double get height {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.height;
  }

  /// 标题栏高度（包括状态栏）
  ///
  static double get navigationBarHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  /// 键盘高度
  ///
  static double get keyboardHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.viewInsets.bottom ?? 0.0;
  }

  /// 状态栏高度
  ///
  static double get topSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top;
  }

  /// 底部状态栏高度
  ///
  static double get bottomSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.bottom;
  }

  /// 复制内容到剪粘板
  ///
  static copyToClipboard(String text) {
    if (text == null) return;
    Clipboard.setData(new ClipboardData(text: text));
  }

  /// 校验给定路径是否为网络路径
  ///
  /// [path] 路径
  ///
  static bool verifyPathIsHttp(String path) {
    if (path == null || path == '') {
      return false;
    }
    return path.contains('http') || path.contains('https');
  }

  static bool isEmpty(String string) {
    return null == string || '' == string || string.length == 0;
  }

  static bool isNotEmpty(String string) {
    return string != null && string.isNotEmpty;
  }

  // 🔥格式化手机号为344
  static String formatMobile344(String mobile) {
    if (isEmpty(mobile)) return '';
    mobile = mobile?.replaceAllMapped(new RegExp(r"(^\d{3}|\d{4}\B)"),
        (Match match) {
      return '${match.group(0)} ';
    });
    if (mobile != null && mobile.endsWith(' ')) {
      mobile = mobile.substring(0, mobile.length - 1);
    }
    return mobile;
  }

  static String assetsFilePath(String suffix) {
    switch (suffix) {
      case "pdf":
        return "images/fileicon_pdf.png";
        break;
      case "txt":
        return "images/fileicon_txt.png";
        break;
      case "mpeg":
      case "mp3":
      case "mpeg-4":
      case "midi":
      case "wma":
      case "3gpp":
        return "images/fileicon_music.png";
        break;
      case "mp4":
      case "avi":
        return "images/fileicon_video.png";
        break;
      case "ppt":
      case "pptx":
      case "dpt":
      case "dps":
      case "pot":
      case "pps":
        return "images/fileicon_ppt.png";
        break;
      case "docx":
      case "doc":
      case "dot":
      case "wps":
        return "images/fileicon_word.png";
        break;
      case "et":
      case "ett":
      case "xls":
      case "xlt":
      case "xlsx":
        return "images/fileicon_xls.png";
        break;
      case "zip":
      case "7z":
        return "images/fileicon_zip.png";
        break;
      default:
        return "images/fileicon_unkown.png";
        break;
    }
  }

  static String formatNum(double num, int position) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        position) {
      // 小数点后有几位小数
      return num.toStringAsFixed(position)
          .substring(0, num.toString().lastIndexOf(".") + position + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + position + 1)
          .toString();
    }
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
