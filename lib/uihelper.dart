import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UiHelper
{
  static searchfield({
    required String hinttext,
    required double height,
    required double width,
    required TextEditingController searchcontroller_
  })
  {
   return Container(
    height:height,
    width:width,
    child:TextField(
      controller: searchcontroller_,
      decoration:InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey),
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      )
    )
   );
  }
  static field({
    required String HintText,
    required double height,
    required double width,
    required IconData icondata,
    required TextEditingController controller_,
    Color?color,
    })
    {
      return Container( 
        height:height,
        width:width,

        child:TextField(
          controller: controller_,
          decoration:InputDecoration(
            prefixIcon: Icon(icondata),
            hintText:HintText,
            hintStyle: TextStyle(color:Colors.grey),
            border:OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
              )
            )
          )
              
      );
    }
    static customButton({
      required String ButtonName,
      required double height,
      required double width,
      Color?ButtonColor,
    })
    {
      return Container(
        height:height,
        width:width,
        
        decoration:BoxDecoration(
           color:ButtonColor??Colors.blue,
           borderRadius: BorderRadius.circular(10)
        ) ,
        alignment: Alignment.center,
        child:Text(ButtonName,
        style:TextStyle(
          fontSize: 14,
         fontWeight:FontWeight.bold
        ))
      );
    }
    static customText({
      required String text,
      required double size,
      Color?textColor,
      FontWeight?fontweight,

    })
    {
      return Text(
        text,
        style:TextStyle(
          fontSize:size,
          color:textColor??Colors.white,
          fontWeight:fontweight
        )
      );
    }
    static messages({
      required Size size,
      required Map<String,dynamic> map,
    })
    {
          return map['type']=='text'?Container(
            width:size.width,
            alignment:map['sendBy']==FirebaseAuth.instance.currentUser!.uid
             ? Alignment.centerRight
             :Alignment.centerLeft,
             child:map['sendBy']==FirebaseAuth.instance.currentUser!.uid ? Container(
              padding:EdgeInsets.symmetric(vertical:10,horizontal: 14),
              margin: EdgeInsets.symmetric(vertical:5,horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:Colors.purple
              ),
              child:Text(map['message'],
              style: TextStyle(
                color: Colors.white
              ),)

             ):Container(
              padding:EdgeInsets.symmetric(vertical:10,horizontal: 14),
              margin: EdgeInsets.symmetric(vertical:5,horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:Colors.grey
              ),
              child:Text(map['message'],
              style: TextStyle(
                color: Colors.white
              ),)
          )):Container(
            height:size.height/2.5,
            width:size.width,
            alignment:map['sendBy']==FirebaseAuth.instance.currentUser!.uid
            ?Alignment.centerRight
            :Alignment.centerLeft,
            child:Container(
              height:size.height/2.5,
              width:size.width/2,
              alignment: Alignment.center,
              child:map['message']==""
              ?CircularProgressIndicator()
              :Image.network(map['message'])
            )
          );
    }
}