import 'package:chat/screens/chatroom.dart';
import 'package:chat/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/screens/loginscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  Map<String, dynamic>? userMap;
  bool isloading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  @override
  void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  setStatus("online");

  _search.addListener(() {
    setState(() {});
  });
}

  void setStatus(String status ) async
  {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          "status": status
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)
  {
       if(state == AppLifecycleState.resumed)
       {
        setStatus("online");
       }else{ 
           setStatus("offline");
       }
  }
  String chatroomID(String uid1,String uid2)
  {
      if (uid1.compareTo(uid2) > 0) {
    return uid1 + uid2;
  } else {
    return uid2 + uid1;
  }
  } 
  void onSearch() async {

    setState(() {
      isloading=true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value){
          if (value.docs.isNotEmpty) {
            userMap = value.docs[0].data();
              } else {
               userMap = null;
               ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text("User not found")),
  );
}
 setState(() {
      isloading=false;
    });
        })  ;
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(icon:Icon(Icons.logout),onPressed:()async{
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Loginscreen()), (route)=>false);
          },)
        ],
        ),
      body: isloading
          ? Center(
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
            padding: const EdgeInsets.only(top:50),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UiHelper.searchfield(
                    hinttext: " Search users",
                    height: 50,
                    width: 350,
                    // icondata: Icons.search,
                    searchcontroller_: _search,
                  ),
                  Expanded(child: _search.text.isEmpty
                  ?Center(
                    child:Text(
                      "Start typing an email...",
                      style:TextStyle(color:Colors.grey),
                    ),
                  )
                  :StreamBuilder<QuerySnapshot>(stream: _firestore
                  .collection('users')
                  .where(
                    'email',
                    isGreaterThanOrEqualTo: _search.text.trim().toLowerCase(),
                  ).where(
                    'email',
                    isLessThan: _search.text.trim().toLowerCase()+'z',)
                    .snapshots(), builder:(context, snapshot)
                    {
                      if(!snapshot.hasData)
                      {
                        return Center(child:CircularProgressIndicator());
                      }
                      final users=snapshot.data!.docs;
                      if(users.isEmpty)
                      {
                        return Center(child:UiHelper.customText(text: "No user Found", size: 15,textColor: Colors.red));
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context,index)
                        {
                          final user=users[index].data() as Map<String,dynamic>;
                          return ListTile(
                            leading:Icon(Icons.account_circle),
                            trailing:UiHelper.customText(
                              text:user['status'],
                              size:12,
                              textColor:user['status']=="online"? Colors.green:Colors.red),
 
                            title:Text(user['name']),
                            subtitle: UiHelper.customText(text: user['email'],size: 12,textColor: Colors.blue),
                            onTap: ()
                            {
                              final roomID=chatroomID(_auth.currentUser!.uid, user['uid']);
                              Navigator.push(context,MaterialPageRoute(builder: (_)=>ChatRoom(ChatRoomId: roomID, userMap: user)));
                            },
                          );
                        });
                    })
                  ),
                      
                  
                ],
              ),
          ),
    );
  }
}
