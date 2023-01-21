import 'package:flutter/material.dart';
class Message_Bubble extends StatelessWidget {
  String user;
  String message;
  String userImage;
  bool isMe;
  Key key;
  Message_Bubble(this.user,this.message,this.userImage,this.isMe,{required this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe?Colors.blue:Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: isMe?Radius.circular(14):Radius.circular(0),
                  bottomRight: isMe?Radius.circular(0):Radius.circular(14),
                )
              ),
              width: 140,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  Text(user),
                  Text(message)
                ],
              ),
            )
          ],
        ),
        isMe?Positioned(right: 140,top: 20,child: CircleAvatar(
          backgroundImage: NetworkImage(userImage),
        ),):Positioned(left: 140,top: 20,child: CircleAvatar(
          backgroundImage: NetworkImage(userImage),
        )),
      ],
    );
  }
}
