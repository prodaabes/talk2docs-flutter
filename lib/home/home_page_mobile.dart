import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page.dart';

class HomePageMobile extends HomePage {
  const HomePageMobile({super.key});

  @override
  _HomePageMobile createState() => _HomePageMobile();
}

class _HomePageMobile extends HomePageState<HomePageMobile> {
 String userQuestion = '';
  List<String> chatHistory = [];

  void handleUserInput() {
    // Implement the logic to handle user input and update chat history
    // ...

    // Example: Add a dummy response for demonstration
    setState(() {
      chatHistory.add('You: $userQuestion');
      chatHistory.add('Bot: This is a dummy response.');
    });
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
                    title: Text(
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
                  Divider(
                    color: Colors.white,
                  ),
                  // Header with user profile icon, name, and logout button
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align to the bottom
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            // Add your user profile image here
                            // backgroundImage: AssetImage('assets/profile_image.png'),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                          // Logout button
                          trailing: IconButton(
                            icon: Icon(Icons.exit_to_app),
                            onPressed: () {
                              // Implement the logic for Logout
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
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          // Main content
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
                        SizedBox(height: 16),
                        Flexible(
                          child: ListView(
                            children: [
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
                              // Additional conversation
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
                              // More conversation
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
                              // Even more conversation
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
                        icon: Icon(Icons.attach_file),
                        onPressed: () {
                          // Implement the logic to attach PDF files
                          // ...
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

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({Key? key, required this.message, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF000026) : Colors.grey,
          borderRadius: BorderRadius.only(
            topRight: isUser ? Radius.circular(20) : Radius.zero,
            topLeft: isUser ? Radius.zero : Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}