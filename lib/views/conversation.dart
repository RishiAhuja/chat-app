import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class Conversation extends StatefulWidget {
  final roomId;

  Conversation({required this.roomId, super.key});

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
              // return SizedBox();
              return MessageTile(message: (snapshot.data.docs[index].data())["message"] );
            },
          ) : const SizedBox();
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
        backgroundColor: HexColor("#131419"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            chatList(),
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
  final String? message;
  MessageTile({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Text(message!, style: TextStyle(color: Colors.white),),
    );
  }
}
