import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';

import '../../commons/index.dart';

class FileMessageView extends StatelessWidget {
  final JMFileMessage message;
  final MessageSendType type;

  const FileMessageView({Key key, @required this.message, @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            height: 85.0,
            constraints: BoxConstraints(maxWidth: Utils.width / 1.5),
            decoration: BoxDecoration(
                borderRadius: borderRadius(type),
                color: type == MessageSendType.send
                    ? sendMessageColor
                    : Color(0xFFEEF7FD)),
            padding: EdgeInsets.all(8.0),
            child: Row(children: <Widget>[
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Expanded(
                        child: Text(message.fileName,
                            style: Theme.of(context).textTheme.subtitle1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                    SizedBox(height: 5),
                    Text(message.extras["size"],
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: type == MessageSendType.send
                                ? Colors.white54
                                : Colors.grey))
                  ])),
              SizedBox(width: 15),
              Container(
                  width: 45.0,
                  color: Colors.white,
                  child: Image.asset(
                      Utils.assetsFilePath(message.extras["suffix"])))
            ])),
        onTap: () async {
          bool isExists = await FileUtil.getInstance()
              .fileExists(message.extras["filePath"]);

          if (isExists) {
            OpenFile.open(message.extras["filePath"]);
          } else {
            /// 先下载文件再打开
            print("======文件不存在======${message.extras["filePath"]}=");
          }
        });
  }
}
