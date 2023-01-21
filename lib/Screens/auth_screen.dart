import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Widgets.auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isloading = false;
  void _submitAuthForm(String email,String password,String username,bool islogin,BuildContext ctx,[File? img]) async{
    try {
      setState(() {
        _isloading=true;
      });
      if(islogin){
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        // print(user.user!.uid);
        // FirebaseFirestore.instance.collection("Chat").doc(user.user!.uid);
      }else{
        var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        print(user.user!.uid);
        final ref = FirebaseStorage.instance.ref().child("user_image").child("${user.user!.uid}.jpg");
        await ref.putFile(img!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection("users").doc(user.user!.uid).set(
            {
              "username":username,
              "password":password,
              "imageUrl":url,
            });
      }
    } on FirebaseAuthException catch (e) {
       String errorMsg="";
      if (e.code == 'weak-password') {
        errorMsg="The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMsg = "The account already exists for that email.";
      }else if (e.code == 'user-not-found') {
        errorMsg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Wrong password provided for that user.";
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(errorMsg),backgroundColor: Colors.red,));
       setState(() {
         _isloading=false;
       });
    } catch (e) {
      print(e);
      setState(() {
        _isloading=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm,_isloading),
    );
  }
}
