import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/ChatRoomModel.dart';
import '../models/UserModel.dart';
import 'chatRoomPage.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const SearchPage({super.key, required this.userModel, required this.user});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  TextEditingController SearchController= TextEditingController();

  Future<ChatRoomModel?>  getChatRoomModel(UserModel targetUser)async
  {

    ChatRoomModel? chatRoomModel;
    // check the participants is exit or not
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("chatrooms").
    where("participants.${widget.userModel.uid}",isEqualTo: true ).
    where("participants.${targetUser.uid}",isEqualTo: true).get();

    if(querySnapshot.docs.length > 0)
      {
        // featch the exit one
        log("charroom exit");
        var docData= querySnapshot.docs[0].data();
        ChatRoomModel  exitChatRoom = ChatRoomModel.fromMap(docData as Map<String,dynamic>);

        chatRoomModel= exitChatRoom;
      }
    else{
      // create a new one
      ChatRoomModel newCharRoom = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastMessage: "",
          participants: {
            widget.userModel.uid.toString() :true,
            targetUser.uid.toString() : true
          }

      );

      await FirebaseFirestore.instance.collection("chatrooms").
      doc(newCharRoom.chatroomid).set(newCharRoom.toMap());
      log("new charroom created");
      chatRoomModel= newCharRoom;


    }

    return chatRoomModel;



  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


      ),
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10
            ),
            child: Column
              (
              children: [
                TextField(
                  controller: SearchController,
                  decoration: InputDecoration(
                    labelText: "Enter email address"
                  ),
                ),
                SizedBox(height: 20,),
                CupertinoButton(child: Text("Search",style: TextStyle(fontWeight: FontWeight.bold),), onPressed: (){
                  setState(() {

                  });
                
                  
                }),
                SizedBox(height: 20,),
                
                StreamBuilder(stream: FirebaseFirestore.instance.
                collection("user").
                where("email",isEqualTo: SearchController.text).where("email",isNotEqualTo: widget.userModel!.email!.toString()).
                snapshots(),
                    builder:(context,snapshot){
                  if(snapshot.connectionState == ConnectionState.active)
                    {
                      if(snapshot.hasData)
                        {
                          QuerySnapshot  dataSnapshot= snapshot.data as QuerySnapshot;

                          if(dataSnapshot.docs.length > 0) {
                            Map<String, dynamic> usermap = dataSnapshot.docs[0]
                                .data() as Map<String, dynamic>;

                            UserModel searchUser = UserModel.fromMap(usermap);
                            return ListTile(
                              onTap: () async
                              {
                               ChatRoomModel? chatroomModel= await  getChatRoomModel(searchUser);

                               if(chatroomModel!= null) {
                                 Navigator.pop(context);
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>CharRoomPage(
                                   tregetUser:searchUser ,
                                   userModel: widget.userModel,
                                   user: widget.user,
                                   chatRoom: chatroomModel,
                                 )));
                               }
                              },
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(searchUser.fullName!.toString()),
                              subtitle: Text(searchUser.email!.toString()),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            );
                          }
                          else{
                            return Text("no result");
                          }

                        }
                      else if (snapshot.hasError)
                        {
                          return Text("Some error occure");

                        }
                      else{
                        return Text("No Result");

                      }


                    }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                    })
              ],
            ),
          )),
    );
  }
}
