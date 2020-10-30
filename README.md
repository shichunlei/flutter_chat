# flutter_chat

利用极光IM实现的仿微信APP

`声明：本项目仅供学习，如有侵权请联系本人进行删除。`


## 联系我们
### QQ群：

![](https://github.com/shichunlei/project_image/blob/master/QQ20200121110501.png)


### 个人联系方式：

    手机号码：18601952581（微信同号）
    QQ：1558053958
    邮箱：1558053958@qq.com

    可承接一些中小型项目、毕业设计等


# Flutter版仿微信APP主要功能点

* [x] 账号注册
* [x] 账号登录
* [x] 账号登出
* [x] 国际化（中简、台繁、港繁、英语）
* [x] 文字消息
* [x] 图片消息（相册、拍照）
* [x] 语音消息
* [x] 位置消息
* [x] 文件消息
* [x] 名片消息
* [x] 表情消息
* [x] 会话列表
* [x] 删除会话
* [x] 通讯录
* [x] 搜索好友
* [x] 添加好友
* [x] 删除好友
* [x] 好友信息
* [x] 设置好友备注
* [x] 更改个人信息（头像、昵称、性别、生日、地区、个性签名）
* [x] 黑名单
* [x] 创建群聊
* [x] 群聊
* [x] 群聊信息展示
* [x] 修改群聊信息
* [ ] 群聊成员管理
* [ ] 视频拍摄
* [ ] 视频消息
* [ ] 扫一扫
* [ ] 国际化（日语）
* [x] 发现板块界面搭建
* [ ] 发现板块界面逻辑
* [x] 设置板块界面搭建
* [ ] 设置板块界面逻辑



# 使用教程

*  使用命令（拉取项目）：$ git clone https://github.com/shichunlei/flutter_chat.git
*  然后命令（获取依赖）：$ flutter packages get  (IOS执行IOS部分再执行下一步)
*  最后命令（运行）：$ flutter run

IOS
*  进入项目IOS目录：$ cd ios/
*  更新Pod（非必须）：$ pod update
*  安装Pod：$ pod install

如果出现`(Connection refused - connect(2) for "raw.githubusercontent.com" port 443)`，则表示还没设置国内源，
或者尝试下翻墙。


## 我的Flutter运行环境

```
Flutter (Channel stable, 1.22.1, on Mac OS X 10.15.4 19E287, locale zh-Hans-CN)
    • Flutter version 1.22.1 at /System/Volumes/Data/workspace/flutter
    • Framework revision f30b7f4db9 (3 周前), 2020-10-08 10:06:30 -0700
    • Engine revision 75bef9f6c8
    • Dart version 2.10.1
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn


[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.2)
    • Android SDK at /Users/developer/Library/Android/sdk
    • Platform android-30, build-tools 30.0.2
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_212-release-1586-b4-5784211)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 11.7)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 11.7, Build version 11E801a
    • CocoaPods version 1.9.1

[✓] Android Studio (version 3.6)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin version 49.0.1
    • Dart plugin version 192.8052
    • Java version OpenJDK Runtime Environment (build 1.8.0_212-release-1586-b4-5784211)

[✓] Connected device (3 available)
    • MI 5X      • 1c7664100104 • android-arm64  • Android 8.1.0 (API 27)
    • iPhone 11 Pro Max • B366D105-9EEC-47E4-A0CE-94C43E9ACD2D • ios • com.apple.CoreSimulator.SimRuntime.iOS-13-2 (simulator)
```


## 注意事项

- 如果你还没有升级flutter版本到1.17.0，那么就把provider的版本改为4.0.5+1

- 项目中某些接口为http url，Android 9.0/P和iOS禁止从非https网址加载，故需更改 App 的网络安全配置以允许此类连接

__Android__

在 res 下新增一个 xml 目录，创建[network_security_config.xml](https://github.com/shichunlei/flutter_app/blob/master/android/app/src/main/res/xml/network_security_config.xml)文件


```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

在[AndroidManifest.xml](https://github.com/shichunlei/flutter_app/blob/master/android/app/src/main/AndroidManifest.xml)文件下的application标签增加以下属性

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
/>
```

__iOS__


在[Info.plist](https://github.com/shichunlei/flutter_app/blob/master/ios/Runner/Info.plist)下编辑


```plist
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```


## 赞赏

如果您喜欢我的Flutter版仿微信App，或感觉帮助到了您，可以点右上角“Star”支持一下，您的支持就是我的动力，谢谢🙂

您也可以扫描下面的二维码，请作者喝杯咖啡☕️


- 先领个红包

|![1](https://github.com/shichunlei/project_image/blob/master/admire-for/781564454769_.pic.jpg)|![2](https://github.com/shichunlei/project_image/blob/master/admire-for/811564454769_.pic.jpg)|
| :--: | :--: |


|![1](https://github.com/shichunlei/project_image/blob/master/admire-for/771564454769_.pic.jpg)|![2](https://github.com/shichunlei/project_image/blob/master/admire-for/801564454769_.pic.jpg)|![3](https://github.com/shichunlei/project_image/blob/master/admire-for/761564454769_.pic_hd.jpg)|![4](https://github.com/shichunlei/project_image/blob/master/admire-for/821564454769_.pic.jpg)|
| :--: | :--: | :--: | :--: |


## 特别鸣谢


- [fluttercandies/wechat_flutter](https://github.com/fluttercandies/wechat_flutter)



## 许可证

[Apache 2.0](https://github.com/shichunlei/flutter_app/blob/master/LICENSE)
