import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/authenticate.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/helper.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/views/forgotp.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:random_avatar/random_avatar.dart';

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
    String? svg;

    await _helper.getName().then((val){
      name = val;
    });
    await _helper.getEmail().then((val){
      email = val;
    });
    print("debugger2");
    await _helper.getSvg().then((val){
      svg = val;
    });
    print(svg);
    Constants.localUsername = name!;
    Constants.localEmail = email!;
    Constants.localSvg = svg!;

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
      backgroundColor: Constants.backgroundColor,
      drawer: Drawer(

        child: Container(
          decoration: BoxDecoration(
            color: HexColor("#262630")
          ),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: RandomAvatar(
                  Constants.localSvg,
                  height: MediaQuery.of(context).size.width/2,
                  width: MediaQuery.of(context).size.width/2
                ),
              ),
              Text(
                Constants.localUsername,
                style: GoogleFonts.archivo(
                  color: Colors.white,
                  fontSize: 25
                ),
              ),
              Text(
                Constants.localEmail,
                style: GoogleFonts.archivo(
                    color: Colors.white,
                    fontSize: 18
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ForgotP(email: Constants.localEmail))
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: HexColor("#5953ff"),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Forgot password?",
                        style: GoogleFonts.archivo(
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color here
        ),
        title: Text(
          "Chat Rooms",
          style: GoogleFonts.archivo(
            color: Colors.white,
            fontSize: 24
          ),
        ),
      toolbarHeight: 70,
        backgroundColor: Constants.backgroundColor,
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut();
              _helper.setLogStatus(false);
              _helper.setName("");
              _helper.setSvg("");
              _helper.setEmail("");
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
      body: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
                height: MediaQuery.of(context).size.height * .7,
                child: chatRoomList())
          ],
        ),
      ),
    );
  }

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {

    //     if((snapshot.data.docs[0].data())["unreadMessages"] != null){
    //       print((snapshot.data.docs[0].data())["unreadMessages"][Constants.localUsername.toString()]);
    // }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.archivo(color: Colors.red),));
          }

          if (!snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                  child: Text(
                    'No chats rooms found, please create a chat room by searching for a user',
                    style: GoogleFonts.archivo(color: Colors.white60),
                  )
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                unreadMessages: ((snapshot.data.docs[index].data())["unreadMessages"] != null)
                ? (snapshot.data.docs[index].data())["unreadMessages"][Constants.localUsername.toString()]
                : 0,
                username: (Constants.localUsername != (snapshot.data.docs[index].data())["users"][0])
                ? (snapshot.data.docs[index].data())["users"][0] :
                (snapshot.data.docs[index].data())["users"][1],
                roomId: (snapshot.data.docs[index].data())["chatRoomId"],
                svg: (Constants.localSvg != (snapshot.data.docs[index].data())["userSvg"][0]) ?
                  (snapshot.data.docs[index].data())["userSvg"][0]
                : (snapshot.data.docs[index].data())["userSvg"][1],
              );
            },
          );
        }
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String? username;
  final String? email;
  final String? roomId;
  final String? svg;
  final int? unreadMessages;

  ChatRoomTile({required this.unreadMessages, required this.username, this.email, required this.roomId, required this.svg, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => Conversation(
                roomId: roomId,
                name: username,
                svg: svg
            ))
          );
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 70,
                  decoration: BoxDecoration(
                      // color: HexColor("#2b2547"),
                    color: HexColor("#262630"),
                      borderRadius:
                      BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          RandomAvatar(
                            svg!,
                            height: 50,
                            width: 52,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            username!.trim(),
                            style: GoogleFonts.archivo(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if(unreadMessages !=0) CircleAvatar(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: HexColor("#5953ff"),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              unreadMessages.toString(),
                              style: GoogleFonts.archivo(
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),

              // Expanded(
              //   flex: 1,
              //   child: GestureDetector(
              //
              //     child: Container(
              //         height: 60,
              //         decoration: BoxDecoration(
              //             color: HexColor("#5953ff"),
              //             // borderRadius: const BorderRadius.horizontal(
              //             //     right: Radius.circular(10))
              //         ),
              //         child: const Icon(
              //           Icons.email,
              //           color: Colors.white,
              //         )),
              //   ),
              // ),
            ],
          ),
          // const Divider(
          //   color: Colors.grey,
          //   thickness: 1.0,
          //   indent: 0, // Removes the horizontal margin
          //   endIndent: 0, // Removes the horizontal margin
          //   height: 1, // Adjusts the vertical margin
          // )
        ],
      ),
    );
  }

}
