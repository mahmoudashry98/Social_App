import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/models/social_app/post_model.dart';
import 'package:scoial_app/models/social_app/social_user_model.dart';
import 'package:scoial_app/modules/social_app/chats/chats_screen.dart';
import 'package:scoial_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:scoial_app/modules/social_app/new_post/post_screen.dart';
import 'package:scoial_app/modules/social_app/settings/settings_screen.dart';
import 'package:scoial_app/modules/social_app/users/users_screen.dart';
import 'package:scoial_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> title = ['Home', 'Chats', 'New Post', 'Users', 'Settings'];

  void changeBottomNav(int index) {
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
  @required String name,
  @required String phone,
  @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
            name: name,
            phone: phone,
            bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
        print(value);
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
        print(value);
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  // void updateUserImages({
  //   @required String name,
  //   @required String phone,
  //   @required String bio,
  // }) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null) {
  //     uploadProfileImage();
  //   } else if (coverImage != null && profileImage != null) {
  //   } else {
  //     updateUser(
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //     );
  //   }
  // }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String cover ,
    String image,

  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: userModel.email,
      image: image??userModel.image,
      cover: cover??userModel.cover,
      uId: userModel.uId,
      phone: phone,
      bio: bio,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage(){
    postImage = null;
    emit(SocialRemovePostImageState());
  }
  void uploadPostImage({
    @required String text,
    @required String dateTime,

  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
        print(value);
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    @required String text,
    @required String dateTime,
    String postImage,

  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel.name,
      image:userModel.image,
      uId: userModel.uId,
      postImage: postImage?? '',
      text: dateTime,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }
}
