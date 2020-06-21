import 'package:flutter/material.dart';

class Language {
  int id;
  String title;

  Locale locale;

  String desc;

  Language({this.id, this.title, this.locale, this.desc});

  static Language fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Language l = Language();

    l.id = map['id'];
    l.title = map['title'];
    l.desc = map['desc'];

    if (map['languageCode'] == "") {
      l.locale = null;
    } else {
      l.locale = Locale(map['languageCode'], map['countryCode']);
    }

    return l;
  }
}
