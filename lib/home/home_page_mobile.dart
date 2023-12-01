import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
import 'package:talk2docs/views/chat_bubble.dart';
import 'package:uuid/uuid.dart';

class HomePageMobile extends HomePage {
  const HomePageMobile({super.key});

  @override
  _HomePageMobile createState() => _HomePageMobile();
}

class _HomePageMobile extends HomePageState<HomePageMobile> {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // this should be null at first to show a loading indicator in the drawer
  List<Chat>? _chats;

  // this should be null at first to show a loading indicator in home page and
  // prevent the user from sending new messages until get the messages from server.
  List<Message>? _messages;

  String currentChatId = "";
  bool isFieldEmpty = true;

  @override
  void initState() {
    super.initState();

    // get all chats for logged in user
    getChats((chats) {
      setState(() {
        _chats = chats;
        currentChatId = _chats![0].id;

        // get all messages for the first (selected) chat
        getMessages(currentChatId, (messages) {
          setState(() {
            _messages = messages;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF000026),
        ),
        drawer: drawer(),
        body: _messages == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _messages!.length,
                        itemBuilder: (BuildContext context, int i) {
                          Message msg = _messages![i];
                          return ChatBubble(
                              message: msg.content, isUser: msg.isQuestion);
                        }),
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        resetSendBtn(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Ask a question',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: textController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  Message msg = Message(
                                      id: const Uuid().v4(),
                                      chatId: currentChatId,
                                      isQuestion: true,
                                      content: textController.text);
                                  setState(() {
                                    _messages!.add(msg);
                                  });

                                  textController.text = "";
                                  resetSendBtn(textController.text);

                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // this method used to show/hide the send button
  void resetSendBtn(value) {
    if ((value.isEmpty && !isFieldEmpty) ||
        (value.isNotEmpty && isFieldEmpty)) {
      setState(() {
        isFieldEmpty = !isFieldEmpty;
      });
    }
  }

  Widget drawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _chats == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _chats!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(_chats![i].title),
                            onTap: () {

                              // this line to close the drawer
                              Navigator.pop(context);

                              // here we change the chat id and empty the _messages to load new messages
                              setState(() {
                                currentChatId = _chats![i].id;
                                _messages = null;
                              });

                              // get the messages for the selected chat based on chat id
                              getMessages(currentChatId, (messages) {
                                setState(() {
                                  // initialize the new messages
                                  _messages = messages;
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
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // close the drawer and logout
              Navigator.pop(context);
              logout();
            },
          ),
        ],
      ),
    );
  }
}
