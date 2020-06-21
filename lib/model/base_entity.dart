class BaseResult<T> {
  String code;
  String message;
  T data;

  BaseResult({this.code, this.message, this.data});

  static BaseResult fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    BaseResult result = BaseResult();
    result.code = '${map['code']}';
    result.message = map['message'];
    result.data = map['data'];
    return result;
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}
