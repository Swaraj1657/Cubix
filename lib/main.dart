import 'package:cubix/Auth/CometChatConfig.dart';
import 'package:cubix/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeCometChat();
  await Supabase.initialize(
    url:
        'https://hangoycfkyxntyyurnhi.supabase.co', // 🔁 Your Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhbmdveWNma3l4bnR5eXVybmhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1NTI1NTAsImV4cCI6MjA2NzEyODU1MH0.xG3MMcPbSFuYRs7RjTS_gtxzh7HznOjM7uSkiQelaj0', // 🔁 Your Supabase anon/public API key
  );
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}

Future<void> _initializeCometChat() async {
  final settings = UIKitSettingsBuilder()
    ..subscriptionType = CometChatSubscriptionType.allUsers
    ..autoEstablishSocketConnection = true
    ..appId = CometChatConfig.appId
    ..region = CometChatConfig.region
    ..authKey = CometChatConfig.authKey
    ..extensions = CometChatUIKitChatExtensions.getDefaultExtensions()
    ..callingExtension = CometChatCallingExtension();

  await CometChatUIKit.init(uiKitSettings: settings.build());
  debugPrint("✅ CometChat UI Initialized");
}
