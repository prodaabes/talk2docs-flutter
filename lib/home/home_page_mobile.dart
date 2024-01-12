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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (chats != null && chats!.isNotEmpty)
                    ? chats![currentIndex].title
                    : 'Home',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Visibility(
                visible: isTyping,
                child: const Text(
                  'typing...',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF000026),
        ),
        drawer: drawer(context),
        body: messages == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: messages!.length,
                        itemBuilder: (BuildContext context, int i) {
                          Message msg = messages![i];
                          return ChatBubble(
                              message: msg.content, isUser: msg.isQuestion);
                        }),
                  ),
                  Container(
                    height: 70,
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
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {
                            showFilesDialog(context);
                          },
                        ),
                        suffixIcon: textController.text.isEmpty
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
    resetSendBtn(textController.text);
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

  void showDeleteDialog(BuildContext context, int i) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Delete Chat',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Delete the chat named \'${chats![i].title}\' ?',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: TextButton(
                          onPressed: () {
                            // hide the dialog
                            Navigator.pop(context);

                            // this line to close the drawer
                            Navigator.pop(context);

                            deleteChat(chats![currentIndex].id, i);
                          },
                          child: const Text('Yes'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
              title: const Text('New Chat'),
              trailing:
                  Image.asset('assets/images/pen.png', width: 20, height: 20),
              onTap: () {
                Navigator.pop(context);

                newChat((id) {
                  setState(() {
                    // check if chats == null, then initialize it
                    chats ??= [];

                    messages = [];

                    chats!.add(Chat(id, 'New Chat', []));
                    currentIndex = chats!.length - 1;
                  });
                });
              }),
          const Divider(height: 0),
          Expanded(
            child: chats == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: chats!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              chats![i].title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // this line to close the drawer
                              Navigator.pop(context);

                              // here we change the chat id and empty the messages to load new messages
                              setState(() {
                                currentIndex = i;
                                messages = null;
                              });

                              // get the messages for the selected chat based on chat id
                              getMessages(chats![currentIndex].id, (messages) {
                                startChat(chats![currentIndex].id, () {
                                  setState(() {
                                    this.messages = messages;
                                  });
                                  listenForMessages();
                                });
                              });
                            },
                            onLongPress: () {
                              showDeleteDialog(context, i);
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
              Navigator.pop(context);
              logout();
            },
          ),
        ],
      ),
    );
  }
}
