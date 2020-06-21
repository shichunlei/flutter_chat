import 'package:flutter/material.dart';

class SelectedText extends StatelessWidget {
  const SelectedText(
      {Key key,
      this.onTap,
      @required this.title,
      this.content: "",
      this.textAlign: TextAlign.end,
      this.contentStyle,
      this.leading,
      this.subTitle: "",
      this.height,
      this.trailing,
      this.margin,
      this.bgColor,
      this.textStyle,
      this.subTextStyle,
      this.padding,
      this.maxLines: 1,
      this.rightWidget: const SizedBox()})
      : assert(title != null, height >= 50.0),
        super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle contentStyle;
  final Widget leading;
  final IconData trailing;
  final String subTitle;
  final double height;
  final EdgeInsetsGeometry margin;
  final Color bgColor;
  final TextStyle textStyle;
  final TextStyle subTextStyle;
  final Widget rightWidget;
  final EdgeInsetsGeometry padding;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: bgColor ?? Colors.white,
        child: InkWell(
            onTap: onTap,
            child: Container(
                padding: padding ?? EdgeInsets.symmetric(vertical: 10),
                constraints: BoxConstraints(minHeight: 55),
                height: height,
                margin: margin ?? EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: Row(children: <Widget>[
                  Visibility(
                      child: Row(children: <Widget>[
                        leading == null ? SizedBox() : leading,
                        SizedBox(width: 8)
                      ]),
                      visible: leading != null),
                  subTitle.isNotEmpty
                      ? Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              Text('${title ?? ""}',
                                  style: textStyle ??
                                      Theme.of(context).textTheme.subtitle1,
                                  maxLines: 1),
                              Text(subTitle,
                                  style: subTextStyle ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)
                            ]))
                      : Text('${title ?? ""}',
                          style: textStyle ??
                              Theme.of(context).textTheme.subtitle1,
                          maxLines: 1),
                  Visibility(
                      visible: content.isNotEmpty,
                      child: Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("${content ?? ''}",
                                  maxLines: maxLines,
                                  textAlign: textAlign,
                                  overflow: TextOverflow.ellipsis,
                                  style: contentStyle ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(color: Colors.grey))))),
                  Visibility(
                      child: Spacer(),
                      visible: content.isEmpty && subTitle.isEmpty),
                  rightWidget,
                  SizedBox(width: 8),
                  Visibility(
                      child: Icon(trailing ?? Icons.chevron_right, size: 22.0),
                      visible: onTap != null)
                ]))));
  }
}
