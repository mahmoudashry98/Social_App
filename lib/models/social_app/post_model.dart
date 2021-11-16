import 'package:flutter/material.dart';

class PostModel
{
  String name;
  String image;
  String uId;
  String dateTime;
  String text;
  String postImage;



  PostModel(
      {
        @required this.name,
        @required this.image,
        @required this.uId,
        @required this.dateTime,
        @required this.text,
        @required this.postImage,
      });

  PostModel.fromJson(Map<String, dynamic>json)
  {
    name = json['name'];
    image = json['image'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap()
  {
    return
      {
        'name': name,
        'uId': uId,
        'image': image,
        'dateTime': dateTime,
        'text': text,
        'postImage': postImage,

      };
  }

}