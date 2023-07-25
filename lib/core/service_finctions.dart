import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

///get size of magic Ball for different phone/desktop displaying
double getBallSize(BuildContext context) => switch (defaultTargetPlatform) {
  TargetPlatform.android || TargetPlatform.iOS =>  MediaQuery.of(context).size.width * 0.9,
  _ =>  MediaQuery.of(context).size.height * 0.45,
};