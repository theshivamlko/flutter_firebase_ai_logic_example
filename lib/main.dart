import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'chat_page.dart';
import 'default_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  DefaultFirebaseOptions.loadFirebaseApp(dotenv.env);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChatPage(),
    );
  }
}

