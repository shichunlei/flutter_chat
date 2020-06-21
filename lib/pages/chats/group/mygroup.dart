import 'package:flutter/material.dart';

import '../../../generated/i18n.dart';
import '../../../commons/index.dart';
import '../../../widgets/item_group.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({Key key}) : super(key: key);

  @override
  createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  List<JMGroupInfo> groups;

  List<String> groupIds = [];

  LoaderState state = LoaderState.Loading;

  @override
  void initState() {
    super.initState();

    getMyGroups();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).title_group_chats)),
        body: LoaderContainer(
            contentView: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    ItemGroup(id: groupIds[index]),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 5),
                itemCount: groupIds.length),
            loaderState: state));
  }

  void getMyGroups() async {
    jMessage.getGroupIds().then((List<String> value) {
      groupIds.addAll(value);
      setState(() {
        state = LoaderState.Succeed;
      });
    }, onError: (error) {
      print('getGroupIds error => ${error.toString()}');
    });
  }
}
