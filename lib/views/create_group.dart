import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:random_avatar/random_avatar.dart';

class CreateGroup extends StatefulWidget {

  CreateGroup({super.key});
  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

List groupList = [];
List<int> selectedIndices = [];

class _CreateGroupState extends State<CreateGroup> {

  String svg = DateTime.now().toIso8601String();
  final DatabaseMethods _database = DatabaseMethods();
  Stream? chatRoomStream;

  void initState(){
    getUserData();
    super.initState();
  }

  getUserData() async{
    await _database.getChatRooms(Constants.localUsername).then((val){
      setState(() {
        chatRoomStream = val;
        print(val);
      });
    });
    // print(Constants.localUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Create Group",
            style: GoogleFonts.archivo(color: Colors.white, fontSize: 20),
          ),
        ),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_outlined, color: Colors.white)),
        backgroundColor: HexColor("#262630"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                // const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          //for alignment
                          Opacity(
                            opacity: 0,
                            child: GestureDetector(
                              onTap: changeAvatar,
                              child: const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          RandomAvatar(
                              svg,
                              height: MediaQuery.of(context).size.height/9
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: changeAvatar,
                            child: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),

                        ],
                      ),

                      Expanded(
                        child: Container(
                          height: 55,
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: HexColor("#262630"),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                    style: GoogleFonts.archivo(color: Colors.white),
                                    // controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: "Search username",
                                      hintStyle: GoogleFonts.archivo(),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    )),
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: chatRoomList()),
                const SizedBox(height: 60),
              ],
            ),
          ),
          //second stack widget
          Positioned(
            bottom: 0, // Position at the bottom
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: HexColor("#262630"),
              height: 90, // Height of the bottom widget
              width: MediaQuery.of(context).size.width * .8,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: groupList.length,
                  itemBuilder: (BuildContext context, int index){
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 5),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      // selectedIndices.remove(index);
                                      print("lol");
                                      // groupList.remove(groupList[index]);
                                    });
                                  },
                                  child: RandomAvatar(
                                      Constants.localSvg != (groupList[index])["userSvg"][0]
                                          ? (groupList[index])["userSvg"][0] : (groupList[index])["userSvg"][1],
                                    height: 40
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(20, -10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(100)
                                      ),
                                      child: const Icon(
                                          Icons.remove,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            Constants.localSvg == (groupList[index])["users"][0]
                                ? (groupList[index])["users"][0] : (groupList[index])["users"][1],
                            style: GoogleFonts.archivo(
                              color: Colors.white,
                              fontSize: 12
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  changeAvatar() {
    setState(() {
      svg = DateTime.now().toIso8601String();
      print(svg);
    });
  }


  //chatlist

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {

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
            shrinkWrap: false,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return selectedIndices.contains(index) ? Container() : ExistingTiles(
                onAdd: (){
                  setState(() {
                    if (!selectedIndices.contains(index)) {
                      groupList.add(snapshot.data.docs[index].data()); // Add data to groupList
                      selectedIndices.add(index); // Track selected index
                    }
                  });
                },
                index: index,
                indexMap: snapshot.data.docs[index].data(),
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


class ExistingTiles extends StatefulWidget {
  final String? username;
  final String? email;
  final String? roomId;
  final String? svg;
  final int? unreadMessages;
  final Map indexMap;
  final int index;
  final VoidCallback onAdd;

  ExistingTiles({
    required this.unreadMessages,
    required this.username,
    this.email,
    required this.roomId,
    required this.svg,
    required this.indexMap,
    required this.index,
    required this.onAdd,
    super.key});

  @override
  State<ExistingTiles> createState() => _ExistingTilesState();
}

class _ExistingTilesState extends State<ExistingTiles> {
  @override
  Widget build(BuildContext context) {
    return selectedIndices.contains(widget.index) ? Container() : Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 30),
                height: 50,
                decoration: BoxDecoration(
                    color: HexColor("#262630"),
                    borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10))
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        RandomAvatar(widget.svg!, height: 50, width: 52),
                        const SizedBox(width: 8),
                        Text(
                          widget.username!.trim(),
                          style: GoogleFonts.archivo(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    // groupList.add(widget.indexMap);
                    // selectedIndices.add(widget.index);
                    widget.onAdd();
                  });
                  print(groupList);
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  margin: const EdgeInsets.only(top: 3, bottom: 3, right: 30),
                  decoration: BoxDecoration(
                      color: HexColor("#5953ff"),
                      borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(10))
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
