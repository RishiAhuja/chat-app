import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/helper.dart';
import 'package:chat_app/views/chat_room.dart';
import 'package:chat_app/views/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  final AuthMethods _auth = AuthMethods();
  final DatabaseMethods _database = DatabaseMethods();
  final Helper _helper = Helper();

  /*When you create a new instance of a class,
  you are essentially creating a specific object that
  embodies the properties and behaviors defined in that class.
  This is done by calling the class's constructor.*/
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#131419"),
      appBar: AppBar(
        backgroundColor: HexColor("#131419"),
      ),
      body: SingleChildScrollView(
        child: isLoading ? Center(
          child: CircularProgressIndicator(
            color: HexColor("#5953ff"),
          ),
        ): Container(
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
                onTap: _signUp,
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
    );;
  }

  void _signUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      Map<String, String> userInfo = {
        "name" : name,
        "email" : email,
        "password" : password
      };
      _helper.setLogStatus(true);
      _helper.setEmail(email);
      _helper.setName(name);
      User? user = await _auth.signUpWithEmailAndPassword(email, password).then((val){
        _database.uploadUserInfo(userInfo);
        print("email: ${val?.email}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }


}
