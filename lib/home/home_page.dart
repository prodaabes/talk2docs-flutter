import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/home/home_page_mobile.dart';
import 'package:talk2docs/home/home_page_web.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
import 'package:talk2docs/models/upload_file_model.dart';
import 'package:talk2docs/utils.dart';
import 'package:talk2docs/welcome/welcome_page.dart';
import 'package:talk2docs/api.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState<T extends HomePage> extends State<T> {
  late BuildContext mContext;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // this should be null at first to show a loading indicator in the drawer
  List<Chat>? chats;

  // current chat index
  int currentIndex = -1;

  // this should be null at first to show a loading indicator in home page and
  // prevent the user from sending new messages until get the messages from server.
  List<Message>? messages;

  // this for check if the text field is empty or not
  bool isFieldEmpty = true;

  // this field will be true when waiting for server response
  bool isTyping = false;

  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();

    // get all chats for logged in user
    getChats((chats) {
      setState(() {
        this.chats = chats;

        if (chats.isNotEmpty) {
          this.currentIndex = 0;

          // get all messages for the first (selected) chat
          getMessages(chats[currentIndex].id, (messages) {
            startChat(chats[currentIndex].id, () {
              setState(() {
                this.messages = messages;
              });

              Future.delayed(const Duration(milliseconds: 50), () {
                setState(() {
                  scrollToBottom();
                });
              });

              listenForMessages();
            });
          });
        } else {
          this.messages = [];
        }
      });
    });
  }

  listenForMessages() {
    channel = WebSocketChannel.connect(
      Uri.parse(API.SOCKET_URL),
    );
    channel?.stream.listen((message) {
      setState(() {
        String title = message;
        if (title.length > 40) {
          title = title.substring(0, 40);
        }
        chats![currentIndex].title = title;

        messages?.add(Message(
            id: const Uuid().v4(),
            chatId: chats![currentIndex].id,
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
    mContext = context;
    if (kIsWeb) {
      return HomePageWeb();
    } else {
      return const HomePageMobile();
    }
  }

  void getChats(Function(List<Chat> chats) callback) {
    API().getChats((isSuccess, chats) {
      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error getting chats');
        return null;
      }

      callback(chats);
    });
  }

  void getMessages(String chatId, Function(List<Message> messages) callback) {
    API().getMessages(chatId, (isSuccess, messages) {
      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error getting messages');
        return null;
      }

      callback(messages);
    });
  }

  void removeFile(String chatId, String name, Function() callback) {
    API().removeFile(chatId, name, (isSuccess) {
      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error removing file');
        return null;
      }

      startChat(chats![currentIndex].id, () {
        listenForMessages();
        callback();
      });
    });
  }

  void uploadFiles(String chatId, List<UploadFile> files, Function() callback) {
    Utils().showLoaderDialog(mContext, 'Uploading File');

    API().uploadFiles(chatId, files, (isSuccess) {
      Navigator.pop(mContext);

      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error uploading file');
        return null;
      }

      startChat(chats![currentIndex].id, () {
        listenForMessages();
        callback();
      });
    });
  }

  void startChat(String chatId, Function() callback) {
    API().startChat(chatId, (isSuccess) {
      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error starting chat');
        return null;
      }

      callback();
    });
  }

  void newChat(Function(String chatId) callback) {
    API().newChat((isSuccess, id) {
      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error creating new chat');
        return null;
      }

      callback(id);
    });
  }

  void deleteChat(String chatId, int index) {
    API().deleteChat(chatId, (isSuccess) {
      if (!isSuccess) {
        Utils().showSnackBar(mContext, 'Error deleting chat');
        return null;
      }

      setState(() {
        // empty the messages array
        messages?.clear();

        // remove the chat from chats list
        chats?.removeAt(index);

        // check if chats not empty, select the first chat after delete
        if (chats!.isNotEmpty) {
          currentIndex = 0;
        } else {
          currentIndex = -1;
        }
      });
    });
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(mContext).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
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
                width: kIsWeb ? 400 : double.infinity,
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
                    filesListView(setDialogState),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Opacity(
                            opacity: (chats!.isEmpty ||
                                    chats![currentIndex].files.length < 4)
                                ? 1
                                : 0.5,
                            child: TextButton(
                              onPressed: (chats!.isEmpty ||
                                      chats![currentIndex].files.length < 4)
                                  ? () async {
                                      if (kIsWeb) {
                                        uploadFileWeb(setDialogState);
                                      } else {
                                        uploadFileMobile(setDialogState);
                                      }
                                    }
                                  : null,
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

  Widget filesListView(setDialogState) {
    if (chats!.isNotEmpty && currentIndex != -1) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: chats![currentIndex].files.length,
          itemBuilder: (BuildContext context, int i) {
            String file = chats![currentIndex].files[i];

            return ListTile(
              leading: file.toLowerCase().endsWith('.pdf')
                  ? Image.asset('assets/images/pdf.png', width: 30, height: 30)
                  : Image.asset('assets/images/picture.png',
                      width: 30, height: 25),
              title: Text(file),
              trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    removeFile(chats![currentIndex].id, file, () {
                      setDialogState(() {
                        chats![currentIndex].files.removeAt(i);
                      });
                    });
                  }),
            );
          });
    } else {
      return const Spacer();
    }
  }

  void uploadFileMobile(setDialogState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
        allowMultiple: false);

    if (result != null) {
      File file = File(result.files.single.path!);
      UploadFile uFile = UploadFile(
          name: basename(file.path), bytes: result.files.single.bytes!);

      uploadFiles(chats![currentIndex].id, [uFile], () {
        setDialogState(() {
          chats![currentIndex].files.add(basename(file.path));
        });
      });
    } else {
      // User canceled the picker
    }
  }

  void uploadFileWeb(setDialogState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
        allowMultiple: false);

    if (result != null) {
      UploadFile uFile = UploadFile(
          name: result.files.single.name, bytes: result.files.single.bytes!);

      uploadFiles(chats![currentIndex].id, [uFile], () {
        setDialogState(() {
          chats![currentIndex].files.add(result.files.single.name);
        });
      });
    } else {}
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
