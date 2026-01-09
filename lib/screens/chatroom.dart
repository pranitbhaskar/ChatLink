import 'dart:io';

import 'package:chat/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget
{
  // final size
  final Map<String,dynamic> userMap;
  final String ChatRoomId;

  ChatRoom({
    required this.ChatRoomId,
    required this.userMap
    });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
   final FirebaseFirestore _firestore=FirebaseFirestore.instance;

   final FirebaseAuth _auth=FirebaseAuth.instance;

  final TextEditingController _message=TextEditingController();

   File? imageFile;

  Future getImage() async
  {
         ImagePicker _picker = ImagePicker();
         final XFile? pickedFile=
        await _picker.pickImage(source: ImageSource.gallery);
        if(pickedFile==null)
        {
          debugPrint("❌ ❌ ❌ Image picking cancelled");
          return;
        }
        setState(() {
          imageFile=File(pickedFile.path);
        });
        debugPrint("Image Selected:${pickedFile.path}");
        await uploadImage();
  }

  Future uploadImage() async
  { 
    if(imageFile==null)
    {
      debugPrint(" ❌ ❌ ❌ imagefile is null");
      return;
    }
    final String fileName=Uuid().v1();
    try{
      await _firestore
      .collection('chatroom')
      .doc(widget.ChatRoomId)
      .collection('chats')
      .doc(fileName)
      .set({
        "sendBy": _auth.currentUser!.uid,
        "message":"",
        "type":"img",
        "time":FieldValue.serverTimestamp()
      });
      final ref=FirebaseStorage.instance
          .ref()
          .child("chat_images")
          .child("$fileName.jpg");
      
      debugPrint("⬆️⬆️⬆️⬆️⬆️ Uploading image...");
      await ref.putFile(imageFile!);
      final imageUrl=await ref.getDownloadURL();
      debugPrint("✅✅✅✅ Image uploaded: $imageUrl");
      await _firestore
           .collection('chatroom')
           .doc(widget.ChatRoomId)
           .collection('chats')
           .doc(fileName)
           .update({
            "message":imageUrl,
           });
    }catch(e)
    {
       debugPrint("🔥🔥🔥 Upload failed: $e");
       await _firestore
           .collection('chatroom')
           .doc(widget.ChatRoomId)
           .collection('chats')
           .doc(fileName)
           .delete();
    }

    
    /// The line `String imageUrl=await uploadTask.ref.getDownloadURL();` is attempting to retrieve the
    /// download URL of the uploaded image file.
    // String imageUrl=await uploadTask.ref.getDownloadURL();
  }

  void onSendMessage() async {
    if(_message.text.isEmpty)
    {
      return;
    }
    Map<String, dynamic> messages={
      'sendBy':FirebaseAuth.instance.currentUser!.uid,
      'message':_message.text,
      'type':"text",
      'time':FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance
    .collection('chatroom')
    .doc(widget.ChatRoomId)
    .collection('chats')
    .add(messages);
    _message.clear();
  }

  @override
  Widget build(BuildContext context)
  {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("users").doc(widget.userMap['uid']).snapshots(), 
          builder:(context,snapshot)
          {
            if(snapshot.data!=null)
            {
              return Container(
                alignment: Alignment.centerLeft,
                child:Column(children: [
                  
                  Text(widget.userMap['name']),
                  UiHelper.customText(text:widget.userMap['status'],size:12,textColor: Colors.grey),
                ],)
              );
            }
            return SizedBox();
          }),
      ),
      body:SingleChildScrollView(
        child: Column(
            children: [
              Container(
                height:size.height/1.35,
                width:size.width,
                child:StreamBuilder<QuerySnapshot>(
                  builder:(context,
                  snapshot){
                   if(!snapshot.hasData)
                   {
                        return Center(child: CircularProgressIndicator(),);
        
                   }
                        return ListView.builder(
                          itemCount:snapshot.data?.docs.length,
                          itemBuilder: (context,index){
                          final map = snapshot.data!.docs[index].data() as Map<String, dynamic>;   
                          return UiHelper.messages(
                            size:size,
                            map: map);
                          },
                          );
                    
                      return Center(child: CircularProgressIndicator(),);
                    
                  }, stream: FirebaseFirestore.instance.collection('chatroom')
                     .doc(widget.ChatRoomId)
                     .collection('chats')
                     .orderBy('time',descending: false)
                     .snapshots(),
                ),
              ),
              Container(
                height:size.height/10,
                width:size.width,
                alignment:Alignment.center,
                child:Container(
                  height: size.height/12,
                  width: size.width/1.1,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height/17,
                        width: size.width/1.1,
                          child:TextField(
                           controller: _message,
                            decoration: InputDecoration(
                            prefixIcon:IconButton(
                              onPressed:(){
                                getImage();
                              },
                              icon:Icon(Icons.photo)
                            ),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  onSendMessage();
                                },
                                icon:Icon(Icons.send)
                              ),
                              hintText: "send message",
                             border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                             ) 
                            ),
                            
                            
                          )
                      )
                    ],
                  )
                )
              )
            ],
           ),
      )
         
         
           
        );
      
    
  }
}