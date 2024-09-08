import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/constants.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotP extends StatefulWidget {
  final String? email;

  ForgotP({this.email});

  @override
  State<ForgotP> createState() => _ForgotPState();
}

class _ForgotPState extends State<ForgotP> {

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _auth = AuthMethods();
  @override

  void initState(){
    super.initState();

    if(widget.email != null){
      emailController.text = widget.email!;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Constants.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Text(
                "Forgot Password?",
                style: GoogleFonts.archivo(
                    color: Colors.white,
                    fontSize: 35
                ),
              ),
              Text(
                "Please enter your valid email to receive an email to reset your password.",
                style: GoogleFonts.archivo(
                    color: Colors.grey,
                    fontSize: 15
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: HexColor("#262630"),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            validator: (value){
                              String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                              RegExp regex = RegExp(pattern);
                              return regex.hasMatch(value!) ? null : "Provide an valid email";
                            },
                            style: GoogleFonts.archivo(color: Colors.white),
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: GoogleFonts.archivo(),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            )),
                      ),
                    ],
                  ),


                ),
              ),

              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () async{

                  final snackBar = SnackBar(
                    content: Text(
                        "Password reset email has been sent to your email",
                      style: GoogleFonts.archivo(
                        color: Colors.white
                      ),
                    ),
                  );
                  if(_formKey.currentState!.validate()){
                    await _auth.sendResetPasswordEmail(emailController.text.trim()).then((val){

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }).catchError((e){
                      print(e);
                      showPopup(context, "Error", e.toString());
                    });
                  }
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: HexColor("#5953ff"),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Send Email",
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
    );
  }
}
