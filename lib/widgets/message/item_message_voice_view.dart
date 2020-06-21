import '../../utils/jpush_util.dart';
import '../../utils/utils.dart';

import '../../commons/res/styles.dart';
import '../../commons/config.dart';
import '../../commons/res/colors.dart';

import 'package:flutter_sound_lite/flutter_sound_player.dart';

import 'package:flutter/material.dart';

class VoicePlayerView extends StatefulWidget {
  final MessageSendType type;
  final JMVoiceMessage message;
  final FlutterSoundPlayer player;

  VoicePlayerView({
    Key key,
    @required this.type,
    @required this.message,
    this.player,
  }) : super(key: key);

  @override
  createState() => _VoicePlayerViewState();
}

class _VoicePlayerViewState extends State<VoicePlayerView>
    with SingleTickerProviderStateMixin {
  var leftSoundNames = [
    'images/sound_left_0.png',
    'images/sound_left_1.png',
    'images/sound_left_2.png',
    'images/sound_left_3.png'
  ];

  var rightSoundNames = [
    'images/sound_right_0.png',
    'images/sound_right_1.png',
    'images/sound_right_2.png',
    'images/sound_right_3.png'
  ];

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    //控制语音动画
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = IntTween(begin: 0, end: 3)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
            if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: widget.type == MessageSendType.send
            ? Ink(
                decoration: BoxDecoration(
                    color: sendMessageColor,
                    borderRadius: borderRadius(MessageSendType.send)),
                child: InkWell(
                    borderRadius: borderRadius(MessageSendType.send),
                    onTap: () {
                      if (widget.player.isPlaying) {
                        stopPlayer();
                      } else {
                        startPlayer(widget.message.path);
                      }
                    },
                    child: Container(
                        alignment: Alignment.centerRight,
                        constraints: BoxConstraints(minWidth: Utils.width / 4),
                        padding: EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Text("${widget.message.extras['seconds']}''",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 5.0),
                          Image.asset(rightSoundNames[animation.value % 3],
                              height: 15, width: 15, color: Colors.white)
                        ], mainAxisSize: MainAxisSize.min))))
            : Ink(
                decoration: BoxDecoration(
                    color: Color(0xFFEEF7FD),
                    borderRadius: borderRadius(MessageSendType.receive)),
                child: InkWell(
                    borderRadius: borderRadius(MessageSendType.receive),
                    onTap: () {
                      if (widget.player.isPlaying) {
                        stopPlayer();
                      } else {
                        startPlayer(widget.message.path);
                      }
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        constraints: BoxConstraints(
                            minWidth: Utils.width / 3,
                            maxWidth: Utils.width / 2),
                        padding: EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Image.asset(leftSoundNames[animation.value % 3],
                              height: 15, width: 15, color: Colors.black54),
                          SizedBox(width: 5.0),
                          Text("${widget.message.extras['seconds']}''")
                        ], mainAxisSize: MainAxisSize.min)))));
  }

  void startPlayer(String voicePath) async {
    debugPrint("语音路径----------------$voicePath");

    if (widget.player.isPlaying) {
      stopPlayer();
    }

    String result =
        await widget.player.startPlayer(voicePath, whenFinished: () {
      debugPrint('I hope you enjoyed listening to this song');
      controller.reset();
      controller.stop();
    });

    debugPrint("startPlayer()====================$result");

    _addListeners();
  }

  void _addListeners() {
    widget.player.onPlayerStateChanged.listen((e) {
      if (null != e) {
        if (e.currentPosition == 0.0) {
          /// 开始播放
          /// 开启动画
          controller.forward();
        }
        debugPrint("currentPosition => ${e.currentPosition}");
        debugPrint("duration => ${e.duration}");
      }
    });
  }

  void stopPlayer() async {
    if (widget.player.isPlaying) {
      String result = await widget.player.stopPlayer();
      debugPrint("stopPlayer()================$result");
      controller.reset();
      controller.stop();
    }
  }
}
