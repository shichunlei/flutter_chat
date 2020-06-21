import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/commons/index.dart';
import 'package:flutter_chat/model/user.dart';

import '../commons/config.dart';
import '../utils/jpush_util.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  JMUserInfo _userInfo;

  JMUserInfo get userInfo => _userInfo;

  String _identifier = '';

  String get identifier => _identifier;

  /// 获取用户信息
  ///
  Future<void> getUserInfo() async {
    await jMessage.getMyInfo().then((JMUserInfo value) {
      _userInfo = value;

      _identifier = _userInfo.username;

      SpUtil.setString(Config.CURRENT_USERNAME, _identifier);

      print("getMyInfo=========>${_userInfo?.toJson()}");

      print("getMyInfo===avatarUrl======>${_userInfo.extras["avatarUrl"]}");

      print(
          "getMyInfo===addresses======>${_userInfo.extras["addresses"].toString()}");

      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('getMyInfo error => ${error.toString()}');
      }
    });
  }

  /// 更新昵称
  ///
  /// [nickname] 昵称
  ///
  Future<void> updateNickName(String nickname) async {
    await HttpUtils().post(
      APIs.UPDATE_NAME,
      (data) async {
        await jMessage
            .updateMyInfo(nickname: nickname)
            .then((value) => getUserInfo(), onError: (error) {
          if (error is PlatformException) {
            if (error.code == '871300') {
              print('没有登录');
            }
            print('updateNickName error => ${error.toString()}');
          }
        });
      },
      params: FormData.fromMap({"name": nickname, "identifier": identifier}),
      errorCallBack: (error) {
        print('uploadAvatar error => ${error.toString()}');
      },
    );
  }

  /// 更新性别
  ///
  /// [gender] 性别（JMGender 'male' | 'female' | 'unknown'）
  ///
  Future<void> updateGender(JMGender gender) async {
    await jMessage.updateMyInfo(gender: gender).then((value) => getUserInfo(),
        onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('updateGender error => ${error.toString()}');
      }
    });
  }

  /// 更新头像
  ///
  /// [path] 本地绝对路径
  ///
  Future<void> updateAvatar(String path) async {
    await jMessage.updateMyAvatar(imgPath: path).then((value) {
      getUserInfo();
      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('updateMyAvatar error => ${error.toString()}');
      }
    });
  }

  /// 更新头像
  ///
  /// [avatarUrl] 图片路径
  ///
  Future<void> updateAvatarUrl(String avatarUrl) async {
    Map<dynamic, dynamic> extras = userInfo.extras;

    extras["avatarUrl"] = avatarUrl;

    await jMessage.updateMyInfo(extras: extras).then((value) {
      getUserInfo();
      notifyListeners();
    }, onError: (error) {
      print('updateMyAvatar error => ${error.toString()}');
    });
  }

  /// 上传头像
  ///
  /// [path] 本地绝对路径
  ///
  Future<void> uploadAvatar(String path) async {
    String filename = path.substring(path.lastIndexOf("/") + 1, path.length);
    debugPrint(filename);

    await HttpUtils().post(
      APIs.UPDATE_AVATAR,
      (data) async {
        UserBean user = UserBean.fromMap(data);

        updateAvatarUrl(user.avatarUrl);
      },
      params: FormData.fromMap({
        "avatar": MultipartFile.fromFileSync(path, filename: filename),
        "identifier": identifier
      }),
      errorCallBack: (error) {
        print('uploadAvatar error => ${error.toString()}');
      },
    );
  }

  /// 更新地址
  ///
  /// [area] 地区
  /// [address] 详细地址
  ///
  Future<void> updateAddress(String area, String address) async {
    await jMessage
        .updateMyInfo(region: area, address: address)
        .then((value) => getUserInfo(), onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('updateAddress error => ${error.toString()}');
      }
    });
  }

  /// 更新生日
  ///
  /// [birthday] 生日
  ///
  Future<void> updateBirthday(int birthday) async {
    await jMessage
        .updateMyInfo(birthday: birthday)
        .then((value) => getUserInfo(), onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('updateBirthday error => ${error.toString()}');
      }
    });
  }

  /// 更新签名
  ///
  /// [signature] 签名
  ///
  Future<void> updateSignature(String signature) async {
    await jMessage
        .updateMyInfo(signature: signature)
        .then((value) => getUserInfo(), onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('updateSignature error => ${error.toString()}');
      }
    });
  }

  /// 更新地址
  ///
  /// [address] 地址对象
  /// [isCreate] 是否为新增地址
  ///
  Future<void> updateAddresses(
      Map<String, dynamic> address, bool isCreate) async {
    Map<dynamic, dynamic> extras = userInfo.extras;

    List<dynamic> addresses = json.decode(extras["addresses"]) as List ?? [];

    if (isCreate) {
      addresses.add(address);
    } else {
      int index =
          addresses.indexWhere((element) => element["id"] == address["id"]);

      addresses.setRange(index, index + 1, [address]);
    }

    extras["addresses"] = addresses;

    await jMessage.updateMyInfo(extras: extras).then((value) => getUserInfo(),
        onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('updateAddresses error => ${error.toString()}');
      }
    });
  }

  String thumbUserAvatar = '';

  /// 下载头像缩略文件
  ///
  /// [username] 要下载头像的用户唯一ID
  ///
  Future<void> downloadThumbUserAvatar(String username) async {
    await jMessage
        .downloadThumbUserAvatar(
            username: username, appKey: Config.JPUSH_APPKEY)
        .then((value) {
      Map resJson = value;
      thumbUserAvatar = resJson['filePath'];

      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('downloadThumbUserAvatar error => ${error.toString()}');
      }
    });
  }

  String originalUserAvatar = '';

  /// 下载头像原文件
  ///
  /// [username] 要下载头像的用户唯一ID
  ///
  Future<void> downloadOriginalUserAvatar(String username) async {
    await jMessage
        .downloadOriginalUserAvatar(
            username: username, appKey: Config.JPUSH_APPKEY)
        .then((value) {
      Map resJson = value;
      originalUserAvatar = resJson['filePath'];

      notifyListeners();
    }, onError: (error) {
      if (error is PlatformException) {
        if (error.code == '871300') {
          print('没有登录');
        }
        print('downloadOriginalUserAvatar error => ${error.toString()}');
      }
    });
  }
}
