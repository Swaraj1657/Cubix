// lib/widgets/account_popup_menu.dart

import 'package:cubix/Home/UserProfile.dart';
import 'package:cubix/SignUp_SignIn/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class AccountPopupMenu extends StatelessWidget {
  final bool isDark;
  const AccountPopupMenu({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
          items: [
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context); // close the menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserProfilePage()),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // close the menu
                  CometChatUIKit.logout(
                    onSuccess: (_) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Loginpage()),
                        (route) => false,
                      );
                    },
                    onError: (e) {
                      debugPrint("Logout failed: ${e.message}");
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
