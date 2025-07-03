import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/Message/MessageScreen.dart';
import 'package:flutter/material.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CometChatGroups(
          hideAppbar: true,
          onItemTap: (context, group) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreen(group: group),
              ),
            );
          },
        ),
      ),
    );
  }
}
