import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/Calls/CallLogs.dart';
import 'package:cubix/CreateGroup/CreateGroupUi.dart';
import 'package:cubix/Home/Account.dart';
import 'package:cubix/Tabs/Conversations.dart';
import 'package:cubix/Tabs/Groups.dart';
import 'package:cubix/Tabs/User.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        WidgetsBindingObserver,
        CometChatUIEventListener,
        CallListener,
        CometChatCallEventListener {
  @override
  void initState() {
    super.initState();

    CometChat.addCallListener("CALL_LISTENER", this);
    CometChatCallEvents.addCallEventsListener("CALL_EVENTS", this);
  }

  @override
  void dispose() {
    CometChat.removeCallListener("CALL_LISTENER");
    CometChatCallEvents.removeCallEventsListener("CALL_EVENTS");
    super.dispose();
  }

  void showIncomingCallDialog(BuildContext context, User user, Call call) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        alignment: Alignment.topCenter,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 180,
          child: CometChatIncomingCall(
            user: user,
            call: call,
            onAccept: (BuildContext ctx, Call acceptedCall) {
              Navigator.of(ctx).pop();
              _handleIncomingCall(acceptedCall);
            },
            onDecline: (BuildContext ctx, Call declinedCall) {
              Navigator.pop(ctx);
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

    CometChat.acceptCall(
      call.sessionId!,
      onSuccess: (acceptedCall) {
        Navigator.pop(context); // Close popup
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
  void onIncomingCallReceived(Call call) async {
    final callStateController = CallStateController.instance;
    if (callStateController.isActiveCall.value ||
        callStateController.isActiveOutgoingCall.value ||
        callStateController.isActiveIncomingCall.value) {
      IncomingCallOverlay.dismiss();
      return;
    }

    final callerUid = call.sender?.uid;
    if (callerUid == null || callerUid.isEmpty) return;

    try {
      User? caller = await CometChat.getUser(
        callerUid,
        onSuccess: (User user) {},
        onError: (CometChatException excep) {},
      );
      if (caller != null && mounted) {
        showIncomingCallDialog(context, caller, call);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => IncomingCallExample(user: caller, call: call),
        //   ),
        // );
      }
    } catch (e) {
      debugPrint("Error handling incoming call: $e");
    }
  }

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Conversations(),
    Groups(),
    Center(child: Text('Meetings UI here')),
    CallLogsExample(),
    CometChatCreateGroup(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(
          'Cubix',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          AccountPopupMenu(isDark: isDark),
        ],
        elevation: 1,
      ),

      body: Container(
        color: isDark ? Colors.black : Colors.white,
        child: _screens[_selectedIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1baff3),
        unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Meetings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
      ),

      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "ai",
                  onPressed: () {},
                  backgroundColor: const Color(0xFF1baff3),
                  child: const Icon(Icons.smart_toy, color: Colors.white),
                  mini: true,
                  tooltip: 'AI Assistant',
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: "users",
                  onPressed: () {
                    if (_selectedIndex == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Users()),
                      );
                    } else {
                      showCreateGroup(context);
                    }
                  },
                  backgroundColor: const Color(0xFF1baff3),
                  child: Icon(
                    _selectedIndex == 0 ? Icons.person_add : Icons.group_add,
                    color: Colors.white,
                  ),
                  tooltip: _selectedIndex == 0
                      ? 'Start New Chat'
                      : 'Create New Group',
                ),
              ],
            )
          : null,
    );
  }
}
