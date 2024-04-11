import 'package:flutter_riverpod/flutter_riverpod.dart';

final isPdfReadProvider = StateProvider.autoDispose<bool>((ref) {
  return  false;
});