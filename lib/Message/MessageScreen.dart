import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cubix/GroupInfo/GroupInfo.dart';
import 'package:cubix/UserInfo/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class MessagesScreen extends StatefulWidget {
  final User? user;
  final Group? group;

  const MessagesScreen({Key? key, this.user, this.group}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: CometChatMessageHeader(
          user: widget.user,
          group: widget.group,
          trailingView: (User? user, Group? group, BuildContext context) {
            return [
              IconButton(
                onPressed: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInfoScreen(user: user),
                      ),
                    );
                  } else if (group != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupMembers(group: group),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.info_outline),
              ),
            ];
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CometChatMessageList(
                  user: widget.user,
                  group: widget.group,
                ),
              ),
              CometChatMessageComposer(user: widget.user, group: widget.group),
            ],
          ),
        ),
      ),
    );
  }
}
