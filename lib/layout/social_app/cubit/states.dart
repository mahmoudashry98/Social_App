abstract class SocialStates{}

class SocialInitialState extends SocialStates{}

///Get Users

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates
{
  final String error;

  SocialGetUserErrorState(this.error);
}

///Get All Users

class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates
{
  final String error;

  SocialGetAllUsersErrorState(this.error);
}

///Chat

class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessagesSuccessState extends SocialStates {}


///Get posts

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates
{
  final String error;

  SocialGetPostsErrorState(this.error);
}

///Get likes

class SocialLikePostSuccessState extends SocialStates {}

class SocialLikePostErrorState extends SocialStates
{
  final String error;

  SocialLikePostErrorState(this.error);
}

///Get comments

class SocialCommentPostSuccessState extends SocialStates {}

class SocialCommentPostErrorState extends SocialStates
{
  final String error;

  SocialCommentPostErrorState(this.error);
}


class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}

class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageSuccessState extends SocialStates {}

class SocialUploadCoverImageErrorState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

///create post
class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

///create comment
class SocialCreateCommentLoadingState extends SocialStates {}

class SocialCreateCommentSuccessState extends SocialStates {}

class SocialCreateCommentErrorState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

class SocialLogOutSuccessState extends SocialStates {}

class SocialLogOutErrorState extends SocialStates {
  final String error;

  SocialLogOutErrorState(this.error);
}










