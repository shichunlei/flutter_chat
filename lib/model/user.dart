import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';

/// id : 1
/// name : "张三"
/// avatar : "http://img1.touxiang.cn/uploads/20120831/31-071226_227.jpg"

class UserBean extends ISuspensionBean {
  int id;
  String name;
  String avatarUrl;
  String mobile;
  String identifier;

  String firstLetter;

  int checkedState;

  UserBean(
      {this.id,
      this.name,
      this.avatarUrl,
      this.mobile,
      this.identifier,
      this.firstLetter,
      this.checkedState = 0});

  static UserBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserBean userBean = UserBean();
    userBean.id = map['id'];
    userBean.name = map['name'];
    userBean.avatarUrl = map['avatar_url'];
    userBean.mobile = map['mobile'];
    userBean.identifier = map['identifier'];

    String tag = PinyinHelper.getPinyinE(map['name']).toUpperCase();
    if (RegExp("[A-Z]").hasMatch(tag)) {
      userBean.firstLetter = tag[0];
    } else {
      userBean.firstLetter = "#";
    }

    return userBean;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "avatar": avatarUrl,
        "mobile": mobile,
        "identifier": identifier,
        "firstLetter": firstLetter,
        "checkedState": checkedState,
      };

  @override
  String getSuspensionTag() => firstLetter;
}
