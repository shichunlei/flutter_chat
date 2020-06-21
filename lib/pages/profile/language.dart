import 'package:flutter/material.dart';

import '../../provider/index.dart';
import '../../generated/i18n.dart';

/// 语言设置
class LanguagePage extends StatefulWidget {
  const LanguagePage({Key key}) : super(key: key);

  @override
  createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  int localId;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        localId = Provider.of<ConfigProvider>(context, listen: false).localId;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ConfigProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).language), actions: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              width: 80,
              child: RaisedButton(
                  onPressed: () {
                    provider.setLocal(localId);
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).save,
                      style: TextStyle(color: Colors.white)),
                  color: Colors.green))
        ]),
        body: ListView.separated(
            itemBuilder: (_, index) => Material(
                color: Colors.white,
                child: InkWell(
                    child: Container(
                        height: 55.0,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: <Widget>[
                          Text(provider.list[index].title),
                          Spacer(),
                          Visibility(
                              visible: provider.list[index].id == localId,
                              child: Icon(Icons.check, color: Colors.green))
                        ])),
                    onTap: () =>
                        setState(() => localId = provider.list[index].id))),
            separatorBuilder: (_, index) => SizedBox(height: .5),
            itemCount: provider.list.length));
  }
}
