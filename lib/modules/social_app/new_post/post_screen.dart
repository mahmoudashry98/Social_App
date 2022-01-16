import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/style/color/color.dart';

// ignore: must_be_immutable
class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState &&
            SocialCubit.get(context).postImage != null) {
          textController.clear();
          Navigator.pop(context);
        }else if (state is SocialCreatePostSuccessState ){
          textController.clear();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                function: () {
                  var now = DateTime.now();
                  String formattedDate =
                      DateFormat.MMMEd().add_jm().format(now);
                  if (SocialCubit.get(context).postImage == null) {
                    SocialCubit.get(context).createPost(
                      text: textController.text,
                      dateTime: formattedDate.toString(),
                    );
                  } else {
                    SocialCubit.get(context).uploadPostImage(
                      text: textController.text,
                      dateTime: now.toString(),
                    );
                  }
                },
                text: 'Post',
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(height: 5.0),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage('${model.image}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'What is on your mind,',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20.0),
                if (SocialCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 160.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image:
                                FileImage(SocialCubit.get(context).postImage),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20.0,
                          child: Icon(
                            Icons.close,
                            size: 16.0,
                            color: defaultColor,
                          ),
                        ),
                        onPressed: () {
                          SocialCubit.get(context).removePostImage();
                        },
                      ),
                    ],
                  ),
                SizedBox(
                    height: 20.0
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: defaultColor,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'add photo',
                              style: TextStyle(
                                color: defaultColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '# tags',
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
