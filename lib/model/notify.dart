import 'user.dart';

/// id : 1
/// notify_type : "invite_received"
/// status : ""
/// reason : "请求添加您为好友"
/// created_time : "2020-06-11 13:51:28"
/// from : {"id":654,"name":"hch","mobile":"13522038091","avatar_url":"http://101.200.174.126:10000/data_cloud_system/users/avatars/654/medium/RackMultipart20200610-15636-1073is9.jpg?1591782301"}
/// user : {"id":6,"name":"煎饼果子","mobile":"18601952581","avatar_url":"http://101.200.174.126:10000/data_cloud_system/users/avatars/6/medium/RackMultipart20200610-15636-vsg00v.jpg?1591764055"}

class Notify {
  int id;
  String notifyType;
  String status;
  String reason;
  String createdTime;
  UserBean from;
  UserBean user;

  static Notify fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Notify notifyBean = Notify();
    notifyBean.id = map['id'];
    notifyBean.notifyType = map['notify_type'];
    notifyBean.status = map['status'];
    notifyBean.reason = map['reason'];
    notifyBean.createdTime = map['created_time'];
    notifyBean.from = UserBean.fromMap(map['from']);
    notifyBean.user = UserBean.fromMap(map['user']);
    return notifyBean;
  }

  Map toJson() => {
    "id": id,
    "notify_type": notifyType,
    "status": status,
    "reason": reason,
    "created_time": createdTime,
    "from": from,
    "user": user,
  };
}