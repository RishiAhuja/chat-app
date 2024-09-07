import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/authenticate.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/helper.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../services/constants.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final DatabaseMethods _database = DatabaseMethods();
  final AuthMethods _auth = AuthMethods();
  final Helper _helper = Helper();
  Stream? chatRoomStream;

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
    await _database.getChatRooms(Constants.localUsername).then((val){
      setState(() {
        chatRoomStream = val;
        print(val);
      });
    });
    // print(Constants.localUsername);
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
        child: const Icon(Icons.search, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Chat Rooms",
                  style: GoogleFonts.archivo(
                    color: Colors.white,
                    fontSize: 25
                  ),
                ),
              ),
              const SizedBox(height: 20),
              chatRoomList()
            ],
          ),
        )
      ),
    );
  }

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                username: (snapshot.data.docs[index].data())["chatRoomId"],
              );
            },
          ) : Container();
        }
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String? username;
  final String? email;

  ChatRoomTile({this.username, this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 80,
            decoration: BoxDecoration(
                color: HexColor("#262630"),
                borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username!.trim(),
                  style: GoogleFonts.archivo(color: Colors.white, fontSize: 18),
                ),
                // Text(
                //   email!.trim(),
                //   style: GoogleFonts.archivo(color: Colors.white, fontSize: 12),
                // ),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(roomId: username)));
            },
            child: Container(
                height: 80,
                decoration: BoxDecoration(
                    color: HexColor("#5953ff"),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10))),
                child: const Icon(
                  Icons.email,
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

}
