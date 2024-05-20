
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../models/UserModel.dart';
import 'Profile.dart';
import 'login.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  TextEditingController emailc= TextEditingController();
  TextEditingController passc= TextEditingController();
  TextEditingController cpassc= TextEditingController();

  void show_dialog(String title,String message)
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

  void checkValue() {
    String email = emailc.text.trim();
    String password = passc.text.trim();
    String ConfromPassword = cpassc.text.trim();
    if (email == "" || password == "" || ConfromPassword == "") {
      print("the field is empty");
      show_dialog("Error", "the field is empty");
    } else if (password != ConfromPassword) {
      print("password not match");
      show_dialog("Error", "password is not match");
    } else {
      SignUp(email, password);
    }
  }

  void SignUp(String email,String password) async
  {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
log(userCredential.user!.uid);

    }
    on FirebaseAuthException catch(e)
    {
      print("error: "+e.code.toString());
      show_dialog("Error", e.code.toString());
      
    }
    if(userCredential!= null)
    {

      String  uid= userCredential.user!.uid;
      UserModel newUser= new UserModel(
          uid: uid,
          email: email,
          fullName: "",
          profilePic: ""
      );
      await  FirebaseFirestore.instance.collection("user").doc(uid).set(newUser.toMap()).then((value) {
        show_dialog("", "new user created");
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> ProfilePage(userModel: newUser,user: userCredential!.user!,) ));

      });

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
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: cheight*0.03,),
                          Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          SizedBox(height: cheight*0.05,),
                          TextField(
                            controller: emailc,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                hintText: "Email",
                    
                                focusColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.white,),
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
                          SizedBox(height: cheight*0.08,),
                          TextField(
                            controller: cpassc,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                hintText: "comform password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                            ),
                          ),
                          SizedBox(
                            height:cheight*0.12 ,
                          ),
                    
                          ElevatedButton(onPressed: (){
                            checkValue();
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
                          },
                              style: ElevatedButton.styleFrom
                                (
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  backgroundColor: Colors.white.withOpacity(0.05)
                              ),
                              child:Text(
                                "Sign Up",style: TextStyle(color: Colors.white),
                              ) ),
                          SizedBox(height: cheight*0.02,),
                          Row(
                            children: [
                              Text("i have an Account.",style: TextStyle(color: Colors.white),),
                              TextButton(onPressed: (){
                    
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                              }, child: Text("Login"))
                            ],
                          ),
                          SizedBox(height: cheight*0.01,)
                        ],
                      ),
                    ),
                  )

              ),
            ),
          )
      ),
    );
  }
}
