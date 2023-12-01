import 'dart:convert';
import 'package:talk2docs/home/web/file_upload_modal.dart';
import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/views/chat_bubble.dart';
import 'web/chat_item_widget.dart';

class HomePageWeb extends HomePage {
  HomePageWeb({Key? key}) : super(key: key);

  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends HomePageState<HomePageWeb> {
  String userQuestion = '';
  List<String> chatHistory = [];
  late SharedPreferences prefs;
  late String fullName = "";
  List<Map<String, String>> chatHistory2 = [];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadChatHistory();
  }

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString("fullName") ?? "";
    print(fullName);
    setState(() {});
  }

  void handleUserInput() {
    // Implement the logic to handle user input and update chat history
    // setState(() {
    //   chatHistory.add('You: $userQuestion');
    //   chatHistory.add('Bot: This is a dummy response.');
    // });
  }

  void editChatName(String chatId, String newName) {
    // Implement the logic to edit chat name
    // Example: Call your API or update your chat data
  }

  void deleteChat(String chatId) {
    // Implement the logic to delete chat
    // Example: Call your API or update your chat data
  }

  _loadChatHistory() {
    // Replace this with your logic to load chat history from JSON
    // For example, you can read the JSON from a file or an API response
    String chatHistoryJson =
        '[{"id": "1", "name": "General Chat"},{"id": "2", "name": "Support Chat"},{"id": "3", "name": "Team Chat"}]';

    // Explicitly convert each item to Map<String, String>
    List<dynamic> decodedList = json.decode(chatHistoryJson);
    chatHistory2 = List<Map<String, String>>.from(
      decodedList.map((item) => Map<String, String>.from(item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDDFFFFFF),
      body: Row(
        children: [
          // Sidebar
          Drawer(
            child: Container(
              color: const Color(0xFF000026),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Other menu items
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
                      itemCount: chatHistory2.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChatItemWidget(
                          chatId: chatHistory2[index]['id']!,
                          chatName: chatHistory2[index]['name']!,
                          onEditChatName: (newName) {
                            // Implement the logic to edit chat name
                            editChatName(chatHistory2[index]['id']!, newName);
                          },
                          onDeleteChat: (chatId) {
                            // Implement the logic to delete chat
                            deleteChat(chatId);
                          },
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                openFileUploadModal(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: Text(
                                'Upload Docs',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: ListView(
                            children: const [
                              // Fake conversation for demonstration
                              ChatBubble(
                                  message:
                                      'Bot: Hello! How can I help you today?',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: Hi! I have a question about document management.',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: Sure, feel free to ask your question.',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: Is it possible to organize documents by categories?',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: Absolutely! You can create custom categories for better organization.',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: That sounds great! How can I get started?',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: You can go to the settings and find the "Categories" section.',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: Thank you! I will check it out.',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: You\'re welcome! If you have any more questions, feel free to ask.',
                                  isUser: false),
                              ChatBubble(
                                  message: 'You: Sure, I will do that.',
                                  isUser: true),
                              ChatBubble(
                                  message: 'Bot: Have a great day!',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: I have another question about file formats.',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: Of course! What would you like to know about file formats?',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: Can I upload PDF and Word documents?',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: Yes, you can upload both PDF and Word documents.',
                                  isUser: false),
                              ChatBubble(
                                  message:
                                      'You: That\'s convenient. Thanks for the information!',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: Anytime! If you have more questions, feel free to ask.',
                                  isUser: false),
                              ChatBubble(
                                  message: 'You: I appreciate your assistance.',
                                  isUser: true),
                              ChatBubble(
                                  message:
                                      'Bot: It\'s my pleasure! Have a wonderful day!',
                                  isUser: false),
                            ],
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
                  onChanged: (value) {
                    setState(() {
                      userQuestion = value;
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
                          // Implement the logic to attach PDF files
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // Implement the logic to handle user input and update chat history
                          handleUserInput();
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
}