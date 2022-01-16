import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/models/social_app/comment_model.dart';
import 'package:scoial_app/models/social_app/message_model.dart';
import 'package:scoial_app/models/social_app/post_model.dart';
import 'package:scoial_app/models/social_app/social_user_model.dart';
import 'package:scoial_app/modules/social_app/chats/chats_screen.dart';
import 'package:scoial_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:scoial_app/modules/social_app/new_post/post_screen.dart';
import 'package:scoial_app/modules/social_app/profile/profile_screen.dart';
import 'package:scoial_app/modules/social_app/social_login/login_screen.dart';
import 'package:scoial_app/modules/social_app/users/users_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:scoial_app/shared/network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel userModel;
  CommentModel modelComment;

  void getUserData() {
    uId = CacheHelper.getData(key: 'uId') ;
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
    UserScreen(),
    ProfileScreen(),
  ];
  List<String> title = ['Home', 'Chats', 'New Post', 'Users', 'Settings'];

  void changeBottomNav(int index) {
    if(index == 0){
      getPosts();
      getUserData();
      getComments();
    }
    if(index == 1) getUsers();
    if(index == 3) getUsers();
    if(index == 4) getUserData();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File editProfileImage;

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      editProfileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }
  File coverImage;
  var picker = ImagePicker();

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
        .child('users/${Uri.file(editProfileImage.path).pathSegments.last}')
        .putFile(editProfileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
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


  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String cover,
    String image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: userModel.email,
      image: image ?? userModel.image,
      cover: cover ?? userModel.cover,
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
  void getPosts() {
    if(posts.length == 0)
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference.collection('likes').get().then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostsSuccessState());
        });

      });
    }).catchError((error)
    {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void getComments() {
    if(comments.length == 0)
    FirebaseFirestore.instance
        .collection('comments')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference.collection('likesComments').get().then((value)
        {
          likesComment.add(value.docs.length);
          commentsId.add(element.id);
          comments.add(CommentModel.fromJson(element.data()));
          emit(SocialGetCommentsSuccessState());
        });

      });
    }).catchError((error)
    {
      emit(SocialGetCommentsErrorState(error.toString()));
    });
  }

  void removePostImage() {
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
      image: userModel.image,
      uId: userModel.uId,
      postImage: postImage ?? '',
      text: text,
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

  File commentImage;

  Future<void> getCommentImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(SocialCommentImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(SocialCommentImagePickedErrorState());
    }
  }


  void removeCommentImage() {
    commentImage = null;
    emit(SocialRemoveCommentImageState());
  }

  void uploadCommentImage({
    @required String comment,
    @required String dateTime,
  }) {
    emit(SocialCreateCommentLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('comments/${Uri.file(commentImage.path).pathSegments.last}')
        .putFile(commentImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createComment(
          comment: comment,
          dateTime: dateTime,
          commentImage: value,
        );
      }).catchError((error) {
        emit(SocialCreateCommentErrorState());
        print(value);
      });
    }).catchError((error) {
      emit(SocialCreateCommentErrorState());
    });
  }

  void createComment({
    @required String comment,
    @required String dateTime,
    String commentImage,
  }) {
    emit(SocialCreateCommentLoadingState());

    CommentModel model = CommentModel(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      commentImage: commentImage ?? '',
      comment: comment,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreateCommentSuccessState());
    }).catchError((error) {
      emit(SocialCreateCommentErrorState());
    });
  }



  List <PostModel> posts=[];
  List <String> postsId=[];

  List <CommentModel> comments=[];
  List <String> commentsId=[];


  List <int> likesComment=[];
  void likeComment(String commentId) {
    FirebaseFirestore.instance
        .collection('comments')
        .doc(commentId)
        .collection('likesComment')
        .doc(userModel.uId)
        .set({
      'like': true,
    })
        .then((value)
    {
      emit(SocialLikeCommentSuccessState());
    }).catchError((error){
      emit(SocialLikeCommentErrorState(error.toString()));
    });
  }

  List <int> likes=[];
  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({
      'like': true,
    })
        .then((value)
    {
      emit(SocialLikePostSuccessState());
    }).catchError((error){
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  List <SocialUserModel> users = [];
  void getUsers () {
    if(users.length == 0)
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel.uId) {
            users.add(SocialUserModel.fromJson(element.data()));

          }
        });

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error)
    {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
  @required String receiverId,
  @required String dateTime,
  @required String text,
})
  {
    MessageModel model = MessageModel(
        senderId: userModel.uId,
        receiverId: receiverId,
        dateTime: dateTime,
        text: text,
    );
///set My chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(SocialSendMessageErrorState());
    });

///set My chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> message = [];

  void getMessages({@required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      message = [];
      event.docs.forEach((element)
      {
        message.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }

  Future<void> logOut(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      users = [];
      message = [];
      posts = [];
      postsId = [];
      comments = [];
      commentsId = [];
      likes = [];
      likesComment =[];
      editProfileImage = null;
      coverImage = null;
      userModel = null;
      uId = '';
      CacheHelper.removeData(key: 'uId');
      navigateAndFinish(context, LoginScreen());
      currentIndex = 0;
      emit(SocialLogOutSuccessState());
    }).catchError((error) {
      emit(SocialLogOutErrorState(error.toString()));
    });
  }


  Future<void> handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
       if(posts.length == 0)
         getPosts();
        emit(SocialGetPostsSuccessState());
      });

  }

}
