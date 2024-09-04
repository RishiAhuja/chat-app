import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn({required this.toggle});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthMethods _auth = AuthMethods();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Welcome Back!",
                  style: GoogleFonts.archivo(
                    color: Colors.white,
                    fontSize: 35
                  ),
                ),
              ),
            Text(
              "Enter your email address and password to get access to your account.",
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
                              Icons.email_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextFormField(
                                  style: GoogleFonts.archivo(
                                      color: Colors.white
                                  ),
                                  validator: (value){
                                    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                    RegExp regex = RegExp(pattern);
                                    return regex.hasMatch(value!) ? null : "Provide an valid email";
                                  },
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
                                  style: GoogleFonts.archivo(
                                      color: Colors.white
                                  ),
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    return null;
                                  },
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
                  )

              ),
        
              const SizedBox(height: 15),
              //------------login and forgot button------------//
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Forgot password?",
                    style: GoogleFonts.archivo(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                  GestureDetector(
                    onTap: logIn,
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
                                "Login",
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
                ],
              ),
              const SizedBox(height: 30,),
              //---------create account-------------//
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have a account?",
                    style: GoogleFonts.archivo(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      "Create one!",
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
              // const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void logIn() async{
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      User? user = await _auth.signInWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim()).then((user){
        print("email:${user?.email}");
        print("loggedin successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }

  }
}
