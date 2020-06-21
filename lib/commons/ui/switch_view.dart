import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchTitleView extends StatefulWidget {
  final String title;
  final Function(bool value) onChanged;
  final Color bgColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final bool isChecked;
  final String subTitle;

  const SwitchTitleView(
      {Key key,
      @required this.title,
      @required this.onChanged,
      this.bgColor: Colors.white,
      this.margin,
      this.textStyle,
      this.isChecked: false,
      this.subTitle,
      this.padding: const EdgeInsets.symmetric(horizontal: 20)})
      : super(key: key);

  @override
  createState() => _SwitchTitleViewState();
}

class _SwitchTitleViewState extends State<SwitchTitleView> {
  bool isChecked;

  @override
  void initState() {
    super.initState();

    this.isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.margin,
        child: Material(
            color: widget.bgColor,
            child: InkWell(
                onTap: () => setState(() {
                      this.isChecked = !this.isChecked;
                      widget.onChanged(this.isChecked);
                    }),
                child: Container(
                    padding: widget.padding,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              height: 50,
                              child: Row(
                                  children: <Widget>[
                                    Text('${widget.title}',
                                        style: widget.textStyle ??
                                            Theme.of(context)
                                                .textTheme
                                                .subtitle1),
                                    CupertinoSwitch(
                                        value: this.isChecked,
                                        onChanged: (value) => setState(() {
                                              this.isChecked = value;
                                              widget.onChanged(value);
                                            }))
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween)),
                          Visibility(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text("${widget.subTitle}",
                                      style: TextStyle(color: Colors.grey))),
                              visible: widget.subTitle != null)
                        ])))));
  }
}
