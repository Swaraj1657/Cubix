import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:flutter/material.dart';

class OutgoingCallExample extends StatefulWidget {
  final User? user;
  final Call? callObjet;

  const OutgoingCallExample({super.key, required this.user, this.callObjet});

  @override
  State<OutgoingCallExample> createState() => _OutgoingCallExampleState();
}

class _OutgoingCallExampleState extends State<OutgoingCallExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (widget.user != null && widget.callObjet != null)
            ? CometChatOutgoingCall(user: widget.user!, call: widget.callObjet!)
            : const Center(
                child: Text(
                  "Missing user or call data",
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
