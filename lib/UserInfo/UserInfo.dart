import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:intl/intl.dart';

class UserInfoScreen extends StatelessWidget {
  final User user;

  const UserInfoScreen({super.key, required this.user});

  String formatLastSeen(int? timestamp) {
    if (timestamp == null || timestamp == 0) return "Not available";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MMM dd • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text("User Info"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                ? NetworkImage(user.avatar!)
                : const AssetImage("assets/default_avatar.png")
                      as ImageProvider,
          ),

          const SizedBox(height: 10),

          Text(
            user.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Last Seen: ${DateFormat('dd/MM/yyyy, HH:mm:ss').format(user.lastActiveAt ?? DateTime.now())}",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton(
                context,
                user,
                Icons.phone,
                "Voice",
                CallTypeConstants.audioCall,
                isDark,
              ),
              const SizedBox(width: 20),
              _actionButton(
                context,
                user,
                Icons.videocam,
                "Video",
                CallTypeConstants.videoCall,
                isDark,
              ),
            ],
          ),

          const SizedBox(height: 50),

          Divider(height: 1, color: isDark ? Colors.white24 : Colors.black12),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.red),
            title: const Text("Block", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              "Delete Chat",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    User user,
    IconData icon,
    String label,
    String callType,
    bool isDark,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        Call call = Call(
          receiverUid: user.uid,
          receiverType: ReceiverTypeConstants.user,
          type: callType,
        );

        CometChatUIKitCalls.initiateCall(
          call,
          onSuccess: (Call returnedCall) {
            returnedCall.category = MessageCategoryConstants.call;
            CometChatCallEvents.ccOutgoingCall(returnedCall);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CometChatOutgoingCall(call: returnedCall, user: user),
              ),
            );
          },
          onError: (CometChatException e) {
            debugPrint('Error in initiating call: ${e.message}');
          },
        );
      },
      icon: Icon(icon, color: Colors.deepPurple),
      label: Text(
        label,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
