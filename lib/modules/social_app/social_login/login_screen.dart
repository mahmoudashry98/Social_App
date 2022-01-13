import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/social_layout.dart';
import 'package:scoial_app/modules/social_app/forgot_password/forgot_screen.dart';
import 'package:scoial_app/modules/social_app/social_login/cubit/cubit.dart';
import 'package:scoial_app/modules/social_app/social_register/Register_screen.dart';
import 'package:scoial_app/modules/social_app/social_register/social_register_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';
import 'cubit/states.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              SocialCubit.get(context).getUserData();
              SocialCubit.get(context).getPosts();
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
        builder: (context, state) => Scaffold(
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
                              horizontal: 30, vertical: 10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 80,
                                ),
                                _buildEmail(),
                                SizedBox(
                                  height: 20,
                                ),
                                _buildPassword(context),
                                _buildForgotPassword(context),
                                _buildLoginBtn(context, state),
                                _buildSignUp(context),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildEmail() => Column(
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

  Widget _buildPassword(context) => Column(
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
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              // ignore: missing_return
              onFieldSubmitted: (value) {
                if (formKey.currentState.validate()) {
                  SocialLoginCubit.get(context).userLogin(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
              obscureText: SocialLoginCubit.get(context).isPassword,
              autocorrect: false,
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

  Widget _buildForgotPassword(context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                navigateTo(context, ForgotPassword());
              },
              child: Text(
                'Forgot your password?',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.end,
              )),
        ],
      );

  Widget _buildLoginBtn(context, state) =>
      ConditionalBuilder(
        condition: state is! SocialLoginLoadingState,
        builder: (context) => Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5,
            onPressed: () {
              if (formKey.currentState.validate()) {
                SocialLoginCubit.get(context).userLogin(
                  email: emailController.text,
                  password: passwordController.text,
                );
              }
            },
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Text(
              'LOGIN',
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

  Widget _buildSignUp(context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Center(
            child: Text(
          'Or login with social account',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
        )),
        SizedBox(
          height: 25.0,
        ),
        Container(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/google-logo-9825.png'),
                ),
                SizedBox(
                  width: 10,
                ),
                Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/facebook.png'),
                ),
                SizedBox(
                  width: 10,
                ),
                Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/twitter.png'),
                ),
              ],
            )),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Container(
            height: 40,
            width: 100.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Colors.amber,
              onPressed: () {
                navigateTo(context, RegisterScreen());
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
