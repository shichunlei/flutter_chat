import 'package:flutter/material.dart';

import '../../generated/i18n.dart';

import '../../commons/index.dart';
import '../../widgets/item_blacklist.dart';

class BlacklistPage extends StatefulWidget {
  const BlacklistPage({Key key}) : super(key: key);

  @override
  createState() => _BlacklistPageState();
}

class _BlacklistPageState extends State<BlacklistPage> {
  List<JMUserInfo> list = [];

  LoaderState state = LoaderState.Loading;

  @override
  void initState() {
    super.initState();

    getBlacklist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).blocked_list)),
        body: LoaderContainer(
            contentView: ListView.separated(
                itemBuilder: (_, index) {
                  return ItemBlacklist(
                      userInfo: list[index],
                      onTop: () async {
                        showLoadingDialog(context);

                        await jMessage.removeUsersFromBlacklist(usernameArray: [
                          list[index].username
                        ]).then((value) {
                          Navigator.pop(context);

                          setState(() {
                            list.removeAt(index);

                            if (list.length == 0) {
                              state = LoaderState.NoData;
                            }
                          });
                        }, onError: (error) {
                          Navigator.pop(context);
                          print(
                              'removeUsersFromBlacklist error => ${error.toString()}');
                        });
                      });
                },
                separatorBuilder: (_, index) => SizedBox(height: 5.0),
                itemCount: list.length),
            loaderState: state));
  }

  void getBlacklist() async {
    List<JMUserInfo> users = await jMessage.getBlacklist();
    list.clear();
    list.addAll(users);
    setState(() {
      if (list.length == 0) {
        state = LoaderState.NoData;
      } else {
        state = LoaderState.Succeed;
      }
    });
  }
}
