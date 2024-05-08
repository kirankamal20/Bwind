 
import 'package:distance_edu/UI/chat/provider/is_build_chatbot_provider.dart';
import 'package:distance_edu/UI/chat/provider/is_pdf_read_provider.dart';
import 'package:distance_edu/UI/chat/provider/message_provider.dart';
import 'package:distance_edu/core/config/type_of_message.dart';
import 'package:distance_edu/core/extension/context.dart';
import 'package:distance_edu/data/hive/model/chat_bot/chat_bot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInterfaceWidget extends ConsumerWidget {
  final Function() uploadPdf;
  final List<types.Message> messages;
  final ChatBot chatBot;
  final Color color;
  final String imagePath;

  final String currentState;

  const ChatInterfaceWidget({
    required this.currentState,
    required this.uploadPdf,
    required this.messages,
    required this.chatBot,
    required this.color,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBuildChatBotPod = ref.watch(isBuildChatbotProvider);
    final isPdfread = ref.watch(isPdfReadProvider);
    return Chat(
      emptyState: Center(
        child: !isPdfread
            ? isBuildChatBotPod
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currentState,
                          style: const TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  )
                : ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      uploadPdf();
                    },
                    label: const Text("Select the Pdf"))
            : const Center(child: Text("Write the Message")),
      ),
      messages: messages,
      onSendPressed: (text) {
        ref.watch(messageListProvider.notifier).handleSendPressed(
              text: text.text,
              imageFilePath: chatBot.attachmentPath,
            );
      },
      // onAttachmentPressed: () {
      //   uploadPdf();
      // },
      user: const types.User(id: TypeOfMessage.user),
      showUserAvatars: true,
      avatarBuilder: (user) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CircleAvatar(
          radius: 19,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              imagePath,
              color: context.colorScheme.surface,
            ),
          ),
        ),
      ),
      theme: DefaultChatTheme(
        primaryColor: context.colorScheme.onSurface,
        secondaryColor: Colors.grey.shade300,
        inputBackgroundColor: Colors.black,
        inputTextCursorColor: Colors.white,
        attachmentButtonIcon: const Icon(
          Icons.upload,
          color: Colors.white,
        ),
        inputTextColor: Colors.white,
        receivedMessageBodyTextStyle: TextStyle(
          color: context.colorScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        sentMessageBodyTextStyle: TextStyle(
          color: context.colorScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        dateDividerTextStyle: TextStyle(
          color: context.colorScheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1.333,
        ),
        inputTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: context.colorScheme.onSurface,
        ),
        inputTextDecoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isCollapsed: true,
          fillColor: context.colorScheme.onBackground,
        ),
        inputBorderRadius: const BorderRadius.all(Radius.circular(10)),
        inputMargin: const EdgeInsets.all(10),
        inputPadding: const EdgeInsets.all(15),
      ),
    );
  }
}
