import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:talk2docs/models/message.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:talk2docs/views/chat_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/models/chat.dart';

class HomePageWeb extends HomePage {
  HomePageWeb({Key? key}) : super(key: key);

  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends HomePageState<HomePageWeb> {
  late SharedPreferences prefs;
  late String fullName = "";

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString("fullName") ?? "";
    print(fullName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;

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
                    trailing: Image.asset('assets/images/pen_white.png',
                        width: 40, height: 40),
                    onTap: () {
                      newChat((id) {
                        setState(() {
                          // check if chats == null, then initialize it
                          chats ??= [];

                          messages = [];

                          chats!.add(Chat(id, 'New Chat', []));
                          currentIndex = chats!.length - 1;
                        });
                      });
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chats?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                chats![index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                  messages = null;
                                });
                                getMessages(chats![currentIndex].id,
                                    (messages) {
                                  startChat(chats![currentIndex].id, () {
                                    setState(() {
                                      this.messages = messages;
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
                            itemCount: messages?.length ?? 0,
                            itemBuilder: (BuildContext context, int i) {
                              Message msg = messages![i];
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
                    onSubmitted: (value) {
                      sendMessage();
                    },
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

  void sendMessage() {
    Message msg = Message(
        id: const Uuid().v4(),
        chatId: chats![currentIndex].id,
        isQuestion: true,
        content: textController.text);

    channel?.sink.add(msg.content);

    setState(() {
      messages!.add(msg);
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
