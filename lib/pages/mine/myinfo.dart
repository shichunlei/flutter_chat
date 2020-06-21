import 'package:flutter/material.dart';

import '../../commons/index.dart';
import '../../generated/i18n.dart';
import '../../provider/index.dart';

import 'package:image_picker/image_picker.dart';

/// 个人资料
class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key key}) : super(key: key);

  @override
  createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
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
    var snapshot = Provider.of<UserProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text(S.of(context).my_profile)),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              SelectedText(
                  height: 70,
                  title: S.of(context).profile_photo,
                  onTap: () =>
                      showUpdateAvatarDialog(context, (ImageSource source) {
                        if (null != source) pickerImage(source);
                      }),
                  margin: EdgeInsets.only(left: 20, right: 5),
                  rightWidget: ImageView(
                      '${snapshot.userInfo.extras["avatarUrl"]}',
                      height: 50,
                      width: 50,
                      radius: 10,
                      placeholder: 'images/header.jpeg')),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).name,
                  onTap: () => pushNewPage(
                          context,
                          InputTextPage(
                              title: S.of(context).edit_name,
                              content: '${snapshot?.userInfo?.nickname}',
                              maxLines: 1), callBack: (value) {
                        snapshot.updateNickName(value);
                      }),
                  content: JPushUtil.getName(snapshot.userInfo),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).wechat_id,
                  content: snapshot.identifier,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  rightWidget: ImageView('images/icon_qr.png',
                      imageType: ImageType.assets, width: 20, height: 20),
                  title: S.of(context).my_qr_code,
                  onTap: () => showQRNameCardDialog(context, '',
                      title: S.of(context).my_qr_code),
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).gender,
                  onTap: () => showUpdateGenderDialog(context,
                          callBack: (JMGender gender) {
                        if (null != gender) snapshot.updateGender(gender);
                      }),
                  content: snapshot?.userInfo?.gender == JMGender.female
                      ? S.of(context).female
                      : snapshot?.userInfo?.gender == JMGender.male
                          ? S.of(context).male
                          : S.of(context).unknown,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).birthday,
                  onTap: () => snapshot.updateBirthday(
                      DateTime(1990, 9, 23).millisecondsSinceEpoch),
                  content: snapshot?.userInfo?.birthday,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).region,
                  onTap: () {},
                  content: snapshot?.userInfo?.region,
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).whats_up,
                  onTap: () => pushNewPage(
                          context,
                          InputTextPage(
                              title: '个性签名',
                              content: snapshot.userInfo.signature ?? "",
                              maxLines: 8,
                              maxLength: 255), callBack: (value) {
                        snapshot.updateSignature(value);
                      }),
                  maxLines: 2,
                  content: snapshot.userInfo.signature ?? "",
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: 5),
              SelectedText(
                  title: '我的地址',
                  onTap: () {
//                    List<dynamic> addresses =
//                        json.decode(snapshot.userInfo.extras["addresses"])
//                                as List ??
//                            [];
//
//                    int id = 1;
//
//                    print('======>${addresses[addresses.length - 1]["id"]}');
//
//                    if (addresses.length > 0) {
//                      id = addresses[addresses.length - 1]["id"] + 1;
//                    }
//
//                    snapshot.updateAddresses({
//                      "name": "师春雷",
//                      "phone": "18601952581",
//                      "address": "北京市海淀区梦想实验室8层",
//                      "isDefault": true,
//                      "id": id
//                    }, true);
                  },
                  margin: EdgeInsets.only(left: 20, right: 5)),
              Container(height: .5),
              SelectedText(
                  title: S.of(context).my_fapiao_titles,
                  onTap: () {},
                  margin: EdgeInsets.only(left: 20, right: 5))
            ])));
  }

  Future pickerImage(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
        source: source, maxWidth: 800, maxHeight: 800, imageQuality: 80);

    if (image != null) {
//      String path = image.path;
//      debugPrint("========================>$path");

      String path = await FileUtil.getInstance().cropperImage(context, image);

      if (path != "") {
        Provider.of<UserProvider>(context, listen: false).uploadAvatar(path);
      }
    }
  }
}
