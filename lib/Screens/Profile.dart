import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:image_picker/image_picker.dart';

import '../models/UserModel.dart';
import 'HomePage.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? userModel;
  final User? user;
  const ProfilePage({super.key, required this.userModel, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void checkValue(){
    String fullName= fullNameController.text.trim();
    if (fullName == "")
      {
        log ("pleased field the detail");
      }
    else
      {
        uploadData(fullName);

      }
  }
  void uploadData(String fullname) async
  {
    log("uploaded start");
    try {
      // UploadTask uploadTask = FirebaseStorage.instance.ref("ProfilePic").child(
      //     widget.userModel!.uid.toString()).putFile(imageFile!);
      //
      // TaskSnapshot snapshot = await uploadTask;
      //
      // String? url = await snapshot.ref.getDownloadURL();


      widget.userModel!.fullName = fullname;
      widget.userModel!.profilePic = "null";

      await FirebaseFirestore.instance.collection("user").doc(widget.
      user!.uid).set(widget.userModel!.toMap());
      log("data uploaded");
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homepage(userModel: widget.userModel!, user:  widget.user!,)));

    }
    on FirebaseStorage catch (e)
    {
      log(e.toString());

    }
    log("uploaded end");






  }


  void selectImage(ImageSource imageSource) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      // if (kIsWeb) {
      //   setState(() {
      //     imageFile = File(pickedFile.path);
      //     log(imageFile.toString());
      //     log("file picked");
      //
      //   });
      // } else {
      //   // cropImage(pickedFile);
      //   // imageFile= File(pickedFile.path);
      // }
      setState(() {
        imageFile=File(pickedFile.path);
      });
    }
    else
      {
        Center(child:  CircularProgressIndicator(),);
      }
  }
  //
  // void cropImage(XFile imageXFile) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: imageXFile.path,
  //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //     compressQuality: 20
  //
  //   );
  //   if (croppedImage != null) {
  //     setState(() {
  //       log(croppedImage.toString());
  //       imageFile = File(croppedImage.path);
  //     });
  //   }
  //   else
  //     {
  //       log(croppedImage.toString());
  //     }
  // }

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.browse_gallery_sharp),
                title: const Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Select from Camera"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var cheight = MediaQuery.sizeOf(context).height * .7;
    var cwidth = MediaQuery.sizeOf(context).width * .5;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: GlassmorphicContainer(
                height: cheight,
                width: cwidth,
                borderRadius: 20,
                blur: 3,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFFFFF).withOpacity(0.05),
                    const Color(0xFFFFFFFF).withOpacity(0.05)
                  ],
                  stops: const [0.5, 0.5],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFFFFF).withOpacity(0.2),
                    const Color(0xFFFFFFFF).withOpacity(0.2),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  CupertinoButton(
                    child: CircleAvatar(
                      // backgroundImage: imageFile != null ? FileImage(imageFile!) : null,

                      radius: 50,
                      child: imageFile == null
                          ? const Icon(
                        Icons.person,
                        size: 60,
                      )
                          : null,
                    ),
                    onPressed: showPhotoOption,
                    // onPressed: (){
                    //
                    // },
                  ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: fullNameController,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(

                          hintStyle: const TextStyle(color: Colors.white),
                          focusColor: Colors.white,
                          hintText: "User Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (imageFile!=null  && fullNameController!=null)
                          {
                            log("sucessfully pic the image");
                          }
                        else
                          {
                            log("some erroe occure");
                          }
                        checkValue();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
