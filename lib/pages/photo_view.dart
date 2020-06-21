import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../utils/utils.dart';

class PhotoViewPage extends StatefulWidget {
  final List<String> photos;
  final int index;
  final PageController controller;
  final String title;
  final String heroTag;

  PhotoViewPage({
    Key key,
    this.title,
    @required this.photos,
    this.index: 0,
    @required this.heroTag,
  })  : controller = PageController(initialPage: index),
        assert(photos.length > 0),
        assert(heroTag != null && heroTag != ""),
        super(key: key);

  @override
  createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage>
    with SingleTickerProviderStateMixin {
  int total = 0;
  int count;

  @override
  void initState() {
    super.initState();

    total = widget.photos.length;
    count = 1 + widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        child: Scaffold(
            backgroundColor: Colors.black26,
            body: Stack(children: <Widget>[
              PhotoViewGallery.builder(
                  builder: (_, index) {
                    return PhotoViewGalleryPageOptions(
                        imageProvider:
                            Utils.verifyPathIsHttp(widget.photos[index])
                                ? NetworkImage(widget.photos[index])
                                : FileImage(File(widget.photos[index])),
                        initialScale: PhotoViewComputedScale.contained * 1.0,
                        heroAttributes:
                            PhotoViewHeroAttributes(tag: widget.heroTag));
                  },
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  onPageChanged: (index) => setState(() => count = index + 1),
                  scrollPhysics: const BouncingScrollPhysics(),
                  loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.greenAccent)),
                  loadFailedChild: Image.asset('images/img_not_available.jpeg'),
                  pageController: widget.controller,
                  itemCount: widget.photos.length),
              Positioned(
                  child: Container(
                      alignment: Alignment.center,
                      child: Container(
                          width: 80.0,
                          height: 30.0,
                          child: Center(
                              child: Text('$count/$total',
                                  style: TextStyle(color: Colors.white))),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))))),
                  bottom: 50,
                  left: 0,
                  right: 0),
              Container(
                  height: Utils.navigationBarHeight,
                  child: Scaffold(
                      appBar: AppBar(
                          backgroundColor: Colors.transparent, elevation: 0.0),
                      backgroundColor: Colors.transparent))
            ])),
        data: ThemeData(brightness: Brightness.dark));
  }
}
