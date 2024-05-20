import 'package:chatting_app/Screens/searchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/ChatRoomModel.dart';
import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';
import 'chatRoomPage.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  final UserModel userModel;
  final User user;
  const Homepage({super.key, required this.userModel, required this.user});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Chat app",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async{
             await FirebaseAuth.instance.signOut();
             Navigator.popUntil(context, (route) => route.isFirst);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          }, icon:Icon(Icons.exit_to_app,color: Colors.white,),),
        ],
      ),
      body: Container(
        
        child: StreamBuilder(
          stream:FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}",isEqualTo: true).snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.active)
              {
                if(snapshot.hasData)
                  {
                    QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;


                    return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                        itemBuilder: (context,index){
                        ChatRoomModel? chatRoomModel= ChatRoomModel.fromMap(querySnapshot.docs[index].data() as Map<String, dynamic>);

                        Map<String ,dynamic> participants= chatRoomModel!.participants!;

                        List<String> participantsKey= participants.keys.toList();

                        participantsKey.remove(widget.userModel.uid);


                        return FutureBuilder(
                            future: FirebaseHelper.getUserModer(participantsKey[0]),
                            builder: (context,userData)
                        {
                          if(userData.connectionState == ConnectionState.done) {
                            if(userData.data != null) {
                              UserModel userModel = userData.data as UserModel;

                              return ListTile(
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CharRoomPage(tregetUser:userModel , chatRoom: chatRoomModel, userModel: widget.userModel, user: widget.user)));
                                },
                                title: Text(userModel.fullName.toString()),
                                subtitle: (chatRoomModel.lastMessage.toString())!= ""? Text(
                                    chatRoomModel.lastMessage.toString()): Text("say hi to your new friend"),
                                leading: CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              );
                            }
                            else{
                              return Container();
                            }
                          }
                          else{
                            return Container();
                          }
                        });


                        });

                  }
                else if(snapshot.hasData)
                  {
                    return Text(snapshot.error.toString());

                  }
                else
                  {
                    return Center(
                      child: Text("no chars"),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(userModel: widget.userModel, user: widget.user)));
        },
        child: Icon(Icons.search),
      )
      ,

    );
  }
}
