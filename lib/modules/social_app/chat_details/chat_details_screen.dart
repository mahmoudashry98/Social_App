import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/models/social_app/social_user_model.dart';
import 'package:scoial_app/shared/style/color/color.dart';

// ignore: must_be_immutable
class ChatDetailsScreen extends StatelessWidget {

  var messageController = TextEditingController();
  SocialUserModel userModel;

  ChatDetailsScreen({this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: Row(
              children:
              [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                      userModel.image
                  ),
                ),
                SizedBox(
                  width:
                  15.0,
                ),
                Text(userModel.name),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children:
              [
                buildMessage(),
                buildMyMessage(),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 1.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children:
                    [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: 10.0),
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type your message here ...',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        color: defaultColor,
                        child: MaterialButton(
                          onPressed: ()
                          {
                            SocialCubit.get(context).sendMessage(
                              receiverId: userModel.uId,
                              dateTime: DateTime.now().toString(),
                              text: messageController.text,
                            );
                          },
                          minWidth: 1.0,
                          child: Icon(
                            Icons.send,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMessage() => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          )
      ),
      child: Text(
          'Hello'
      ),
    ),
  );

  Widget buildMyMessage() => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
          color: defaultColor.withOpacity(0.2),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          )
      ),
      child: Text(
          'Hello'
      ),
    ),
  );
}
