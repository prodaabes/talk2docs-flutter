import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:talk2docs/api.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'web/file_upload_modal.dart';
import 'package:talk2docs/views/chat_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageWeb extends HomePage {
  HomePageWeb({Key? key}) : super(key: key);

  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends HomePageState<HomePageWeb> {
  late SharedPreferences prefs;
  late String fullName = "";
  WebSocketChannel? channel;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Chat>? _chats;
  int currentIndex = 0;
  List<Message>? _messages;
  bool isFieldEmpty = true;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    getChats((chats) {
      setState(() {
        _chats = chats;
        getMessages(_chats![currentIndex].id, (messages) {
          startChat(_chats![currentIndex].id, () {
            setState(() {
              _messages = messages;
            });
            listenForMessages();
          });
        });
      });
    });
  }

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString("fullName") ?? "";
    print(fullName);
    setState(() {});
  }

  listenForMessages() {
    channel = WebSocketChannel.connect(
      Uri.parse(API.SOCKET_URL),
    );;
    channel?.stream.listen(
      (message) {
        setState(() {
          _messages?.add(Message(
              id: const Uuid().v4(),
              chatId: _chats![currentIndex].id,
              isQuestion: false,
              content: message));
          isTyping = false;
        });

        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            scrollToBottom();
          });
        });
      },
      onDone: () {
        listenForMessages();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDDFFFFFF),
      body: Row(
        children: [
          Drawer(
            child: Container(
              color: const Color(0xFF000026),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text(
                      'Talk2Docs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      // Implement the logic for Chat History
                      // ...
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _chats?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(_chats![index].title),
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                  _messages = null;
                                });
                                getMessages(_chats![currentIndex].id,
                                    (messages) {
                                  startChat(_chats![currentIndex].id, () {
                                    setState(() {
                                      _messages = messages;
                                    });
                                    listenForMessages();
                                  });
                                });
                              },
                            ),
                            const Divider(height: 0),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            // backgroundImage: AssetImage('assets/profile_image.png'),
                          ),
                          title: Text(
                            fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.exit_to_app),
                            onPressed: () {
                              logout();
                            },
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Talk2Docs',
                          style: TextStyle(fontSize: 24),
                        ),
                        Flexible(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: _messages?.length ?? 0,
                            itemBuilder: (BuildContext context, int i) {
                              Message msg = _messages![i];
                              return ChatBubble(
                                  message: msg.content, isUser: msg.isQuestion);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: TextField(
                    controller: textController,
                    onChanged: (value) {
                      setState(() {
                        isFieldEmpty = value.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Ask a question',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {
                          showFilesDialog(context);
                        },
                      ),
                      suffixIcon: isFieldEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                sendMessage();
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showFilesDialog(BuildContext context) {
    // Implement the file upload dialog for the web version
    // You may use the existing logic or adapt it for the web
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void sendMessage() {
    Message msg = Message(
        id: const Uuid().v4(),
        chatId: _chats![currentIndex].id,
        isQuestion: true,
        content: textController.text);

    channel?.sink.add(msg.content);

    setState(() {
      _messages!.add(msg);
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        scrollToBottom();
      });
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isTyping = true;
      });
    });

    textController.text = "";
  }
}