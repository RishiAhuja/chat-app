import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  final DatabaseMethods _database = DatabaseMethods();
  QuerySnapshot? querySnapshot;
  Widget searchList() {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: querySnapshot?.docs.length,
        itemBuilder: (context, index) {
          return UserTile(
              email: (querySnapshot?.docs[index].data()
                  as Map<String, dynamic>)["email"],
              username: (querySnapshot?.docs[index].data()
                  as Map<String, dynamic>)["name"]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#131419"),
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_outlined, color: Colors.white)),
          backgroundColor: HexColor("#131419")),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // width: MediaQuery.of(context).size.width / 3,
                      height: 70,
                      // margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: HexColor("#262630"),
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                                style: GoogleFonts.archivo(color: Colors.white),
                                controller: searchController,
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
                  InkWell(
                    onTap: () {
                      getUserDataList();
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: HexColor("#1d1d29"),
                          // color: HexColor("#262630"),
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              querySnapshot == null ? Container() : searchList(),
            ],
          ),
        ),
      ),
    );
  }

  getUserDataList() {
    _database.searchUsersByName(searchController.text.trim()).then((val) {

      setState(() {
        querySnapshot = val;
      });
      Map<String, dynamic> data =
          querySnapshot?.docs[0].data() as Map<String, dynamic>;

      print(data["name"]);
      print(data["email"]);
      print(data["password"]);
    });
  }
}

class UserTile extends StatelessWidget {
  final String username;
  final String email;

  UserTile({required this.email, required this.username, super.key});
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
                  username,
                  style: GoogleFonts.archivo(color: Colors.white, fontSize: 18),
                ),
                Text(
                  email,
                  style: GoogleFonts.archivo(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
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
        )
      ],
    );
  }
}
