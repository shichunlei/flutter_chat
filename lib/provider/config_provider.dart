import 'package:flutter/material.dart';

import '../commons/index.dart';
import '../model/language.dart';

class ConfigProvider extends ChangeNotifier {
  int _localId = 1;

  List<Language> _list = [];

  List<Language> get list => _list;

  void init() {
    getLanguages();

    _localId = SpUtil.getInt(Config.KEY_LOCALE, defValue: 1);
    debugPrint('Config get Local $_localId');

    _landscapeDisplay =
        SpUtil.getBool(Config.KEY_LANDSCAPE_DISPLAY, defValue: false);

    debugPrint('Config get LandscapeDisplay $_landscapeDisplay');

    _autoUpdate = SpUtil.getBool(Config.KEY_AUTO_UPDATE, defValue: true);

    debugPrint('Config get AutoUpdate $_autoUpdate');

    _viewable = SpUtil.getString(Config.KEY_VIEWABLE, defValue: 'all');

    debugPrint('Config get Viewable $_viewable');

    _language = _list.firstWhere((element) => element.id == _localId).title;
  }

  int get localId => _localId;

  Future setLocal(int localId) async {
    debugPrint('config set Local $localId');
    _localId = localId;
    SpUtil.setInt(Config.KEY_LOCALE, localId);

    _language = _list.firstWhere((element) => element.id == _localId).title;

    notifyListeners();
  }

  String _language;

  String get language => _language;

  void getLanguages() {
    _list.add(Language(id: 1, title: '跟随系统', locale: null, desc: "跟随系统"));
    _list.add(
        Language(id: 2, title: '简体中文', locale: Locale('zh', 'CN'), desc: "大陆"));
    _list.add(Language(
        id: 3, title: '繁體中文（台灣）', locale: Locale('zh', 'TW'), desc: "台湾"));
    _list.add(Language(
        id: 4, title: '繁體中文（香港）', locale: Locale('zh', 'HK'), desc: "香港"));
    _list.add(Language(
        id: 5, title: 'English', locale: Locale('en', ''), desc: "英语"));
    _list.add(Language(
        id: 6, title: '日本语', locale: Locale('ja', 'JP'), desc: "日语（日本）"));
    _list.add(Language(id: 7, title: '한국어', locale: null, desc: "朝鲜语（朝鲜）"));
    _list.add(Language(id: 8, title: '한글', locale: null, desc: "韩语（韩国）"));
    _list.add(Language(id: 9, title: 'ภาษาไทย', locale: null, desc: "泰语"));
    _list.add(Language(
        id: 10, title: 'Bahasa Malaysia', locale: null, desc: "马来语（马来西亚/文莱）"));
    _list.add(Language(
        id: 11, title: 'Bahasa Indonesia', locale: null, desc: "印尼语（印度尼西亚）"));
    _list.add(Language(
        id: 12, title: 'Español', locale: null, desc: "西班牙语（西班牙、奥地利）"));
    _list.add(Language(
        id: 13, title: 'Italiano', locale: null, desc: "意大利语（意大利、圣马力诺）"));
    _list.add(Language(id: 14, title: 'Português', locale: null, desc: "葡萄牙语"));
    _list.add(Language(id: 15, title: 'Tiếng Việt', locale: null, desc: "越南语"));
    _list.add(Language(id: 16, title: 'Türkçe', locale: null, desc: "土耳其语"));
    _list.add(Language(id: 17, title: 'Deutsch', locale: null, desc: "德语"));
    _list.add(Language(id: 18, title: 'Français', locale: null, desc: "法语"));
    _list.add(
        Language(id: 19, title: 'اللغة العربية', locale: null, desc: "阿拉伯语"));
    _list.add(
        Language(id: 20, title: 'বাংলা/বাঙালী', locale: null, desc: "孟加拉语"));
    _list.add(Language(id: 21, title: 'Қазақ', locale: null, desc: "哈萨克语"));
    _list.add(Language(id: 22, title: 'فارسی', locale: null, desc: "波斯语"));

    notifyListeners();
  }

  bool _landscapeDisplay;

  bool get landscapeDisplay => _landscapeDisplay;

  Future setLandscapeDisplay(bool display) async {
    _landscapeDisplay = display;
    SpUtil.setBool(Config.KEY_LANDSCAPE_DISPLAY, _landscapeDisplay);
    notifyListeners();
  }

  bool _autoUpdate;

  bool get autoUpdate => _autoUpdate;

  Future setAutoUpdate(bool autoUpdate) async {
    _autoUpdate = autoUpdate;
    SpUtil.setBool(Config.KEY_AUTO_UPDATE, _autoUpdate);
    notifyListeners();
  }

  String _viewable = 'all';

  String get viewable => _viewable;

  Future setViewable(String value) async {
    _viewable = value;
    SpUtil.setString(Config.KEY_VIEWABLE, _viewable);
    notifyListeners();
  }
}
