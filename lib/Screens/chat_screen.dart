import 'package:chat/Widgets.auth/chats/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

import '../Widgets.auth/chats/messages.dart';
class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat",style: TextStyle(color: Colors.white),),
        actions: [
          DropdownButton(icon: const Icon(Icons.more_vert,color: Colors.white,),items: [
            DropdownMenuItem(child: Row(
              children: [
                Icon(Icons.exit_to_app,color: Colors.black,),
                SizedBox(width: 10,),
                Text("Logout")
              ],
            ),value: 'logout',)
          ], onChanged: (item){
            if(item=='logout'){
             FirebaseAuth.instance.signOut();
            }
          },
          underline: Container(),)
        ],
      ),
      body: Container(
          child: Column(
            children: [
              Expanded(child: Messages()),
              Expanded(flex: 0,child: newMessage()),
            ],
          ),
      ),
    );
  }
}
