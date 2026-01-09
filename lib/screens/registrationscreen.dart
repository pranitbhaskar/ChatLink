// import 'package:chat/methods.dart';
import 'package:chat/methods.dart';
import 'package:chat/screens/homescreen.dart';
import 'package:chat/screens/loginscreen.dart';
import 'package:chat/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget
{
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthMethods _authMethods=AuthMethods();
  bool isloading=false;
  final TextEditingController _name=TextEditingController();
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  @override
  Widget build(BuildContext conetxt)
  {
    return Scaffold(
      body:isloading?Center(child: Container(
        height: 20,
        width: 20,
        child:CircularProgressIndicator())): Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  // SizedBox(height:),
                  Container(alignment: Alignment.center,
                  child:Column(
                  children: [
                   UiHelper.customText(text:"Create your Account",size:25,textColor: Colors.white,fontweight: FontWeight.bold),
                  SizedBox(height:40),
                  UiHelper.field(HintText: "Name", height:50, width: 300,icondata: Icons.account_box,controller_: _name,),
                  SizedBox(height:20),
                  UiHelper.field(HintText: "email", height:50, width: 300,icondata: Icons.email,controller_: _email),
                  SizedBox(height:20),
                  UiHelper.field(HintText: "password (at least 6 digits)",height: 50,width: 300,icondata:Icons.lock,controller_: _password),
                  SizedBox(height:80)],
                  ))
                  ,
                  GestureDetector(
                      onTap:() async{
                        if(_name.text.isEmpty||_email.text.isEmpty||_password.text.isEmpty)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: UiHelper.customText(text:"Please fill all fields",textColor: Colors.white,size:14,),backgroundColor:Colors.redAccent)
                          );
                          return;
                        }
                      
                        setState(() {
                          isloading=true;
                        });
                        User? user=await _authMethods.createAccount(
                          _name.text.trim(),
                          _email.text.trim(),
                          _password.text.trim()
                        );
              
                         setState((){
                            isloading=false;
                        });  
                        
                        if(user!=null)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:UiHelper.customText(text:"Account Created Successfully ",size:14,),backgroundColor:Colors.greenAccent)
                          );
                         
                         
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>HomeScreen()));
                        }
              
                      
              
              
                      },
                      child:UiHelper.customButton(ButtonName: "Create Account", height:50, width:200)
                  ),
                  
                
                                 
                ],),
            ),
          
      );
    
  }
}