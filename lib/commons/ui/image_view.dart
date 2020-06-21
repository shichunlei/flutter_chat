import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String path;
  final double height;
  final double width;
  final double radius;
  final BoxShape shape;
  final Color borderColor;
  final double borderWidth;
  final Color bgColor;
  final VoidCallback onPressed;
  final double elevation;
  final BoxFit fit;
  final ImageType imageType;
  final EdgeInsetsGeometry margin;
  final String placeholder;

  ImageView(
    this.path, {
    Key key,
    this.height,
    this.width,
    this.radius,
    this.shape: BoxShape.rectangle,
    this.borderColor,
    this.borderWidth: 0.0,
    this.bgColor,
    this.onPressed,
    this.elevation: 0.0,
    this.fit: BoxFit.cover,
    this.imageType: ImageType.network,
    this.margin: EdgeInsets.zero,
    this.placeholder: 'images/img_not_available.jpeg',
  })  : assert(radius != null || (width != null && height != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.network:
        imageWidget = CachedNetworkImage(
            placeholder: (context, url) => Image.asset(placeholder),
            imageUrl: path,
            fit: fit,
            errorWidget: (context, url, error) => Image.asset(placeholder));
        break;
      case ImageType.assets:
        imageWidget = FadeInImage(
            placeholder: AssetImage(placeholder),
            image: AssetImage(path),
            fit: fit);
        break;
      case ImageType.localFile:
        imageWidget = FadeInImage(
            placeholder: AssetImage(placeholder),
            image: FileImage(File(path)),
            fit: fit);
        break;
    }

    return Card(
        color: bgColor ?? Theme.of(context).primaryColor,
        shape: shape == BoxShape.circle
            ? CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 0.0)),
        clipBehavior: Clip.antiAlias,
        elevation: elevation,
        margin: margin,
        child: Material(
            child: InkWell(
                onTap: onPressed,
                child: Container(
                    height: height ?? radius * 2,
                    width: width ?? radius * 2,
                    child: Stack(children: <Widget>[
                      Positioned.fill(child: imageWidget),
                      Positioned.fill(
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: shape == BoxShape.circle
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  borderRadius: shape == BoxShape.circle
                                      ? null
                                      : BorderRadius.circular(radius ?? 0.0),
                                  border: Border.all(
                                      color: borderColor ??
                                          Theme.of(context).primaryColor,
                                      width: borderWidth,
                                      style: borderWidth == 0.0
                                          ? BorderStyle.none
                                          : BorderStyle.solid))))
                    ])))));
  }
}

enum ImageType { network, assets, localFile }
