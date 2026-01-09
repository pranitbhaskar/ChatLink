// import 'package:chat/methods.dart';
import 'package:chat/methods.dart';
import 'package:chat/screens/homescreen.dart';
import 'package:chat/screens/registrationscreen.dart';
import 'package:chat/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Loginscreen extends StatefulWidget
{
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  final AuthMethods _authMethods=AuthMethods();
  bool isloading=false;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:isloading?Center(child: Container(
        height:20,
        width:20,
        child:CircularProgressIndicator()
      ),):SingleChildScrollView(
          child:Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:50),
                child: Container(
                  alignment:Alignment.centerLeft,
                  child:IconButton(onPressed:(){
                    
                  },icon: Icon(Icons.arrow_back_ios))
                ),
              ),
              SizedBox(height: 20),
              Container(
                child:UiHelper.customText(
                  text: "Welcome !",
                   size: 30,
                   fontweight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Container(
                child:UiHelper.customText(
                  text: "Sign in to Continue",
                   size:25,
                   textColor: Colors.grey,
                   fontweight: FontWeight.bold)
              ),
              SizedBox(height:80),
              // UiHelper.field(HintText: "Name", height:50, width: 300,icondata: Icons.account_box),
              // SizedBox(height:20),
              UiHelper.field(HintText: "email", height:50, width: 300,icondata: Icons.account_box,controller_: _email),
              SizedBox(height:20),
              UiHelper.field(HintText: "password",height: 50,width: 300,icondata:Icons.lock,controller_: _password),
              SizedBox(height:80),
              GestureDetector(
                  onTap:()async {
                    if(_email.text.isEmpty || _password.text.isEmpty)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields"),backgroundColor:Colors.redAccent),
                      );
                      return;
                    }
                      setState(() {
                        isloading=true;
                      });
                      User? user= await _authMethods.Login(
                        _email.text.trim(),
                        _password.text.trim()
                      );
                      setState(()
                      {
                        isloading=false;
                      });   
                      if(user!=null)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:UiHelper.customText(text: "Login Successful", size:14,textColor: Colors.white),
                          backgroundColor: Colors.greenAccent,
                        ));
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>HomeScreen()));
                       }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:UiHelper.customText(text: "Invalid email or password", size:14),backgroundColor: Colors.redAccent,)
                        );
                       }
                     
                  },
                  child:UiHelper.customButton(ButtonName: "Login", height:50, width:200)
              ),
              SizedBox(height:30),
              Container(
                 child:Column(
                  children:[
                    UiHelper.customText(text: "Don't have account?", size:15,textColor: Colors.grey),
                    SizedBox(height:5),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                      },
                      child:UiHelper.customText(text: "Register Now", size: 15,textColor: Colors.blue)
                    )                    
                  ]
                 )
              )

              
            ],)
      )
    );
  }
}