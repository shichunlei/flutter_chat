class Config {
  /// 高德地图APP_KEY
  static const String AMAP_KEY_IOS = "e33c105c009833c0274d629752eef7ab";
  static const String AMAP_KEY_ANDROID = "4ceb4e9c86fb6594bc2889c31e457e9e";

  /// 极光APP_KEY
  static const String JPUSH_APPKEY = "a8ba7cecf49a151eea56c1e2";

  static const String COPY = 'copy';
  static const String FORWARD = 'forward';
  static const String RECALL = 'recall';
  static const String REMOVE = 'remove';
  static const String QUOTE = 'quote';
  static const String SELECT = 'select';

  /// 记录登录状态
  static const String IS_LOGIN = '_IS_LOGIN_';

  /// 当前登录用户的唯一标志
  static const String CURRENT_USERNAME = '_CURRENT_USERNAME_';

  /// 记录当前语言
  static const String KEY_LOCALE = 'key_support_locale';

  /// 记录是否可以横屏显示
  static const String KEY_LANDSCAPE_DISPLAY = "_key_landscape_display_";

  /// 记录是否自动下载微信安装包
  static const String KEY_AUTO_UPDATE = "_key_auto_update_";

  /// 允许好友查看朋友圈的时间范围
  static const String KEY_VIEWABLE = '_KEY_VIEWABLE_';

  /// 键盘高度
  static const String KEY_KEYBOARD_HEIGHT = '_KEY_KEYBOARD_HEIGHT_';

  /// 极光IM密码
  static const String JMESSAGE_PASSWORD = '123456';
}

enum MessageSendType { send, receive }

/// 聊天背景壁纸
List<String> bgImages = [
  'http://attach.bbs.miui.com/forum/201711/01/122907eoiukcg6uncim5ce.png',
  'http://d.paper.i4.cn/max/2017/05/05/11/1493953752203_586482.jpeg',
  'http://attach.bbs.miui.com/forum/201708/17/151436skff2zrx0h9hhowx.jpg',
  'http://attach.bbs.miui.com/forum/201511/10/105813tmu2km2gmxabnu81.jpg',
  'http://d.paper.i4.cn/max/2016/09/07/15/1473233661081_550725.jpg',
  'http://d.paper.i4.cn/max/2016/12/05/15/1480921218297_301280.JPG',
  'http://bbsimg.res.flyme.cn/forum/201506/06/143028rbj1kfe7fkqajtfe.jpg',
  'http://d.paper.i4.cn/max/2016/12/05/14/1480919703852_915379.jpeg',
  'http://d.paper.i4.cn/max/2016/11/30/14/1480488032780_389164.jpeg',
  'http://attach.bbs.miui.com/forum/201605/10/201206z00qtc8dth0kvvi1.jpg'
];

const String groupHeaderImage =
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591770312939&di=0899c57d005c81a1d967be48d227a7cd&imgtype=0&src=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D1024504869%2C25874000%26fm%3D214%26gp%3D0.jpg';
