import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/Message/MessageScreen.dart';
import 'package:flutter/material.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: CometChatConversations(
          hideAppbar: true,
          showBackButton: false,
          onItemTap: (conversation) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreen(
                  user: conversation.conversationWith is User
                      ? conversation.conversationWith as User
                      : null,
                  group: conversation.conversationWith is Group
                      ? conversation.conversationWith as Group
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
