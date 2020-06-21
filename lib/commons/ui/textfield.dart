import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool autofocus;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onSubmitted;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final EdgeInsetsGeometry margin;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;

  const TextFieldWidget(
      {Key key,
      this.controller,
      this.hintText: "",
      this.autofocus: false,
      this.keyboardType: TextInputType.text,
      this.inputFormatters,
      this.onSubmitted,
      this.focusNode,
      this.nextFocusNode,
      this.margin,this.textInputAction,this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        height: 50,
        child: Stack(children: <Widget>[
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xFFF4F4F4)),
                  height: 35)),
          Positioned.fill(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: TextField(
                            inputFormatters: inputFormatters ?? [],
                            autofocus: autofocus,
                            keyboardType: keyboardType,
                            style: TextStyle(fontSize: 14),
                            controller: controller,
                            onSubmitted: onSubmitted,
                            focusNode: focusNode,
                            onChanged: onChanged,
                            textInputAction: textInputAction,
                            onEditingComplete: () => nextFocusNode != null
                                ? FocusScope.of(context)
                                    .requestFocus(nextFocusNode)
                                : FocusScope.of(context)
                                    .requestFocus(FocusNode()),
                            decoration: InputDecoration.collapsed(
                                hintText: hintText,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.grey[300])))),
                  ])))
        ]));
  }
}
