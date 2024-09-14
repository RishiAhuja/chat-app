import 'package:chat_app/services/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp({required this.toggle});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _database = DatabaseMethods();

  QuerySnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Create Account!",
                style: GoogleFonts.archivo(
                    color: Colors.white,
                    fontSize: 35
                ),
              ),
              Text(
                "Please enter valid information to access your account.",
                style: GoogleFonts.archivo(
                    color: Colors.grey,
                    fontSize: 15
                ),
              ),
              const SizedBox(height: 20,),

              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      // margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: HexColor("#262630"),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10))
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                } else if (value.length < 3) {
                                  return 'Name must be at least 3 characters long';
                                }
                                else if (value.contains(" ")){
                                  return 'Spaces are not allowed';
                                }
                                return null;
                                },
                                style: GoogleFonts.archivo(
                                    color: Colors.white
                                ),
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: GoogleFonts.archivo(),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                )
                            ),
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(height: 15),
                    // ------ email field
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      // margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: HexColor("#262630"),
                        // borderRadius: const BorderRadius.vertical(top: Radius.circular(10))
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                                validator: (value){
                                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                  RegExp regex = RegExp(pattern);
                                  return regex.hasMatch(value!) ? null : "Provide an valid email";
                                },
                                style: GoogleFonts.archivo(
                                    color: Colors.white
                                ),
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: GoogleFonts.archivo(),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    // const Divider(),
                    // -------- password field -----------//
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      // margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: HexColor("#262630"),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10))
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.lock_clock_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              obscureText: true,
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.archivo(
                                    color: Colors.white
                                ),
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.archivo(),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 15),
              //------------login and forgot button------------//
        
              GestureDetector(
                onTap: () async{
                  String name = nameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if(formKey.currentState!.validate()){
                    await _database.searchUsersByName(name).then((val){
                      snapshot = val;
                      if(snapshot!.docs.isEmpty){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Avatar(
                              email: email,
                              password: password,
                              name: name,
                            ))
                        );
                      }else{
                        showPopup(context, "Error", "This username is already in use, please use another username");
                      }
                    }).catchError((e){
                      print(e);
                      showPopup(context, "Error", e.toString());
                    });
                  }

                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    // margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: HexColor("#3d35e0"),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: HexColor("#5953ff"),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            "Create",
                            style: GoogleFonts.archivo(
                                color: Colors.white,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              //---------create account-------------//
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have a account?",
                    style: GoogleFonts.archivo(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Text(
                      "Login!",
                      style: GoogleFonts.archivo(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

void showPopup(BuildContext context, String heading, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: HexColor("#262630"),
        title: Text(
          heading,
          style: GoogleFonts.archivo(
              color: Colors.white,
              fontSize: 25
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.archivo(
              color: Colors.white,
              fontSize: 15
          )
          ,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // Handle the OK action
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
