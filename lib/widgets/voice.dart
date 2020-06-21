import 'dart:async';

import '../utils/file_util.dart';
import '../utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound_recorder.dart';
import 'package:uuid/uuid.dart';

class VoiceWidget extends StatefulWidget {
  final Function(String audioPath, double audioTimeLength) onBackResult;

  const VoiceWidget({
    Key key,
    this.onBackResult,
  }) : super(key: key);

  @override
  createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  double startY = 0.0;

  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";

  String voiceIco = "images/voice_volume_1.png";

  /// 默认隐藏状态
  bool voiceState = true;

  bool isUp = false;

  OverlayEntry overlayEntry;

  FlutterSoundRecorder recorder;

  double currentPosition = 0.0;

  String durationTxt = '0:00:00';

  String path = '';

  String recorderResult = '';

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    recorder = FlutterSoundRecorder()
      ..initialize();

    String tempDir = await FileUtil.getInstance().getTempPath();

    path = "$tempDir/";
  }

  /// 开始语音录制的方法
  Future startRecorder() async {
    String fileName = "${Uuid().v1()}.aac";

    debugPrint("--------------------$path$fileName");

    try {
      recorderResult = await recorder.startRecorder(uri: "$path$fileName");

      debugPrint('startRecorder result => $recorderResult');

      recorder.onRecorderStateChanged.listen((e) {
        if (null != e) {
          this.setState(() {
            currentPosition = e.currentPosition;
            durationTxt = Duration(milliseconds: currentPosition.toInt())
                    ?.toString()
                    ?.split('.')
                    ?.first ??
                '0:00:00';

            debugPrint("durationTxt => $durationTxt");
          });
        }
      });

      /// 录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
      recorder.onRecorderDbPeakChanged.listen((double value) {
        debugPrint("onRecorderDbPeakChanged update -> $value");
        if (value == null) value = 0.0;

        double voiceData = value / 120.0;
        setState(() {
          if (voiceData > 0 && voiceData < 0.1) {
            voiceIco = "images/voice_volume_2.png";
          } else if (voiceData > 0.2 && voiceData < 0.3) {
            voiceIco = "images/voice_volume_3.png";
          } else if (voiceData > 0.3 && voiceData < 0.4) {
            voiceIco = "images/voice_volume_4.png";
          } else if (voiceData > 0.4 && voiceData < 0.5) {
            voiceIco = "images/voice_volume_5.png";
          } else if (voiceData > 0.5 && voiceData < 0.6) {
            voiceIco = "images/voice_volume_6.png";
          } else if (voiceData > 0.6 && voiceData < 0.7) {
            voiceIco = "images/voice_volume_7.png";
          } else if (voiceData > 0.7 && voiceData < 1) {
            voiceIco = "images/voice_volume_7.png";
          } else {
            voiceIco = "images/voice_volume_1.png";
          }
          if (overlayEntry != null) {
            overlayEntry.markNeedsBuild();
          }
        });

        debugPrint("振幅大小   " + voiceData.toString() + "  " + voiceIco);
      });
    } catch (err) {
      debugPrint('startRecorder error: $err');
    }
  }

  /// 停止语音录制的方法
  Future stopRecorder() async {
    try {
      String result = await recorder.stopRecorder();
      debugPrint('stopRecorder result => $result');

      setState(() {
        durationTxt = '0:00:00';
      });
      if (!isUp && currentPosition > 1000) {
        widget.onBackResult(recorderResult, currentPosition / 1000);
      }
    } catch (err) {
      debugPrint('stopRecorder error: $err');
    }
  }

  /// 显示录音悬浮布局
  buildOverLayView(BuildContext context, String toast) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        return Positioned(
            top: Utils.height * 0.5 - 80,
            left: Utils.width * 0.5 - 80,
            child: Material(
                type: MaterialType.transparency,
                child: Center(
                    child: Opacity(
                        opacity: 0.8,
                        child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                color: Color(0xff77797A),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: Column(children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Image.asset(voiceIco,
                                      width: 100, height: 100)),
                              Container(
                                  child: Text(toast,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white,
                                          fontSize: 14)))
                            ]))))));
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  showVoiceView() {
    debugPrint("startY => $startY");
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });
    buildOverLayView(context, toastShow);
    startRecorder();
  }

  hideVoiceView() {
    setState(() {
      textShow = "按住说话";
      voiceState = true;
      toastShow = "手指上滑,取消发送";
    });

    stopRecorder();

    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  moveVoiceView() {
    if (isUp) {
      textShow = "松开手指,取消发送";
      toastShow = "松开手指,取消发送";
    } else {
      textShow = "松开结束";
      toastShow = "手指上滑,取消发送";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (details) {
          startY = details.globalPosition.dy;
          showVoiceView();
        },
        onVerticalDragDown: (details) {
          startY = details.globalPosition.dy;
          showVoiceView();
        },
        onVerticalDragCancel: () => hideVoiceView(),
        onVerticalDragEnd: (details) => hideVoiceView(),
        onVerticalDragUpdate: (details) {
          isUp = startY - details.globalPosition.dy > 100;

          print("===============> $isUp");

          moveVoiceView();
        },
        child: Container(
            alignment: Alignment.center,
            height: 200,
            margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Column(children: [
              Text("$durationTxt"),
              SizedBox(height: 30),
              Text("$textShow")
            ], mainAxisSize: MainAxisSize.min)));
  }

  @override
  void dispose() {
    recorder?.release();
    super.dispose();
  }
}
