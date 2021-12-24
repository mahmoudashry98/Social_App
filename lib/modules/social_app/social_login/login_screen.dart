import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/social_layout.dart';
import 'package:scoial_app/modules/social_app/social_login/cubit/cubit.dart';
import 'package:scoial_app/modules/social_app/social_register/social_register_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';
import 'cubit/states.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
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
                              horizontal: 25, vertical: 120),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                buildEmail(),
                                SizedBox(
                                  height: 20,
                                ),
                                buildPassword(context),
                                buildLoginBtn(context, state),
                                buildSignUp(context),
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

  Widget buildEmail() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Email',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 10,
      ),
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
          height: 60,
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
      Text(
        'Password',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 10,
      ),
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
        height: 60,
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
          obscureText: false,
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
      SizedBox(
        height: 30.0,
      ),
    ],
  );

  Widget buildLoginBtn(context, state) => ConditionalBuilder(
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

  Widget buildSignUp(context) => GestureDetector(
    onTap: () {
      navigateTo(context, SocialRegisterScreen());
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an Account? ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
        ],
      ),
    ),
  );
}
