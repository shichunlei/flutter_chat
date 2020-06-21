import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/zone_code.dart';
import '../../generated/i18n.dart';
import '../../commons/index.dart';

class ZoneCodePage extends StatefulWidget {
  const ZoneCodePage({Key key}) : super(key: key);

  @override
  createState() => _ZoneCodePageState();
}

class _ZoneCodePageState extends State<ZoneCodePage> {
  List<ZoneCode> codes = [];

  LoaderState state = LoaderState.Loading;

  @override
  void initState() {
    super.initState();

    getZoneCodes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('${S.of(context).title_country_code}')),
        body: LoaderContainer(
            contentView: ListView.separated(
                itemBuilder: (BuildContext context, int index) => Material(
                    color: Colors.white,
                    child: InkWell(
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(children: <Widget>[
                              Text(codes[index]?.name ?? ''),
                              Spacer(),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(codes[index]?.code ?? '',
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        onTap: () => Navigator.of(context).pop(codes[index]))),
                itemCount: codes.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 5)),
            loaderState: state));
  }

  void getZoneCodes() async {
    String dataJson = await rootBundle
        .loadString('assets/data/zone_code.json')
        .then((value) => value);

    if (dataJson != null) {
      codes.clear();
    }
    codes
      ..addAll((json.decode(dataJson) as List ?? [])
          .map((o) => ZoneCode.fromMap(o)));

    setState(() {
      state = LoaderState.Succeed;
    });
  }
}
