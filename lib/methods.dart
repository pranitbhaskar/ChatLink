import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods
{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  Future<User?>createAccount(
    String name, String email, String password,
  ) async  {
    print("CREATE ACCOUNT CALLED");

   try{
     UserCredential credential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
     User? user=credential.user;
     if(user!=null)
     {
      print("Account Created SuccessFully");
      user.updateProfile(displayName: name);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set({
        "uid":user.uid,
        "name":name,
        "email":email,
        "status":"UnAvailable",
        "lastSeen":FieldValue.serverTimestamp()
      });
     }
     return user;
   }on FirebaseAuthException catch(e){
    print("Firebase auth Error:${e.message}");
    return null;

   }catch(e){
    print("Unknown Error: $e");
    return null;
   }
  }
  Future<User?> Login(String email,String password)async 
  {
    try{
         UserCredential credential=await _auth.signInWithEmailAndPassword(email: email, password: password);
         User? user=credential.user;

         if(user!=null)
         {
          print("Login Successful");
         }
         return user;
    }on FirebaseAuthException catch(e){
      print("Firebase auth error: ${e.message}");
      return null;
    }catch(e)
    {
      print("Uncknown error:$e");
      return null;
    }
  }
  Future<void> LogOut() async
  {
    await _auth.signOut();
    print("Logged Out");
  }
  User? getCurrentUser()
  {
    return _auth.currentUser;
  }
}