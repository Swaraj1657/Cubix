import 'package:flutter/material.dart' hide Action;
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class LeaveGroup {
  void leaveGroup(BuildContext context, Group group) async {
    final loggedInUser = await CometChat.getLoggedInUser();
    if (loggedInUser == null) return;

    if (group.owner == loggedInUser.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text(
            "Group owner cannot leave the group.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    _showConfirmDialog(context, group, loggedInUser);
  }

  void _showConfirmDialog(
    BuildContext context,
    Group group,
    User loggedInUser,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Leave Group"),
        content: const Text("Are you sure you want to leave this group?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Cancel",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _confirmLeave(context, group, loggedInUser);
            },
            child: const Text("Leave", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmLeave(BuildContext context, Group group, User user) {
    final muid = DateTime.now().microsecondsSinceEpoch.toString();

    CometChat.leaveGroup(
      group.guid,
      onSuccess: (response) {
        final actionMessage = Action(
          muid: muid,
          message: "${user.name} left the group",
          sender: user,
          receiverUid: group.guid,
          receiverType: ReceiverTypeConstants.group,
          type: MessageTypeConstants.groupActions,
          conversationId: group.guid,
          parentMessageId: 0,
          oldScope: GroupMemberScope.participant,
          newScope: "",
        );

        CometChatGroupEvents.ccGroupLeft(actionMessage, user, group);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("You left the group.")));

        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      onError: (e) {
        debugPrint("Leave failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to leave group: ${e.message}"),
          ),
        );
      },
    );
  }

  void showLeaveGroupBottomSheet(
    BuildContext context,
    VoidCallback onConfirmLeave,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                "Leave this group?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to leave this group?\nYou won’t receive any more messages from this chat.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: subTextColor),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: subTextColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Cancel", style: TextStyle(color: textColor)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirmLeave();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Leave"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
