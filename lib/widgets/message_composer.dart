import 'dart:io';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../generated/i18n.dart';

import '../commons/iconfont.dart';
import '../commons/ui/dialog.dart';

import '../model/user.dart';
import '../model/position.dart';

import '../pages/position/search_position.dart';
import '../pages/contacts/select_contacts.dart';

import '../provider/index.dart';

import '../utils/route_util.dart';
import '../utils/utils.dart';
import '../utils/jpush_util.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'voice.dart';

class MessageComposerView extends StatefulWidget {
  final JMConversationInfo chat;

  MessageComposerView({Key key, @required this.chat}) : super(key: key);

  @override
  createState() => _MessageComposerViewState();
}

class _MessageComposerViewState extends State<MessageComposerView> {
  final _controller = TextEditingController();

  FocusNode _focusNode = FocusNode();

  bool showTools = false;
  bool showEmoji = false;
  bool showVoice = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = Provider.of<ChatProvider>(context, listen: false);

    return Material(
        color: Colors.white,
        child: Column(children: <Widget>[
          /// 输入框
          Container(
              height: 60.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Row(children: <Widget>[
                GestureDetector(
                    child:
                        Image.asset('images/attach.png', width: 34, height: 34),
                    onTap: () {
                      setState(() {
                        if (!showTools) {
                          showTools = true;
                          if (_focusNode.hasFocus) _focusNode.unfocus();
                        } else {
                          showTools = false;

                          if (!_focusNode.hasFocus)
                            FocusScope.of(context).requestFocus(_focusNode);
                        }
                        if (showEmoji) showEmoji = false;
                        if (showVoice) showVoice = false;
                      });
                    }),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color(0xFFF4F4F4)),
                        child: Row(children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                if (!showEmoji) {
                                  showEmoji = true;
                                  if (_focusNode.hasFocus) _focusNode.unfocus();
                                } else {
                                  showEmoji = false;

                                  if (!_focusNode.hasFocus)
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                }
                                if (showVoice) showVoice = false;
                                if (showTools) showTools = false;
                                setState(() {});
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(IconFont.smiley,
                                      size: 25, color: Color(0xFF2CB9B0)))),
                          Expanded(
                            child: Stack(children: <Widget>[
                              TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration.collapsed(
                                      hintText:
                                          S.of(context).hint_type_message),
                                  onSubmitted: (value) {
                                    snapshot.sendTextMessage(
                                        widget.chat, value);
                                    _controller.text = "";
                                  },
                                  onChanged: (value) {
                                    if (_focusNode.hasFocus) {
                                      if (showTools) showTools = false;
                                      if (showEmoji) showEmoji = false;
                                      if (showVoice) showVoice = false;

                                      setState(() {});
                                    }
                                  }),
                              Visibility(
                                  visible: !_focusNode.hasFocus,
                                  child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(_focusNode);
                                        if (showTools) showTools = false;
                                        if (showEmoji) showEmoji = false;
                                        if (showVoice) showVoice = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          height: double.infinity)))
                            ]),
                          ),
                          GestureDetector(
                              onTap: _controller.text.length > 0
                                  ? () {
                                      snapshot.sendTextMessage(
                                          widget.chat, _controller.text);
                                      _controller.text = "";
                                    }
                                  : null,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.send,
                                      size: 25,
                                      color: _controller.text.length > 0
                                          ? Color(0xFF2CB9B0)
                                          : Colors.grey)))
                        ])))
              ])),

          /// tools
          Visibility(
              visible: showTools,
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[
                    /// voice
                    InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(IconFont.voice)),
                        onTap: () {
                          showVoice = true;
                          if (showEmoji) showEmoji = false;
                          if (showTools) showTools = false;
                          if (_focusNode.hasFocus) _focusNode.unfocus();
                          setState(() {});
                        }),

                    /// 相册
                    InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(IconFont.gallery)),
                        onTap: () => _onImageButtonPressed(
                            context, snapshot, ImageSource.gallery)),

                    /// 相机
                    InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(IconFont.camera)),
                        onTap: () => _onImageButtonPressed(
                            context, snapshot, ImageSource.camera)),

                    /// 名片
                    InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(IconFont.id_card)),
                        onTap: () => pushNewPage(context, SelectContactsPage(),
                                callBack: (UserBean cardUser) {
                              if (cardUser != null) {
                                /// 弹出对话框用户确定
                                showNameCardDialog(
                                    context, cardUser, widget.chat, snapshot);
                              }
                            })),

                    /// 位置
                    InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(IconFont.location)),
                        onTap: () {
                          showLocationMessageDialog(context,
                              callBack: (bool, way) {
                            Navigator.pop(context);

                            if (bool && way == 'share') {
                              /// TODO 共享地址

                            } else if (bool && way == 'send') {
                              pushNewPage(context, SearchPositionPage(),
                                  callBack: (Position location) {
                                if (location != null)
                                  snapshot.sendLocationMessage(
                                      widget.chat,
                                      15,
                                      location.poi.latLng.longitude,
                                      location.poi.latLng.latitude,
                                      location.poi.title);
                              });
                            }
                          });
                        }),

                    /// 文件
                    InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.folder_open)),
                        onTap: () async {
                          await FilePicker.getFile(
                              type: FileType.custom,
                              allowedExtensions: [
                                'pdf',
                                "doc",
                                "xls",
                                "ppt",
                                "mp3"
                              ]).then((File file) async {
                            if (file != null) {
                              String path = file.path;

                              String suffix = path.substring(
                                  path.lastIndexOf(".") + 1, path.length);

                              if (["jpg", "png", "jpeg"]
                                  .contains(suffix.toLowerCase())) {
                                snapshot.sendImageMessage(widget.chat, path);
                              } else {
                                double size = await file.length() / 1024.0;

                                String sizeStr = '';

                                if (size >= 1024) {
                                  sizeStr =
                                      "${Utils.formatNum(size / 1024.0, 2)} MB";
                                } else {
                                  sizeStr = "${Utils.formatNum(size, 2)} KB";
                                }

                                snapshot.sendFileMessage(widget.chat, path,
                                    suffix.toLowerCase(), sizeStr);
                              }
                            }
                          }, onError: (error) {
                            print("error => ${error.toString()}");
                          });
                        }),
                  ], mainAxisAlignment: MainAxisAlignment.spaceAround))),

          /// Emoji
          Visibility(
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: _buildEmojiPanelComposer()),
              visible: showEmoji),

          /// voice
          Visibility(
              child: VoiceWidget(
                  onBackResult: (path, time) => snapshot.sendVoiceMessage(
                      widget.chat, path, time.toInt())),
              visible: showVoice),
          SizedBox(height: Utils.bottomSafeHeight)
        ]));
  }

  Widget _buildEmojiPanelComposer() {
    return EmojiPicker(
        rows: 3,
        columns: 7,
        recommendKeywords: ["racing", "horse"],
        numRecommended: 10,
        onEmojiSelected: (Emoji emoji, Category category) {
          _controller.text = _controller.text + emoji.emoji;
        });
  }

  /// 选择图片
  ///
  /// [context] 上下文
  /// [source] 资源
  ///
  Future _onImageButtonPressed(
      BuildContext context, ChatProvider snapshot, ImageSource source) async {
    ImagePicker().getImage(source: source).then((file) {
      if (file != null) snapshot.sendImageMessage(widget.chat, file.path);
    });
  }
}
