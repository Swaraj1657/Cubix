import 'package:cubix/Auth/CometChatConfig.dart';
import 'package:cubix/SignUp_SignIn/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController uidController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  void _signupWithCometChat() async {
    String uid = uidController.text.trim().toLowerCase();
    String fname = firstNameController.text.trim();
    String lname = lastNameController.text.trim();
    String name = "$fname $lname";

    if (uid.isEmpty || fname.isEmpty || lname.isEmpty) {
      _showSnackBar("🚨 Please fill all fields!");
      return;
    }

    setState(() => isLoading = true);

    User user = User(uid: uid, name: name);

    CometChat.createUser(
      user,
      CometChatConfig.authKey,
      onSuccess: (User createdUser) {
        _showSnackBar("✅ Registered as ${createdUser.uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loginpage()),
        );
      },
      onError: (CometChatException e) {
        _showSnackBar("❌ Registration failed: ${e.message}");
      },
    ).whenComplete(() => setState(() => isLoading = false));
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF1F4F9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.lightBlue[200] : Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: uidController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: "CometChat UID",
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.person,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : null,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: firstNameController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : null,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: lastNameController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : null,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: obscure,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: "Password (Optional)",
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : null,
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: isLoading ? null : _signupWithCometChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.lightBlue[200]
                        : Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up"),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Loginpage()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: isDark
                              ? Colors.lightBlue[200]
                              : Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
