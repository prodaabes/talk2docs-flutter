import 'package:flutter/material.dart';

class ChatItemWidget extends StatelessWidget {
  final String chatId;
  final String chatName;
  final Function(String) onEditChatName;
  final Function(String) onDeleteChat;

  const ChatItemWidget({
    Key? key,
    required this.chatId,
    required this.chatName,
    required this.onEditChatName,
    required this.onDeleteChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: ListTile(
        title: Text(
          chatName,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context);
            } else if (value == 'delete') {
              onDeleteChat(chatId);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit', style: TextStyle(color: Color(0xFF000026))),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Color(0xFF000026))),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController(text: chatName);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Chat Name',
              style: TextStyle(color: Color(0xFF000026))),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'New Chat Name',
                labelStyle: TextStyle(color: Color(0xFF000026)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF000026))),
            ),
            TextButton(
              onPressed: () {
                onEditChatName(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save',
                  style: TextStyle(color: Color(0xFF000026))),
            ),
          ],
        );
      },
    );
  }
}
