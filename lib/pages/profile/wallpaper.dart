import '../../commons/index.dart';
import '../../provider/index.dart';

import 'package:jmessage_flutter/jmessage_flutter.dart';

import 'package:flutter/material.dart';

/// 聊天背景设置
class WallpaperPage extends StatefulWidget {
  final JMConversationInfo chat;

  const WallpaperPage({Key key, @required this.chat}) : super(key: key);

  @override
  createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('聊天背景')),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.8),
            itemBuilder: (_, index) {
              return GestureDetector(
                  child: ImageView(bgImages[index],
                      width: double.infinity, height: double.infinity),
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .setChatBackground(widget.chat, bgImages[index]);
                    Navigator.maybePop(context);
                  });
            },
            itemCount: bgImages.length));
  }
}
