import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods
{
  uploadUserInfo(Map<String, String> map){
    FirebaseFirestore.instance.collection("users").add(map);
  }

  searchUsersByName(String username) async{
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }

  searchUsersByEmail(String email) async{
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get();
  }
  
  createChatRoom(roomId, userMap) async{
    return await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).set(userMap).catchError((e){
      print(e.toString());
    });
  }

  getConversation(String roomId) async{
    return await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("chats").orderBy("time", descending: false).snapshots();
  }

  conversation(String roomId, Map<String, dynamic> userMap) async{
    return await FirebaseFirestore.instance.collection("chatrooms").doc(roomId).collection("chats").add(userMap);
  }

  getChatRooms(String username) async{
    return await FirebaseFirestore.instance.collection("chatrooms").where("users", arrayContains: username).snapshots();
  }

}