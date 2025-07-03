import 'dart:io';
import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cubix/Auth/CometChatConfig.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    user = CometChatUIKit.loggedInUser;
  }

  Future<String?> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    setState(() => isUploading = true);

    final file = File(pickedFile.path);
    final fileName = 'avatars/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      await Supabase.instance.client.storage
          .from('avatars') // 🔁 Your bucket name
          .upload(fileName, file);

      final publicUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      debugPrint("❌ Supabase Upload Error: $e");
      return null;
    } finally {
      setState(() => isUploading = false);
    }
  }

  void updateCometChatAvatar(String avatarUrl) {
    if (user == null) return;

    final updatedUser = User(
      uid: user!.uid,
      name: user!.name,
      avatar: avatarUrl,
    );

    CometChat.updateUser(
      updatedUser,
      CometChatConfig.authKey,
      onSuccess: (updated) {
        debugPrint("✅ Avatar updated!");
        setState(() {
          user = updated;
        });
      },
      onError: (e) {
        debugPrint("❌ Failed to update avatar: ${e.message}");
      },
    );
  }

  void handleAvatarChange() async {
    final avatarUrl = await uploadProfilePicture();
    if (avatarUrl != null) {
      updateCometChatAvatar(avatarUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: textColor,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            (user!.avatar != null && user!.avatar!.isNotEmpty)
                            ? NetworkImage(user!.avatar!)
                            : null,
                        child: (user!.avatar == null || user!.avatar!.isEmpty)
                            ? Text(
                                user!.name.isNotEmpty
                                    ? user!.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.black,
                                ),
                              )
                            : null,
                      ),
                      if (!isUploading)
                        GestureDetector(
                          onTap: handleAvatarChange,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      if (isUploading)
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                            height: 36,
                            width: 36,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user?.name ?? 'N/A',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "+91 ${user?.uid ?? 'N/A'}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Spacer(),

                  /// Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CometChatUIKit.logout(
                          onSuccess: (_) {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          onError: (e) {
                            debugPrint("Logout failed: ${e.message}");
                          },
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
