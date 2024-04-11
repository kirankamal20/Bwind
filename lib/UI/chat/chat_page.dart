import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:bwind/UI/chat/provider/chat_bot_provider.dart';
import 'package:bwind/UI/chat/provider/is_build_chatbot_provider.dart';
import 'package:bwind/UI/chat/provider/is_pdf_read_provider.dart';
import 'package:bwind/UI/chat/provider/message_provider.dart';
import 'package:bwind/UI/chat/widgets/background_curves_painter.dart';
import 'package:bwind/UI/chat/widgets/chat_interface_widget.dart';
import 'package:bwind/core/config/assets_constants.dart';
import 'package:bwind/core/config/type_of_bot.dart';
import 'package:bwind/core/extension/context.dart';
import 'package:bwind/data/hive/model/chat_bot/chat_bot.dart';
import 'package:bwind/shared/helpers/global_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:pretty_animated_buttons/widgets/pretty_shadow_button.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> with GlobalHelper {
  final uuid = const Uuid();

  String currentState = '';

  @override
  void initState() {
    super.initState();
    ref.read(chatBotListProvider.notifier).fetchChatBots();
  }

  Future<void> uploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      final filePath = result.files.single.path;
      ref.read(isBuildChatbotProvider.notifier).update((state) => true);
      setState(() {
        currentState = 'Extracting data';
      });

      ref
          .read(chatBotListProvider.notifier)
          .getChunksFromPDF(filePath!)
          .then((textChunks) {
        setState(() {
          currentState = 'Building chatBot';
        });
        ref
            .read(chatBotListProvider.notifier)
            .batchEmbedChunks(textChunks)
            .then((embeddingsMap) async {
          final chatBot = ChatBot(
            messagesList: [],
            id: uuid.v4(),
            title: '',
            typeOfBot: TypeOfBot.pdf,
            attachmentPath: filePath,
            embeddings: embeddingsMap,
          );

          await ref.read(chatBotListProvider.notifier).saveChatBot(chatBot);
          await ref.read(messageListProvider.notifier).updateChatBot(chatBot);
          ref.read(isBuildChatbotProvider.notifier).update((state) => false);
          ref.read(isPdfReadProvider.notifier).update((state) => true);
          setState(() {
            currentState = 'Building chatBot';
          });
        }).onError((error, stackTrace) {
          log(error.toString());
        });
      }).onError((error, stackTrace) {
        log(error.toString());
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatBot = ref.watch(messageListProvider);
    final color = chatBot.typeOfBot == TypeOfBot.pdf
        ? context.colorScheme.primary
        : chatBot.typeOfBot == TypeOfBot.text
            ? context.colorScheme.secondary
            : context.colorScheme.tertiary;
    final imagePath = chatBot.typeOfBot == TypeOfBot.pdf
        ? AssetConstants.pdfLogo
        : chatBot.typeOfBot == TypeOfBot.image
            ? AssetConstants.imageLogo
            : AssetConstants.textLogo;
    final title = chatBot.typeOfBot == TypeOfBot.pdf
        ? 'PDF'
        : chatBot.typeOfBot == TypeOfBot.image
            ? 'Image'
            : 'Text';

    final List<types.Message> messages = chatBot.messagesList.map((msg) {
      return types.TextMessage(
        author: types.User(id: msg['typeOfMessage'] as String),
        createdAt:
            DateTime.parse(msg['createdAt'] as String).millisecondsSinceEpoch,
        id: msg['id'] as String,
        text: msg['text'] as String,
      );
    }).toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Pdf Summarize",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showBottomDialog(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Start Fresh ? ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Are you sure want to start a new chat ?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PrettyWaveButton(
                          onPressed: () {
                            ref.invalidate(messageListProvider);
                            ref.invalidate(chatBotListProvider);
                            ref.invalidate(isPdfReadProvider);
                            ref.invalidate(isBuildChatbotProvider);
                            Navigator.of(context).pop();
                          },
                          backgroundColor: const Color(0xFF6F30C0),
                          child: const Text(
                            'Start new chat',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PrettyWaveButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          backgroundColor: const Color(0xFF6F30C0),
                          child: const Text(
                            'Go Back',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // const Positioned(
              //   left: -300,
              //   top: -00,
              //   child: SizedBox(
              //     height: 500,
              //     width: 600,
              //     // decoration: BoxDecoration(
              //     //   gradient: RadialGradient(
              //     //     colors: [
              //     //       color.withOpacity(0.5),
              //     //       // context.colorScheme.background.withOpacity(0.5),
              //     //     ],
              //     //   ),
              //     // ),
              //   ),
              // ),
              // CustomPaint(
              //   painter: BackgroundCurvesPainter(),
              //   size: Size.infinite,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.arrow_back,
                        //     color: context.colorScheme.onSurface,
                        //   ),
                        //   onPressed: () {
                        //     ref
                        //         .read(chatBotListProvider.notifier)
                        //         .updateChatBotOnHomeScreen(chatBot);
                        //     context.pop();
                        //   },
                        // ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   margin: const EdgeInsets.symmetric(vertical: 16),
                        //   width: 120,
                        //   height: 40,
                        //   decoration: BoxDecoration(
                        //     color: context.colorScheme.primary,
                        //     borderRadius: BorderRadius.circular(30),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.25),
                        //         offset: const Offset(4, 4),
                        //         blurRadius: 8,
                        //       ),
                        //     ],
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       '$title Buddy',
                        //       style: TextStyle(
                        //         color: context.colorScheme.surface,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        if (chatBot.typeOfBot == TypeOfBot.image)
                          CircleAvatar(
                            maxRadius: 21,
                            backgroundImage: FileImage(
                              File(chatBot.attachmentPath!),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog<AlertDialog>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            File(chatBot.attachmentPath!),
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const SizedBox.shrink(),
                            ),
                          )
                        else
                          const SizedBox(width: 42),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: ChatInterfaceWidget(
                        messages: messages,
                        chatBot: chatBot,
                        color: color,
                        imagePath: imagePath,
                        uploadPdf: uploadPdf,
                        currentState: currentState,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
