import 'package:flutter/widgets.dart';
import 'package:light_modal_bottom_sheet/light_modal_bottom_sheet.dart';

mixin GlobalHelper<T extends StatefulWidget> on State<T> {
  void showBottomDialog({required Widget child}) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.33,
        child: child,
      ),
    );
  }
}





// class GlobalHelper {
//   void showDialog() {
//     showBarModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         height: 400,
//       ),
//     );
//   }
// }
