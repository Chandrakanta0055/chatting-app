import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'Screens/HomePage.dart';
import 'Screens/login.dart';
import 'firebase_options.dart';
import 'models/FirebaseHelper.dart';
import 'models/UserModel.dart';

var uuid= Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? user= FirebaseAuth.instance.currentUser;

  if(user!= null)
  {
    // logged in
    // DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("user").doc(user.uid.toString()).get();
    // UserModel userModel = UserModel.fromMap(snapshot.data() as Map<String,dynamic>);
    //
    UserModel? userModel = await FirebaseHelper.getUserModer(user!.uid);

    if(userModel!= null) {
      runApp(MyappLogin(userModel: userModel!, user: user));
    }
    else{
      runApp(Myapp());
    }
  }
  else
  {
    // not logged in
    runApp(Myapp());

  }



}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


class MyappLogin extends StatelessWidget {
  final UserModel userModel;
  final User user;
  const MyappLogin({super.key, required this.userModel, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(userModel: userModel, user: user),
    );
  }
}

