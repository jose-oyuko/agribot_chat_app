import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agri Bot Chat Page')),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        onSend: (ChatMessage m) {
          sendMessage(m);
        },
        messages: _messages,
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {
                // Handle attachment
                debugPrint("Attachment clicked");
              },
            ),
            IconButton(
              onPressed: () {
                // Handle camera
                debugPrint("Camera clicked");
              },
              icon: Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });
    debugPrint("Message sent: ${m.text}");
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    // Add the message to the list of messages
    // setState(() {
    //   _messages.insert(0, m);
    // });
  }
}
