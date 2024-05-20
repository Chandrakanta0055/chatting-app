import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/ChatRoomModel.dart';
import '../models/MessageModel.dart';
import '../models/UserModel.dart';

class CharRoomPage extends StatefulWidget {
  final UserModel tregetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User user;
  const CharRoomPage({super.key, required this.tregetUser, required this.chatRoom, required this.userModel, required this.user});

  @override
  State<CharRoomPage> createState() => _CharRoomPageState();
}

class _CharRoomPageState extends State<CharRoomPage> {
  TextEditingController messageC= TextEditingController();


  void sendMessage() async{
    String message= messageC.text.trim();
    messageC.clear();

    if(message!= "") {
      // send message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.userModel.uid,
          createdon: DateTime.now(),
          text: message,
          seen: false


      );


      //store in data base
      FirebaseFirestore.instance.
      collection("chatrooms").
      doc(widget.chatRoom.chatroomid).
      collection("messages").
      doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatRoom.lastMessage=message;

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoom.chatroomid).set(widget.chatRoom.toMap());

      log("meaaage send");

    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        backgroundColor: Colors.blueAccent,
        title: Text(widget.tregetUser.fullName.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(child: Icon(Icons.person,)),
        ),


      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("chatrooms").
                  doc(widget.chatRoom.chatroomid).collection("messages").orderBy("createdon",descending: true).snapshots(),
                  builder: (context,snapshot)
                  {
                    if(snapshot.connectionState == ConnectionState.active)
                      {
                        if(snapshot.hasData)
                          {
                            QuerySnapshot dataSnapshot= snapshot.data as QuerySnapshot;

                             return ListView.builder(
                               reverse: true,
                               itemCount: dataSnapshot.docs.length,
                                 itemBuilder: (context,index)
                             {
                               MessageModel currentModel= MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String,dynamic>);

                               return Row(
                                 mainAxisAlignment: (currentModel.sender == widget.userModel.uid)? MainAxisAlignment.end: MainAxisAlignment.start,
                                 children: [
                                   Container(

                                     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                     margin: EdgeInsets.symmetric(vertical: 10),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(5),
                                       color: (currentModel.sender  == widget.userModel.uid)? Colors.grey: Colors.blue
                                     ),
                                       child: Text(currentModel.text.toString(),style: TextStyle(color: Colors.white),)),
                                 ],
                               );

                             });

                          }
                        else if(snapshot.hasError)
                          {
                            return Center(
                              child: Text("error check your internet connection"),
                            );
                          }
                        else
                          {
                            return Center(
                              child: Text("send message to your friend"),
                            );
                          }
                      }
                    else
                      {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                  },
                ),

              )),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: Row(
                  children: [
                    Flexible(child: TextField(
                      controller: messageC,
                      maxLines: null,

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter the message"

                      ),
                    )),

                    IconButton(onPressed: (){
                      sendMessage();

                    }, icon: Icon(Icons.send,color: Colors.blueAccent,))

                  ],
                ),
              )
            ],
          ),

        ),
      ),

    );
  }
}
