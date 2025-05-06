import 'dart:io';

import 'package:agribot_chat_app/services/pick_image.dart';
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

  Future<void> _handleCamera() async {
    final media = await MediaPicker.pickImageFromCamera();
    if (media != null) {
      sendMessage(
        ChatMessage(
          user: _currentUser,
          createdAt: DateTime.now(),
          medias: [media],
        ),
      );
    }
  }

  Future<void> _handleGallery() async {
    final media = await MediaPicker.pickImageFromGallery();
    if (media != null) {
      sendMessage(
        ChatMessage(
          user: _currentUser,
          createdAt: DateTime.now(),
          medias: [media],
        ),
      );
    }
  }

  Future<void> _handleAttachment() async {
    final media = await MediaPicker.pickFileAttachment();
    if (media != null) {
      sendMessage(
        ChatMessage(
          user: _currentUser,
          createdAt: DateTime.now(),
          medias: [media],
        ),
      );
    }
  }

  void _openImageViewer(String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(),
              backgroundColor: Colors.black,
              body: Center(child: Image.file(File(imagePath))),
            ),
      ),
    );
  }

  Widget _buildMedia(ChatMedia media) {
    switch (media.type) {
      case MediaType.image:
        return GestureDetector(
          onTap: () => _openImageViewer(media.url),
          child: Image.file(
            File(media.url),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.insert_drive_file, size: 40),
            Text(media.fileName),
          ],
        );
    }
  }

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
              onPressed: _handleAttachment,
            ),
            IconButton(
              onPressed: _handleGallery,
              icon: const Icon(Icons.image),
            ),
            IconButton(onPressed: _handleCamera, icon: Icon(Icons.camera_alt)),
          ],
        ),
        messageOptions: MessageOptions(
          showOtherUsersName: true,
          showTime: true,
          messageMediaBuilder: (message, _, __) {
            if (message.medias != null && message.medias!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    message.medias!.map((media) => _buildMedia(media)).toList(),
              );
            }
            return const SizedBox.shrink();
          },
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
