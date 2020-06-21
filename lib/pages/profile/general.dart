import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/profile/textsize.dart';

import '../../commons/index.dart';

import '../../provider/index.dart';
import '../../generated/i18n.dart';

import 'language.dart';

/// 通用设置
class GeneralPage extends StatefulWidget {
  const GeneralPage({Key key}) : super(key: key);

  @override
  createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var config = Provider.of<ConfigProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).general)),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              SwitchTitleView(
                  padding: EdgeInsets.only(right: 5, left: 20),
                  title: S.of(context).landscapeDisplay,
                  onChanged: (bool value) => config.setLandscapeDisplay(value),
                  isChecked: config.landscapeDisplay),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).autoUpdate,
                  content: config.autoUpdate ? "Wi-Fi Only" : "从不",
                  margin: EdgeInsets.only(left: 20, right: 5),
                  onTap: () => showAutoUpdateDialog(context, (bool value) {
                        config.setAutoUpdate(value);
                        Navigator.maybePop(context);
                      })),
              SizedBox(height: .5),
              SelectedText(
                  title: S.of(context).language,
                  content: config.language,
                  onTap: () => pushNewPage(context, LanguagePage()),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () => pushNewPage(context, TextSizeSettingPage()),
                  title: S.of(context).textSize,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () {},
                  title: S.of(context).photos_videos_files,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () {},
                  title: S.of(context).manage_discover,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () {},
                  title: S.of(context).tools,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () {},
                  title: S.of(context).date_usage,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              SizedBox(height: .5),
              SelectedText(
                  onTap: () {},
                  title: S.of(context).manage_storage,
                  margin: EdgeInsets.only(left: 20, right: 5)),
            ])));
  }
}
