import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/modules/social_app/settings/settings_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/components/constants.dart';
import 'package:scoial_app/shared/style/color/color.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var imageController = TextEditingController();
  var emailController = TextEditingController();
  var bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        nameController.text =userModel.name;
        imageController.text =userModel.image;
        bioController.text =userModel.bio;
        return ConditionalBuilder(
         condition: SocialCubit.get(context).userModel != null ,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 200.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          width: double.infinity,
                          height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0)),
                            image: DecorationImage(
                              image: NetworkImage('${userModel.cover}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: CircleAvatar(
                          radius: 62.0,
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage('${userModel.image}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${nameController.text}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${bioController.text}',
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '365',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Photos',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '10K',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '250',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Following',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'Add Photos',
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        navigateTo(context, SettingsScreen());
                      },
                      child: Icon(
                        Icons.settings,
                        size: 16.0,
                        color: defaultColor,
                      ),
                    ),

                    SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        signOut(context);
                      },
                      child: Icon(
                        Icons.logout,
                        size: 16.0,
                        color: defaultColor,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
