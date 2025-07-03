import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cubix/Auth/CometChatConfig.dart';
import 'package:cubix/Home/HomePage.dart';
import 'package:cubix/SignUp_SignIn/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController uidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;
  bool obscure = true;

  void loginWithCometChat() async {
    String uid = uidController.text.trim();

    if (uid.isEmpty) {
      _showSnackBar("🚨 Please enter your CometChat UID");
      return;
    }

    setState(() => isLoading = true);

    try {
      CometChat.login(
        uid,
        CometChatConfig.authKey,
        onSuccess: (User user) {
          _showSnackBar("✅ Login Successful as ${user.name}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        },
        onError: (CometChatException excep) {
          _showSnackBar("❌ Login Failed: ${excep.message}");
          setState(() => isLoading = false);
        },
      );
    } catch (e) {
      _showSnackBar("❌ Init/Login Error: $e");
      setState(() => isLoading = false);
    }
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
                  "WELCOME",
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

                // Password Input
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
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: isDark ? Colors.lightBlue[200] : Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: isLoading ? null : loginWithCometChat,
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
                      : const Text("Sign In"),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Sign in with other",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Signuppage()),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
