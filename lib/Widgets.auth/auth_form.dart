import 'dart:io';

import 'package:chat/userImagePicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void  Function(String email, String password, String username,
      bool islogin, BuildContext ctx,[File? img]) auth;
  final bool isloading;

  AuthForm(this.auth, this.isloading, {Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoggedIn = true;

  String _email = "";

  String _password = "";

  String _username = "";

  File? userImage;

  void _pickedImage(File? recImage){
     userImage = recImage;
  }


  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(userImage==null && !_isLoggedIn){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pick an image"),backgroundColor: Colors.red,));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      !_isLoggedIn?widget.auth(_email.trim(), _password.trim(), _username.trim(), _isLoggedIn, context,userImage!):
      widget.auth(_email.trim(), _password.trim(), _username.trim(), _isLoggedIn, context);
      print(_email);
      print(_password);
      print(_username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLoggedIn)UserImagePicker(_pickedImage),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains("@")) {
                      return "The email address is not valid";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (val) => _email = val!,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                if (!_isLoggedIn)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return "enter a valid username";
                      }
                      return null;
                    },
                    onSaved: (val) => _username = val!,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 7) {
                      return "enter a valid username with at least 7 characters";
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val!,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 12,),
                if(widget.isloading)
                  const CircularProgressIndicator(),
                if(!widget.isloading)
                ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isLoggedIn ? "Login" : "Sign Up")),
                if(!widget.isloading)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoggedIn = !_isLoggedIn;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(_isLoggedIn
                      ? "Create a new account"
                      : "I already have an account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
