import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/social_layout.dart';
import 'package:scoial_app/modules/social_app/social_login/cubit/cubit.dart';
import 'package:scoial_app/modules/social_app/social_register/cubit/cubit.dart';
import 'package:scoial_app/modules/social_app/social_register/cubit/states.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var imageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) async {
              SocialCubit.get(context).getPosts();
              SocialCubit.get(context).getUserData();
              showToast(
                text: 'Welcome in Social App',
                state: ToastStates.SUCCESS,
              );
              navigateAndFinish(
                context,
                SocialLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.amber,
              ),
              backgroundColor: Colors.amber,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.amber,
                              Colors.amber,
                              Colors.amber,
                              Colors.white70,
                            ],
                          )),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 00),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  buildImageProfile(context),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  buildUserName(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildEmail(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildPassword(context),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildPhone(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildSignUpBtn(context, state),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buildImageProfile(context) {
    // ignore: unnecessary_statements

    var profileImage=SocialRegisterCubit.get(context).profileImage;
    return Column(
      children: [
        InkWell(
          onTap: (){
            SocialRegisterCubit.get(context).getProfileImage();
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 60,
            backgroundImage: profileImage == null
                ? AssetImage('assets/images/img.png')
                : FileImage(profileImage) as ImageProvider,
          ),
        ),
      ],
    );
  }

  Widget buildUserName() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]),
              height: 55,
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please Enter Your UserName';
                  }
                },

                style: TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'UserName',
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Colors.amberAccent,
                    ),
                    hintText: "UserName",
                    hintStyle: TextStyle(color: Colors.black38)),
              )),
        ],
      );

  Widget buildEmail() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]),
              height: 55,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please Enter Your Email Address';
                  }
                },

                style: TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email Address',
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.amberAccent,
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black38)),
              )),
        ],
      );

  Widget buildPassword(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]),
            height: 55,
            child: TextFormField(
              obscureText: SocialRegisterCubit.get(context).isPassword,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              // ignore: missing_return
              onFieldSubmitted: (value) {
                if (value.isEmpty) {
                  return 'password is too short';
                }
              },

              // ignore: missing_return
              validator: (String value) {
                if (value.isEmpty) {
                  return 'password is too short';
                }
              },
              style: TextStyle(
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Password',
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.amberAccent,
                  ),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.black38)),
            ),
          ),
        ],
      );

  Widget buildPhone() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]),
              height: 55,
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please Enter Your Phone number';
                  }
                },

                style: TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'phone',
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.amberAccent,
                    ),
                    hintText: "Phone",
                    hintStyle: TextStyle(color: Colors.black38)),
              )),
        ],
      );

  Widget buildSignUpBtn(context, state) => ConditionalBuilder(
        condition: state is! SocialRegisterLoadingState,
        builder: (context) => Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5,
            onPressed: () {

                if (formKey.currentState.validate()) {
                  SocialRegisterCubit.get(context).userRegister(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    phone: phoneController.text,
                  );
                }

            },
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        fallback: (context) => Center(child: CircularProgressIndicator()),
      );
}

// function: () {

// },
