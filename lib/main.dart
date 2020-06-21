import 'dart:async';
import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'commons/index.dart';
import 'generated/i18n.dart';

import 'pages/splash.dart';
import 'provider/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SpUtil.getInstance();

  await JPushUtil.jMessageInit();

  await enableFluttifyLog(false);
  await AmapService.init(
      iosKey: Config.AMAP_KEY_IOS, androidKey: Config.AMAP_KEY_ANDROID);

  runZoned(() {
    /// 设置竖屏
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => ConfigProvider()..init()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ContactProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => ChatProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => PoiProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => UserProvider()),
        ],
        child: MyApp(),
      ));

      if (Platform.isAndroid) {
        // 以下两行 设置android状态栏为透明的沉浸。
        // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
        SystemUiOverlayStyle systemUiOverlayStyle =
            SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    });
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigProvider>(
        builder: (context, ConfigProvider provider, child) {
      return MaterialApp(
          title: '仿微信',
          theme: ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.light,
              primaryColor: Colors.white,
              backgroundColor: Color(0xFFFAFAFA),
              appBarTheme: AppBarTheme(color: Colors.white, elevation: .5)),

          /// 右上角显示一个debug的图标
          debugShowCheckedModeBanner: false,

          /// 主页
          home: SplashPage(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            S.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,

          /// 不存对应locale时，默认取值Locale('zh', 'CN')
          localeResolutionCallback:
              S.delegate.resolution(fallback: const Locale("zh", "CN")),
          locale: provider.list
              .firstWhere((element) => element.id == provider.localId)
              .locale);
    });
  }
}
