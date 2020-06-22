import 'package:flutter/material.dart';

import '../config.dart';
import 'dimens.dart';

BorderRadius borderRadius(MessageSendType type) {
  return BorderRadius.only(
      bottomRight: Radius.circular(radius),
      topRight: Radius.circular(type == MessageSendType.receive ? radius : .0),
      topLeft: Radius.circular(type == MessageSendType.send ? radius : .0),
      bottomLeft: Radius.circular(radius));
}

BorderRadius modalBottomSheet() {
  return BorderRadius.only(
      topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));
}
