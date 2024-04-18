import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

extension AnotedRegion on Widget {
  Widget anottedRegion({Brightness? statusBarIconBrightness}) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarColor: const Color(0xFFFFFFFF),
          statusBarColor: const Color(0x00FFFFFF),
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark),
      child: this,
    );
  }
}
