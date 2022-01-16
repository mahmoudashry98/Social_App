import 'package:flutter/material.dart';

class CommentModel
{
  String name;
  String image;
  String uId;
  String dateTime;
  String comment;
  String commentImage;



  CommentModel(
      {
        @required this.name,
        @required this.image,
        @required this.uId,
        @required this.dateTime,
        @required this.comment,
        @required this.commentImage,
      });

  CommentModel.fromJson(Map<String, dynamic>json)
  {
    name = json['name'];
    image = json['image'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    commentImage = json['commentImage'];
  }

  Map<String, dynamic> toMap()
  {
    return
      {
        'name': name,
        'uId': uId,
        'image': image,
        'dateTime': dateTime,
        'comment': comment,
        'commentImage': commentImage,

      };
  }

}