import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:talk2docs/api.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
import 'package:talk2docs/models/upload_file_model.dart';
import 'package:talk2docs/views/chat_bubble.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class HomePageMobile extends HomePage {
  const HomePageMobile({super.key});

  @override
  _HomePageMobile createState() => _HomePageMobile();
}

class _HomePageMobile extends HomePageState<HomePageMobile> {
  IOWebSocketChannel? channel;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // this should be null at first to show a loading indicator in the drawer
  List<Chat>? _chats;

  // current chat index
  int currentIndex = 0;

  // this should be null at first to show a loading indicator in home page and
  // prevent the user from sending new messages until get the messages from server.
  List<Message>? _messages;

  // this for check if the text field is empty or not
  bool isFieldEmpty = true;

  // this field will be true when waiting for server response
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    // get all chats for logged in user
    getChats((chats) {
      setState(() {
        _chats = chats;

        // get all messages for the first (selected) chat
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

  listenForMessages() {
    channel = IOWebSocketChannel.connect(API.SOCKET_URL);
    channel?.stream.listen((message) {
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
    }, onDone: () {
      listenForMessages();
    });
  }

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
                (_chats != null && _chats!.isNotEmpty) ? _chats![currentIndex].title : 'Home',
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
                                  Message msg = Message(
                                      id: const Uuid().v4(),
                                      chatId: _chats![currentIndex].id,
                                      isQuestion: true,
                                      content: textController.text);

                                  channel?.sink.add(msg.content);

                                  setState(() {
                                    _messages!.add(msg);
                                  });

                                  Future.delayed(
                                      const Duration(milliseconds: 50), () {
                                    setState(() {
                                      scrollToBottom();
                                    });
                                  });

                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  });

                                  textController.text = "";
                                  resetSendBtn(textController.text);
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

  void showFilesDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                height: 350,
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
                            'Chat Files',
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
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _chats![currentIndex].files.length,
                        itemBuilder: (BuildContext context, int i) {
                          String file = _chats![currentIndex].files[i];

                          return ListTile(
                            leading: file.toLowerCase().endsWith('.pdf')
                                ? Image.asset('assets/images/pdf.png',
                                    width: 30, height: 30)
                                : Image.asset('assets/images/picture.png',
                                    width: 30, height: 25),
                            title: Text(file),
                            trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  removeFile(_chats![currentIndex].id, file,
                                      () {
                                    setDialogState(() {
                                      _chats![currentIndex].files.removeAt(i);
                                    });
                                  });
                                }),
                          );
                        }),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Opacity(
                            opacity: _chats![currentIndex].files.length >= 4
                                ? 0.5
                                : 1,
                            child: TextButton(
                              onPressed: _chats![currentIndex].files.length >= 4
                                  ? null
                                  : () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'jpg',
                                                'png',
                                                'pdf'
                                              ],
                                              allowMultiple: false);

                                      if (result != null) {
                                        File file =
                                            File(result.files.single.path!);
                                        UploadFile uFile = UploadFile(
                                            name: basename(file.path),
                                            path: file.path);

                                        uploadFiles(
                                            _chats![currentIndex].id, [uFile],
                                            () {
                                          setDialogState(() {
                                            _chats![currentIndex]
                                                .files
                                                .add(basename(file.path));
                                          });
                                        });
                                      } else {
                                        // User canceled the picker
                                      }
                                    },
                              child: const Text('Upload File'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
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
                      'Delete the chat named \'${_chats![i].title}\' ?',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
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

                            deleteChat(_chats![currentIndex].id, () {
                              setState(() {
                                // empty the _messages array
                                _messages?.clear();

                                // remove the chat from _chats list
                                _chats?.removeAt(i);

                                // check if chats not empty, select the first chat after delete
                                if (_chats!.isNotEmpty) {
                                  currentIndex = 0;
                                }
                              });
                            });
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
                // this line to close the drawer
                Navigator.pop(context);

                newChat((id) {
                  setState(() {

                    // check if _chats == null, then initialize it
                    _chats ??= [];

                    _messages = [];

                    _chats!.add(Chat(id: id, title: 'New Chat', files: []));
                    currentIndex = _chats!.length - 1;
                  });
                });
              }),
          const Divider(height: 0),
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
                                currentIndex = i;
                                _messages = null;
                              });

                              // get the messages for the selected chat based on chat id
                              getMessages(_chats![currentIndex].id, (messages) {
                                setState(() {
                                  // initialize the new messages
                                  _messages = messages;
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
              // close the drawer and logout
              Navigator.pop(context);
              logout();
            },
          ),
        ],
      ),
    );
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
