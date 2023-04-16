import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class newMessage extends StatefulWidget {
  @override
  State<newMessage> createState() => _newMessageState();
}

class _newMessageState extends State<newMessage> {
  final _controller = TextEditingController();
  String enteredMessage = "";
  void send() async{
    FocusScope.of(context).unfocus();
    var user =  FirebaseAuth.instance.currentUser;
    final data = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    debugPrint("Done");
    final snapShot = await FirebaseFirestore.instance.collection("chat").get();
    await FirebaseFirestore.instance.collection("chat").add({
      "text":enteredMessage.trim(),
      "created_at":Timestamp.now(),
      "username":data['username'],
      "userId":user.uid,
      "userImage":data['imageUrl'],
    });
    _controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: SingleChildScrollView(
                child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Send Message"),
            onChanged: (val) {
                setState(() {
                  enteredMessage = val;
                  print(enteredMessage);
                });
            },
          ),)),
          IconButton(color: Theme.of(context).primaryColor,onPressed: enteredMessage.trim().isEmpty?null:send, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
