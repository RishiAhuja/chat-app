import 'package:chat_app/services/authenticate.dart';
import 'package:chat_app/services/helper.dart';
import 'package:chat_app/views/chat_room.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool isLoggedIn = false;
  final Helper _helper = Helper();
  @override
  void initState(){
    getLogStatus();
    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android chat app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? ChatRoom() : Authenticate(),
    );
  }

  getLogStatus() async{
    await _helper.getLogStatus().then((a){
      print("LogStatus: $a");
      setState(() {
        if(a!=null){
          isLoggedIn = a;
        }
      });
    });
  }
}