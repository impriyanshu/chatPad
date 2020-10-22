import 'dart:math';
import 'package:flutter/material.dart';

class UsernameClass {

  UsernameClass({ @required this.id ,@required this.username , @required this.status , @required this.name , this.email , this.url , this.isstory , this.storytime , this.storytext ,this.storyurl});

  final String id;
  final String username;
  final String status;
  final String name;
  final String email;
  final String url;
  final String storyurl;
  final int storytime;
  final String storytext;
  final bool isstory;


  factory UsernameClass.fromMap ( Map<String , dynamic>info , String documentID) {
    if(info == null){
      return null ;
    }
    final String username = info['username'];
    final String status = info['status'];
    final String name = info['name'];
    final String email = info['email'];
    final String url = info['url'];
    final String storyurl = info['storyurl'];
    final int storytime = info['storytime'];
    final String storytext = info['storytext'];
    final bool isstory = info['isstory'];


    return UsernameClass(
      id: documentID,
      username: username,
      status: status,
      name: name,
      email: email,
      url: url,
        storyurl:storyurl,
        storytime : storytime  ,
        storytext: storytext,
        isstory : isstory,
    );
  }
  Map <String , dynamic> toMap() {
    return{
      'username' : username,
      'status' : status,
      'name' : name,
      'email' : email,
      'url' : url,
      'storyurl' : storyurl,
      'storytime' : storytime,
      'storytext' : storytext,
      'isstory' : isstory,
    };
  }

}