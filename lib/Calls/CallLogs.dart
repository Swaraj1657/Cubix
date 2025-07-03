import 'package:flutter/material.dart';
import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart';
import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cubix/Calls/CallInfo.dart';

class CallLogsExample extends StatefulWidget {
  const CallLogsExample({super.key});

  @override
  State<CallLogsExample> createState() => _CallLogsExampleState();
}

class _CallLogsExampleState extends State<CallLogsExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CometChatCallLogs(
          hideAppbar: true,
          onItemClick: (CallLog callLog) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CallInfoScreen(callLog: callLog),
              ),
            );
          },
        ),
      ),
    );
  }
}
