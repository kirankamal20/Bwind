import 'package:flutter_riverpod/flutter_riverpod.dart';

final isBuildChatbotProvider = StateProvider.autoDispose<bool>((ref) {
  return  false;
});