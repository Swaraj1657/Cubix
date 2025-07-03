import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/Message/MessageScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CometChatUsers(
          // hideAppbar: true,
          onItemTap: (context, user) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreen(user: user),
              ),
            );
          },
          subtitleView: (context, user) {
            String subtitle = "";

            final dateTime = user.lastActiveAt ?? DateTime.now();
            subtitle =
                "Last Active at ${DateFormat('dd/MM/yyyy, HH:mm:ss').format(dateTime)}";

            return Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFF727272),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
      ),
    );
  }
}
