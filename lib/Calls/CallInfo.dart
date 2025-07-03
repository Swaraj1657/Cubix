import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/Message/MessageScreen.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart';
import 'package:intl/intl.dart';

class CallInfoScreen extends StatefulWidget {
  final CallLog callLog;
  const CallInfoScreen({super.key, required this.callLog});

  @override
  State<CallInfoScreen> createState() => _CallInfoScreenState();
}

class _CallInfoScreenState extends State<CallInfoScreen> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final loggedInUser = CometChatUIKit.loggedInUser;
    String? otherUserId;

    if (widget.callLog.participants != null) {
      for (var participant in widget.callLog.participants!) {
        if (participant.uid != loggedInUser?.uid) {
          otherUserId = participant.uid;
          break;
        }
      }
    }

    if (otherUserId != null) {
      CometChat.getUser(
        otherUserId,
        onSuccess: (fetchedUser) {
          setState(() {
            user = fetchedUser;
            isLoading = false;
          });
        },
        onError: (e) {
          debugPrint("❌ Failed to fetch user: ${e.message}");
          setState(() => isLoading = false);
        },
      );
    } else {
      debugPrint("⚠️ Could not find other participant");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? Colors.black : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText = isDark ? Colors.white60 : Colors.black54;
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[100];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Call info"),
        backgroundColor: background,
        foregroundColor: primaryText,
        elevation: 0.4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Profile Photo + Name + UID
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            user?.avatar != null && user!.avatar!.isNotEmpty
                            ? NetworkImage(user!.avatar!)
                            : null,
                        backgroundColor: Colors.grey,
                        child: (user?.avatar == null || user!.avatar!.isEmpty)
                            ? Text(
                                user?.name.isNotEmpty == true
                                    ? user!.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: primaryText,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.name ?? "Unknown User",
                        style: TextStyle(
                          fontSize: 20,
                          color: primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "+91 ${user?.uid ?? 'Not available'}",
                        style: TextStyle(fontSize: 14, color: secondaryText),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ACTION BUTTONS: Message, Audio, Video
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Message Button
                      InkWell(
                        onTap: () {
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MessagesScreen(user: user!),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Icon(Icons.message, color: Colors.green, size: 28),
                            const SizedBox(height: 4),
                            Text(
                              "Message",
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Audio Call Button
                      _infoButton(
                        context,
                        user!,
                        Icons.call,
                        "Audio",
                        CallTypeConstants.audioCall,
                        Colors.green,
                        primaryText,
                      ),

                      /// Video Call Button
                      _infoButton(
                        context,
                        user!,
                        Icons.videocam,
                        "Video",
                        CallTypeConstants.videoCall,
                        Colors.green,
                        primaryText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Divider(color: secondaryText),

                  /// Call time & metadata
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _formatDateTime(widget.callLog.startedAt),
                      style: TextStyle(color: secondaryText, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.call_received,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.callLog.status ?? 'Incoming',
                        style: TextStyle(color: primaryText),
                      ),
                      const Spacer(),
                      Text(
                        '${_duration(widget.callLog.startedAt, widget.callLog.endedAt)}',
                        style: TextStyle(color: secondaryText),
                      ),
                      const SizedBox(width: 12),
                      Text('26 KB', style: TextStyle(color: secondaryText)),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDateTime(int? timestamp) {
    if (timestamp == null) return "N/A";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  String _duration(int? start, int? end) {
    if (start == null || end == null || end < start) return "0s";
    final d = Duration(seconds: end - start);
    return "${d.inMinutes}m ${d.inSeconds % 60}s";
  }

  Widget _infoButton(
    BuildContext context,
    User user,
    IconData icon,
    String label,
    String callType,
    Color color,
    Color textColor,
  ) {
    return InkWell(
      onTap: () {
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
            debugPrint('❌ Error in initiating call: ${e.message}');
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
        ],
      ),
    );
  }
}
