import 'package:flutter/material.dart';
import 'package:flutter_chat/commons/index.dart';
import 'package:flutter_chat/generated/i18n.dart';
import 'package:flutter_chat/model/user.dart';

import 'contacts/friend.dart';

/// 搜索
class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();

  bool showEmpty = false;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        if (controller.text.length == 0) {
          showEmpty = false;
          showSearch = false;
        } else {
          showSearch = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: TextFieldWidget(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  print(value);
                  showLoadingDialog(context);

                  searchContact(value);
                },
                onChanged: (value) {
                  showEmpty = false;
                  if (value.length == 0) {
                    showSearch = false;
                  } else {
                    showSearch = true;
                  }
                  setState(() {});
                },
                hintText: "请输入微信号/手机号码"),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 5),
                  child: MaterialButton(
                      minWidth: 40,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(S.of(context).cancel,
                          style: TextStyle(color: Colors.green[300]))))
            ]),
        body: Stack(children: <Widget>[
          Visibility(
              visible: showSearch,
              child: Material(
                  color: Colors.white,
                  child: InkWell(
                      child: Container(
                          width: double.infinity,
                          child: Row(children: <Widget>[
                            Image.asset("images/icon_search_wechat.png",
                                height: 40, width: 40),
                            SizedBox(width: 15),
                            Expanded(
                                child: Text("搜索：${controller.text.toString()}"))
                          ]),
                          padding: EdgeInsets.all(15)),
                      onTap: () {
                        /// 隐藏键盘
                        FocusScope.of(context).requestFocus(FocusNode());
                        showLoadingDialog(context);

                        searchContact(controller.text.toString());
                      }))),
          Visibility(
              child: Column(children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    height: 100,
                    width: double.infinity,
                    child: Text("该用户不存在",
                        style: TextStyle(color: Colors.grey[500]))),
                Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(15),
                    child: Row(children: <Widget>[
                      Image.asset("images/Icon_search.png",
                          width: 42, height: 42),
                      SizedBox(width: 15),
                      Column(
                        children: [
                          Text('搜一搜：${controller.text.toString()}'),
                          SizedBox(height: 5),
                          Text(
                            '小程序、公众号、文章、朋友圈和表情等',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ]))
              ]),
              visible: showEmpty)
        ]));
  }

  Future searchContact(String keyword) async {
    await HttpUtils().get(
        APIs.SEARCH_CONTACTS,
        (data) async {
          print(data.toString());
          List<UserBean> users = [];

          users.addAll((data as List ?? []).map((o) => UserBean.fromMap(o)));

          Navigator.pop(context);

          if (users.length == 0) {
            setState(() {
              showEmpty = true;
            });
          } else {
            pushNewPage(
                context, FriendInfoPage(identifier: users[0].identifier));
          }
        },
        params: {"mobile": keyword},
        errorCallBack: (error) {
          Toast.show(context, error.message);
          Navigator.pop(context);
        });
  }
}
