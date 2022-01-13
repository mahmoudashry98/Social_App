import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoial_app/models/social_app/social_user_model.dart';
import 'package:scoial_app/modules/social_app/social_register/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialRegisterProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialRegisterProfileImagePickedErrorState());
    }
  }

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((valueID) {
      emit(UploadRegisterProfileImageLoadingState());
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(profileImage.path).pathSegments.last}')
          .putFile(profileImage)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          emit(UploadRegisterProfileImageSuccessState());
          userCreate(
            name: name,
            email: email,
            phone: phone,
            uId: valueID.user.uid,
            image: value,
          );
        }).catchError((error) {
          emit(SocialRegisterErrorState(error.toString()));
        });
          print(value);
        }).catchError((error) {
          emit(UploadRegisterProfileImageErrorState());
          print(valueID);
        });
      }).catchError((error) {
        emit(UploadRegisterProfileImageErrorState());
      });

  }

  void userCreate({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
    @required String image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: image,
      isEmailVerified: false,
    );


    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
