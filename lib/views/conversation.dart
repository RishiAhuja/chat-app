import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:vengamo_chat_ui/theme/app_color.dart';
import 'package:vengamo_chat_ui/vengamo_chat_ui.dart';

class Conversation extends StatefulWidget {
  final roomId;
  final name;
  final svg;
  Conversation({required this.roomId, required this.svg, required this.name, super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {


  final DatabaseMethods _databaseMethods = DatabaseMethods();
  final TextEditingController _messageController = TextEditingController();
  Stream? streamForInitialMessages;
  DateTime now = DateTime.now();

  Widget chatList(){
    return StreamBuilder(
        stream: streamForInitialMessages,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return MessageTile(message: (snapshot.data.docs[index].data())["message"],
                sentByLocalUser: (((snapshot.data.docs[index].data())["sender"]).toString() == Constants.localUsername ) ? true : false,
                time: DateTime.fromMillisecondsSinceEpoch(int.parse(
                    ((snapshot.data.docs[index].data())["time"]).toString()
                ))

              );
            },
          ) : Center(child: CircularProgressIndicator(color: HexColor("#5953ff"),));
        }
    );
  }

  sendMessage() async{
    String formattedTime = DateFormat('HH:mm').format(now);
    String date = "${now.day}/${now.month}/${now.year}";
    Map<String, dynamic> userMap = {
      "message": _messageController.text.trim(),
      "sender": Constants.localUsername,
      "time": DateTime
          .now()
          .millisecondsSinceEpoch,
      "date": date
    };
    setState(() {
      _messageController.text = "";
    });
    await _databaseMethods.conversation(widget.roomId, userMap).then((a){print("done: $a");});
  }
  @override

  void initState(){
    getInitialMessages();
    super.initState();
  }

  getInitialMessages() async {
    _databaseMethods.getConversation(widget.roomId).then((val){
      setState(() {
        streamForInitialMessages = val;
      });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#131419"),
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
                RandomAvatar(
                  widget.svg,
                  height: 45,
                  width: 45
                ),
              const SizedBox(width: 15),
              Text(
                widget.name,
                style: GoogleFonts.archivo(
                  color: Colors.white,
                  fontSize: 20
                ),
              )
            ],
          ),
        ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_outlined, color: Colors.white)
          ),
          backgroundColor: HexColor("#262630"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            chatList(),
            const SizedBox(height: 60),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: HexColor("#262630"),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10))),
                      child: TextFormField(
                          style: GoogleFonts.archivo(color: Colors.white),
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Write a message",
                            hintStyle: GoogleFonts.archivo(),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {sendMessage();},
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // color: HexColor("#d7dfa3"),
                            color: HexColor("#1d1d29"),
                            // color: HexColor("#262630"),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(10))),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sentByLocalUser;
  final DateTime time;
  MessageTile({required this.message, required this.sentByLocalUser, required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 50,
    //   child: Text(message!, style: TextStyle(color: Colors.white),),
    // );
    return Column(
      children: [
        BubbleNormal(
          text: message,
          tail: true,
          color: sentByLocalUser ? HexColor("#5953ff") : HexColor("#2e333d"),
          sent: false,
          isSender: sentByLocalUser,
          textStyle: GoogleFonts.archivo(
            color: Colors.white,
            fontSize: 18
          ),
        ),
        // VengamoChatUI(
        //   senderBgColor: HexColor("#5953ff"),
        //   receiverBgColor: HexColor("#2e333d"),
        //   isSender: sentByLocalUser,
        //   isNextMessageFromSameSender: false,
        //   time: DateFormat("HH:mm").format(time),
        //   timeLabelColor : Colors.white,
        //   text: Text(
        //       message,
        //     style: GoogleFonts.archivo(
        //         color: Colors.white,
        //         fontSize: 16
        //     ),
        //   ),
        //   pointer: true,
        //   ack: const Icon(
        //     Icons.check,
        //     color: AppColors.iconColor, // You can customize the color here
        //     size: 13, // You can customize the size here
        //   ),
        // ),
        // Text("${time?.hour}:${time?.minute}:${time?.second}", style: GoogleFonts.archivo(color: Colors.white),),
        const SizedBox(height: 5)
      ],
    );

  }
}
