import 'package:flutter/material.dart';
import '../../generated/i18n.dart';

class InputTextPage extends StatefulWidget {
  InputTextPage({
    Key key,
    @required this.title,
    this.content,
    this.hintText,
    this.keyboardType: TextInputType.text,
    this.maxLength: 30,
    this.maxLines: 5,
    this.actionText,
    this.autofocus: false,
  })  : assert(title != null),
        super(key: key);

  final String title;
  final String actionText;
  final String content;
  final String hintText;
  final TextInputType keyboardType;

  final int maxLength;
  final int maxLines;

  final bool autofocus;

  @override
  createState() => _InputTextPageState();
}

class _InputTextPageState extends State<InputTextPage> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.title),
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: Material(
                    color: Colors.green,
                    child: InkWell(
                        child: Container(
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(widget.actionText ?? S.of(context).done,
                                style: TextStyle(color: Colors.white))),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pop(_controller.text);
                        })))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(
                top: 21.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: TextField(
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                autofocus: widget.autofocus,
                controller: _controller,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888))),
                style: TextStyle(color: Colors.grey, fontSize: 14))));
  }
}
