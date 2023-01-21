import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class UserImagePicker extends StatefulWidget{
  final void Function(File recImage) pickedImage;

   UserImagePicker(this.pickedImage);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? receivedImage;

  void fetchImage(src) async{
    XFile? image = await _picker.pickImage(source: src,maxWidth: 150,imageQuality: 50);
    if(image==null){
      print("No image selected");
      return;
    }
    setState(() {
      receivedImage=File(image.path);
      widget.pickedImage(receivedImage!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        CircleAvatar(radius: 40,backgroundColor: Colors.grey,backgroundImage: receivedImage!=null?FileImage(receivedImage!):null,),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: Wrap(
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.center,
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                child: TextButton.icon(icon: const Icon(Icons.camera),onPressed: (){
                  fetchImage(ImageSource.camera);
                }, label: const Text("From the camera")),
              ),
              Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                child: TextButton.icon(icon: const Icon(Icons.image),onPressed: (){
                  fetchImage(ImageSource.gallery);
                }, label: const Text("From the gallery")),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
