import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/authenticate.dart';
import 'package:chat_app/services/helper.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../services/constants.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final AuthMethods _auth = AuthMethods();
  final Helper _helper = Helper();
  @override

  void initState(){
    getUserData();
    super.initState();
  }

  getUserData() async{
    String? name;
    String? email;
    await _helper.getName().then((val){
      name = val;
    });
    await _helper.getEmail().then((val){
      email = val;
    });
    Constants.localUsername = name!;
    Constants.localEmail = email!;

    print(Constants.localUsername);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#131419"),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_outlined, color: Colors.white)
        ),
        backgroundColor: HexColor("#131419"),
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authenticate()));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Search())),
        backgroundColor: HexColor("#5953ff"),
        child: Icon(Icons.search, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container()
      ),
    );
  }
}
