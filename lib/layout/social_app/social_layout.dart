import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/modules/social_app/new_post/post_screen.dart';
import 'package:scoial_app/shared/components/components.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.title[cubit.currentIndex],
            ),
            // actions: [
            //   IconButton(
            //       icon: Icon(Icons.notification_important_rounded),
            //       onPressed: () {}),
            //   IconButton(icon: Icon(Icons.search_outlined), onPressed: () {}),
            // ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.post_add), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.group), label: 'Users'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
