import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:turbo_fireauth/turbo_fireauth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TurboFireAuth.instance.initialize(
    //You may not need all of these options
    //For example, if you intiialized your project with FlutterFireCLI
    //You can remove the options parameter, as you should have a
    //firebase_options.dart file in your project
    options: FirebaseOptions(
      apiKey: "YOUR_API_KEY", // Get an API key from Firebase Console
      appId: "YOUR_APP_ID", // Get an App ID from Firebase Console
      messagingSenderId:
          "YOUR_MESSAGING_SENDER_ID", // Get a Messaging Sender ID from Firebase Console
      projectId: "YOUR_PROJECT_ID", // Get a Project ID from Firebase Console
    ),
    googleSigninConfig: GoogleSigninConfig(
      option: GoogleSigninOption.standard,
      clientId: "YOUR_CLIENT_ID", // Get a client ID from Google Cloud Console
      serverClientId:
          "YOUR_SERVER_CLIENT_ID", // Get a server client ID from Google Cloud Console
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Turbo Fireauth Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    await TurboFireAuth.instance.login(GoogleLogin());
                    debugPrint("Trying to login with Google...");
                  } catch (e) {
                    debugPrint("Error : $e");
                  }
                },
                child: const Text('Sign in with Google'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await TurboFireAuth.instance.login(
                      EmailLogin("user@example.com", "password123"),
                    );
                    debugPrint("Trying to login with Email...");
                  } catch (e) {
                    debugPrint("Error : $e");
                  }
                },
                child: const Text('Sign in with Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await TurboFireAuth.instance.login(FacebookLogin());
                    debugPrint("Trying to login with Facebook...");
                  } catch (e) {
                    debugPrint("Error : $e");
                  }
                },
                child: const Text('Sign in with Facebook'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
