import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cubix/AddMembers/AddMembers.dart';
import 'package:cubix/LeaveGroup/LeaveGroup.dart';
import 'package:cubix/Message/MessageScreen.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:intl/intl.dart';

class GroupMembers extends StatelessWidget {
  final Group group;

  const GroupMembers({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CometChatAddMembers(group: group),
                ),
              );
            },
            icon: Icon(
              Icons.person_add_alt_1,
              color: isDark ? Colors.lightBlue[200] : const Color(0xFF6852D6),
            ),
          ),
          IconButton(
            onPressed: () {
              LeaveGroup().showLeaveGroupBottomSheet(context, () {
                LeaveGroup().leaveGroup(context, group);
              });
            },
            icon: Icon(
              Icons.logout,
              color: isDark
                  ? Colors.redAccent.shade100
                  : const Color(0xFF6852D6),
            ),
          ),
        ],
      ),

      backgroundColor: isDark ? Colors.black : Colors.white,

      body: Column(
        children: [
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 35,
                backgroundImage: group.icon != null && group.icon!.isNotEmpty
                    ? NetworkImage(group.icon!)
                    : const AssetImage("assets/default_avatar.png")
                          as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "About : ${group.description}",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                    Text(
                      "Created by ${group.owner} At ${group.createdAt}",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: CometChatGroupMembers(
              group: group,
              hideAppbar: true,
              onLoad: (list) {
                debugPrint("✅ Loaded ${list.length} members");
              },

              onItemTap: (groupMember) {
                User user = User(
                  uid: groupMember.uid,
                  name: groupMember.name,
                  avatar: groupMember.avatar,
                  status: groupMember.status,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagesScreen(user: user),
                  ),
                );
              },

              subtitleView: (context, member) {
                final dateTime = member.joinedAt ?? DateTime.now();
                final subtitle =
                    "Joined at ${DateFormat('dd/MM/yyyy').format(dateTime)}";

                return Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xFF727272),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
