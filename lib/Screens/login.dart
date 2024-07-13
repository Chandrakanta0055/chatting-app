import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';


import 'package:glassmorphism/glassmorphism.dart';

import 'HomePage.dart';
import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailc= TextEditingController();
  TextEditingController passc= TextEditingController();

  void show_dialog(String title,String message,UserModel userModel,User user)
  {
    showDialog(context: context, builder: (BuildContext contex){

      return AlertDialog(
        title: Text(title,style: TextStyle(fontSize: 18,color: Colors.black),),
        content: Text(message),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex)=>Homepage(userModel: userModel, user: user)));

          }, child: Text("Ok"))
        ],
      );
    });
  }
  void show_dialog2(String title,String message)
  {
    showDialog(context: context, builder: (BuildContext contex){

      return AlertDialog(
        title: Text(title,style: TextStyle(fontSize: 18,color: Colors.black),),
        content: Text(message),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);

          }, child: Text("Ok"))
        ],
      );
    });
  }

  void checkUser() {
    String email= emailc.text.trim();
    String password= passc.text.trim();
    if(email== "" || password =="")
      {
        print("field all detail");
        String message="field all detail";

        show_dialog2("Error", message);
      }
    else{
      Login(email, password);

    }

  }

  void Login(String email, String password) async
  {
    UserCredential? userCredential;
    try{
      userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    }
    on FirebaseAuthException catch(e)
    {
      print("error: ${e.code.toString()}");

      show_dialog2("Error",e.code.toString());

    }
    if(userCredential!= null)
      {

        String? uid= userCredential.user!.uid;

        DocumentSnapshot? documentSnapshot = await FirebaseFirestore.instance!.collection("user").doc(uid).get();

        UserModel userModel= UserModel.fromMap(documentSnapshot.data() as Map<String , dynamic>);


        print("user login sucessfully");

        show_dialog("sucess","user login sucessfully",userModel,userCredential!.user!);


      }

  }

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.sizeOf(context).height;
    var cheight=MediaQuery.sizeOf(context).height*.7;
    var cwidth=MediaQuery.sizeOf(context).height*.5;
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
       child: Center(
         child: SingleChildScrollView(
           child: GlassmorphicContainer(
             height: cheight,
             width: cwidth,
             borderRadius: 20,
             blur: 3,
             border: 2,
             linearGradient: LinearGradient(
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
               colors:[
                 Color(0xFFffffff).withOpacity(0.05),
                 Color(0xFFffffff).withOpacity(0.05)
               ],
               stops: [
                 0.5,0.5
               ]
             ),
             borderGradient: LinearGradient(
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
               colors: [
                 Color(0xFFffffff).withOpacity(0.2),
                 Color(0xFFffffff).withOpacity(0.2),
               ],
           
             ),
             child:
            Container(
           
              margin: EdgeInsets.all(10),
              child: Column(
           
                children: [
                  SizedBox(height: cheight*0.03,),
                  Text("Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  SizedBox(height: cheight*0.12,),
                  TextField(
                    controller: emailc,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Email",
                      focusColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
           
                      )
                    ),
                  ),
                  SizedBox(height: cheight*0.08,),
                  TextField(
                    controller: passc,
                    cursorColor: Colors.white,

                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.white,
                        hintText: "password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
              
                        )
                    ),
                  ),
                  SizedBox(
                    height:cheight*0.15 ,
                  ),
                  ElevatedButton(onPressed: (){
                    checkUser();
           
                  },
                      style: ElevatedButton.styleFrom
                        (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        backgroundColor: Colors.white.withOpacity(0.05)
                      ),
                      child:Text(
                    "Login",style: TextStyle(color: Colors.white),
                  ) ),
                  SizedBox(height: cheight*0.03,),
                  Row(
                    children: [
                      Text("i don't have an Account..",style: TextStyle(color: Colors.white),),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignIn()));
                      }, child: Text("Sign up"))
                    ],
                  )
                  ,
                  SizedBox(height: cheight*0.02,),
           
                ],
              ),
            )
           
           ),
         ),
       )
      ),
    );
  }


  }

