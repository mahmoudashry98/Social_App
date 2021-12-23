import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/social_layout.dart';
import 'package:scoial_app/modules/social_app/social_login/cubit/cubit.dart';
import 'package:scoial_app/modules/social_app/social_register/social_register_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';

import 'cubit/states.dart';


// ignore: must_be_immutable
class SocialLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state)
        {
          if(state is SocialLoginErrorState)
          {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if(state is SocialLoginSuccessState)
          {
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
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Login now to communicate with friend',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter Your Email Address';
                          }
                        },
                        label: 'Email Address',
                        prefix: Icons.email_outlined,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        suffix: SocialLoginCubit.get(context).suffix,
                        onSubmit: (value) {
                          // if (formKey.currentState.validate()) {
                          //   SocialLoginCubit.get(context).userLogin(
                          //     email: emailController.text,
                          //     password: passwordController.text,
                          //   );
                          // }
                        },
                        isPassword: SocialLoginCubit.get(context).isPassword,
                        suffixPressed: () {
                          SocialLoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'password is too short';
                          }
                        },
                        label: 'Password',
                        prefix: Icons.lock_outline,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! SocialLoginLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState.validate()) {
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          text: 'login',
                          isUpperCase: true,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, SocialRegisterScreen());
                            },
                            text: 'Register',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
