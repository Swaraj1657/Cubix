import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:flutter/material.dart';

class IncomingCallExample extends StatefulWidget {
  final User user;
  final Call call;

  const IncomingCallExample({
    super.key,
    required this.user,
    required this.call,
  });

  @override
  State<IncomingCallExample> createState() => _IncomingCallExampleState();
}

class _IncomingCallExampleState extends State<IncomingCallExample> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showIncomingCallDialog(context, widget.user, widget.call);
    });
  }

  void showIncomingCallDialog(BuildContext context, User user, Call call) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss on tap outside
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 320,
          child: CometChatIncomingCall(
            user: user,
            call: call,
            onAccept: (BuildContext ctx, Call acceptedCall) {
              _handleIncomingCall(acceptedCall);
            },
            onDecline: (BuildContext ctx, Call declinedCall) {
              Navigator.pop(ctx); // Close dialog on decline
            },
          ),
        ),
      ),
    );
  }

  void _handleIncomingCall(Call call) {
    final callStateController = CallStateController.instance;

    if (callStateController.isActiveCall.value ||
        callStateController.isActiveOutgoingCall.value ||
        callStateController.isActiveIncomingCall.value) {
      IncomingCallOverlay.dismiss();
      return;
    }

    // Accept the call and launch the ongoing call screen
    CometChat.acceptCall(
      call.sessionId!,
      onSuccess: (acceptedCall) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CometChatIncomingCall(call: call)),
        );
      },
      onError: (err) {
        debugPrint("Accept call failed: ${err.message}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Listening for incoming call...")),
    );
  }
}
