import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class Loading extends StatefulWidget {
  Indicator indicator;
  final double size;
  final Color color;

  Loading({this.indicator, this.size = 50.0, this.color = Colors.white}) {
    this.indicator = indicator;
  }

  @override
  createState() => LoadingState(indicator, size);
}

class LoadingState extends State<Loading> with TickerProviderStateMixin {
  Indicator indicator;
  double size;

  LoadingState(this.indicator, this.size);

  @override
  void initState() {
    super.initState();
    indicator.context = this;
    indicator.start();
  }

  @override
  void dispose() {
    indicator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(indicator, widget.color),
      size: Size.square(size),
    );
  }
}

class _Painter extends CustomPainter {
  Indicator indicator;
  Color color;
  Paint defaultPaint;

  _Painter(this.indicator, this.color) {
    defaultPaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    indicator.paint(canvas, defaultPaint, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

abstract class Indicator {
  LoadingState context;
  List<AnimationController> animationControllers;

  paint(Canvas canvas, Paint paint, Size size);

  List<AnimationController> animation();

  void postInvalidate() {
    context.setState(() {});
  }

  void start() {
    animationControllers = animation();
    if (animationControllers != null) {
      startAnims(animationControllers);
    }
  }

  void dispose() {
    if (animationControllers != null) {
      for (var i = 0; i < animationControllers.length; i++) {
        animationControllers[i].dispose();
      }
    }
  }

  void startAnims(List<AnimationController> controllers) {
    for (var i = 0; i < controllers.length; i++) {
      startAnim(controllers[i]);
    }
  }

  void startAnim(AnimationController controller) {
    controller.repeat();
  }
}

class PulseOutIndicator extends Indicator {
  var scaleYDoubles = [
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0,
    1.0
  ];
  int pulseLength = 20;

  @override
  paint(Canvas canvas, Paint paint, Size size) {
    var translateX = size.width / 11;
    var translateY = size.height / 2;
    for (int i = 0; i < pulseLength; i++) {
      canvas.save();
      canvas.translate((2 + i * 2) * translateX - translateX / 2, translateY);
      canvas.scale(1.0, scaleYDoubles[i]);
      var rectF = RRect.fromLTRBR(-translateX / 2, -size.height / 2.5,
          translateX / 2, size.height / 2.5, Radius.circular(5));
      canvas.drawRRect(rectF, paint);
      canvas.restore();
    }
  }

  @override
  List<AnimationController> animation() {
    var controllers = List<AnimationController>();
    for (int i = 0; i < pulseLength; i++) {
      var sizeController = new AnimationController(
          duration: Duration(milliseconds: 200), vsync: context);
      var alphaTween = new Tween(begin: 1.0, end: 0.3).animate(sizeController);
      sizeController.addListener(() {
        scaleYDoubles[i] = alphaTween.value;
        postInvalidate();
      });
      controllers.add(sizeController);
    }
    return controllers;
  }

  @override
  startAnims(List<AnimationController> controllers) {
    var delays = [
      1000,
      850,
      700,
      550,
      400,
      250,
      100,
      50,
      0,
      0,
      0,
      0,
      0,
      50,
      100,
      250,
      400,
      550,
      700,
      850,
      1000
    ];
    for (var i = 0; i < controllers.length; i++) {
      Future.delayed(Duration(milliseconds: delays[i]), () {
        if (context.mounted) controllers[i].repeat(reverse: true);
      });
    }
  }
}

typedef startRecord = Future Function();
typedef stopRecord = Future Function();

class VoiceWidget extends StatefulWidget {
  final Function startRecord;
  final Function stopRecord;

  /// startRecord 开始录制回调  stopRecord回调
  const VoiceWidget({Key key, this.startRecord, this.stopRecord})
      : super(key: key);

  @override
  createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  String textShow = "按住 说话";
  String toastShow = "手指上滑,取消发送";

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry overlayEntry;

//  FlutterPluginRecord recordPlugin;

  @override
  void initState() {
    super.initState();
//    recordPlugin = FlutterPluginRecord();
    _init();

    ///初始化方法的监听
//    recordPlugin.responseFromInit.listen((data) {
//      if (data) {
//        print("初始化成功");
//      } else {
//        print("初始化失败");
//      }
//    });

    /// 开始录制或结束录制的监听
//    recordPlugin.response.listen((data) {
//      if (data.msg == "onStop") {
//        ///结束录制时会返回录制文件的地址方便上传服务器
//        print("onStop  " + data.path);
//        widget.stopRecord(data.path, data.audioTimeLength);
//      } else if (data.msg == "onStart") {
//        widget.startRecord();
//      }
//    });
  }

  ///显示录音悬浮布局
  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          toastShow,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 40),
                        alignment: Alignment.centerLeft,
                        child: Loading(
                          indicator: PulseOutIndicator(),
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  showVoiceView() {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });
    buildOverLayView(context);
    start();
  }

  hideVoiceView() {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    stop();
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
    }
  }

  moveVoiceView() {
    // print(offset - start);
    setState(() {
      isUp = starty - offset > 100 ? true : false;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开 结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  ///初始化语音录制的方法
  void _init() async {
//    recordPlugin.init();
  }

  ///开始语音录制的方法
  void start() async {
//    recordPlugin.start();
  }

  ///停止语音录制的方法
  void stop() {
//    recordPlugin.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onVerticalDragStart: (details) {
              starty = details.globalPosition.dy;
              showVoiceView();
            },
            onVerticalDragDown: (details) {
              starty = details.globalPosition.dy;
              showVoiceView();
            },
            onVerticalDragCancel: () => hideVoiceView(),
            onVerticalDragEnd: (details) => hideVoiceView(),
            onVerticalDragUpdate: (details) {
              offset = details.globalPosition.dy;
              moveVoiceView();
            },
            child: Container(
                margin: const EdgeInsets.only(top: 2, bottom: 2),
                child: FlatButton(
                    color: Colors.white,
                    child: Text(textShow,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600])),
                    onPressed: () {}))));
  }

  @override
  void dispose() {
//    if (recordPlugin != null) {
//      recordPlugin.dispose();
//    }
    super.dispose();
  }
}
