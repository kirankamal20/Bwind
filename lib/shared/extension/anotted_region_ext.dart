import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

extension AnotedRegion on Widget {
  Widget anottedRegion({Brightness? statusBarIconBrightness}) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness:
                statusBarIconBrightness ?? Brightness.dark),
        child: this);
  }
}
