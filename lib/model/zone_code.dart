class ZoneCode {
  String name;
  String code;
  String short;
  String en;
  String pinyin;

  static ZoneCode fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ZoneCode code = ZoneCode();

    code.name = map['name'];
    code.code = map['code'];
    code.short = map['short'];
    code.en = map['en'];
    code.pinyin = map['pinyin'];

    return code;
  }
}
