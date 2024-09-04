import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods
{
  uploadUserInfo(Map<String, String> map){
    FirebaseFirestore.instance.collection("users").add(map);
  }

  searchUsersByName(String username) async{
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }
}