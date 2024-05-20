import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserModel.dart';

class FirebaseHelper{

   static Future<UserModel?> getUserModer(String id) async
  {
    UserModel? userModel;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("user").doc(id).get();
    if(snapshot.data() != null)
      {
        userModel= UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }

    return userModel;


  }


}