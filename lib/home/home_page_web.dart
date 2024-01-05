import 'package:flutter/gestures.dart';
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

  int _hoverIndex = -1;
  bool _isDeleteHovered = false;

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
              decoration: const BoxDecoration(
                color: Color(0xFF000026),
                borderRadius: null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Talk2Docs',
                        style: TextStyle(
                          color: Color(0xFF3BBA9C),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.asset('assets/images/edit.png',
                          width: 25, height: 25),
                    ),
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
                            MouseRegion(
                              onEnter: (PointerEnterEvent event) =>
                                  _onListTileHoverChanged(index: index, isReleased: false),
                              onExit: (PointerExitEvent event) =>
                                  _onListTileHoverChanged(index: index, isReleased: true),
                              child: ListTile(
                                mouseCursor: SystemMouseCursors.basic,
                                title: Text(
                                  chats![index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: _hoverIndex != index ? null : MouseRegion(
                                  cursor: SystemMouseCursors.copy,
                                  onEnter: (PointerEnterEvent event) =>
                                      _onDeleteHoverChanged(isDeleteHovered: true),
                                  onExit: (PointerExitEvent event) =>
                                      _onDeleteHoverChanged(isDeleteHovered: false),
                                  child: IconButton(
                                    onPressed: () {
                                      deleteChat(chats![currentIndex].id, index);
                                    },
                                    icon: Icon(Icons.delete, color: _isDeleteHovered ? Colors.white : null),
                                  ),
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
                          leading: CircleAvatar(
                            // backgroundColor: Colors.black,
                            radius: 30,
                            child: Image.asset('assets/images/user.png',
                                height: 33),
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
                        SizedBox(
                          height: 20,
                          child: Visibility(
                            visible: isTyping,
                            child: const Text(
                              'typing...',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
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
                                if (currentIndex == -1) {
                                  newChat((id) {
                                    setState(() {
                                      // check if chats == null, then initialize it
                                      chats ??= [];

                                      messages = [];

                                      chats!.add(Chat(id, 'New Chat', []));
                                      currentIndex = chats!.length - 1;

                                      startChat(chats![currentIndex].id, () {
                                        listenForMessages();
                                        sendMessage();
                                      });
                                    });
                                  });
                                } else {
                                  sendMessage();
                                }
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

  void _onListTileHoverChanged({required int index, required bool isReleased}) {
    setState(() {
      _hoverIndex = isReleased ? -1 : index;
    });
  }

  void _onDeleteHoverChanged({required bool isDeleteHovered}) {
    setState(() {
      _isDeleteHovered = isDeleteHovered;
    });
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
