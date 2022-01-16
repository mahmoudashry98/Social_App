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

///create post
class SocialCreatePostLoadingState extends SocialStates {}
class SocialCreatePostSuccessState extends SocialStates {}
class SocialCreatePostErrorState extends SocialStates {}

///New post
class SocialNewPostState extends SocialStates {}

///PostImagePicked
class SocialPostImagePickedSuccessState extends SocialStates {}
class SocialPostImagePickedErrorState extends SocialStates {}

///RemovePostImage
class SocialRemovePostImageState extends SocialStates {}

///Get comments
class SocialGetCommentsLoadingState extends SocialStates {}
class SocialGetCommentsSuccessState extends SocialStates {}
class SocialGetCommentsErrorState extends SocialStates
{
  final String error;

  SocialGetCommentsErrorState(this.error);
}

///create Comment
class SocialCreateCommentLoadingState extends SocialStates {}
class SocialCreateCommentSuccessState extends SocialStates {}
class SocialCreateCommentErrorState extends SocialStates {}

///New post
class SocialNewCommentState extends SocialStates {}

///PostImagePicked
class SocialCommentImagePickedSuccessState extends SocialStates {}
class SocialCommentImagePickedErrorState extends SocialStates {}

///RemovePostImage
class SocialRemoveCommentImageState extends SocialStates {}


///Get likesPosts
class SocialLikePostSuccessState extends SocialStates {}
class SocialLikePostErrorState extends SocialStates
{
  final String error;

  SocialLikePostErrorState(this.error);
}

///Get likesComments
class SocialLikeCommentSuccessState extends SocialStates {}
class SocialLikeCommentErrorState extends SocialStates
{
  final String error;

  SocialLikeCommentErrorState(this.error);
}

///ChangeBottomNav
class SocialChangeBottomNavState extends SocialStates {}

///ProfileImagePicked
class SocialProfileImagePickedSuccessState extends SocialStates {}
class SocialProfileImagePickedErrorState extends SocialStates {}

///UploadProfileImage
class SocialUploadProfileImageSuccessState extends SocialStates {}
class SocialUploadProfileImageErrorState extends SocialStates {}

///CoverImagePicked
class SocialCoverImagePickedSuccessState extends SocialStates {}
class SocialCoverImagePickedErrorState extends SocialStates {}

///UploadCoverImage
class SocialUploadCoverImageSuccessState extends SocialStates {}
class SocialUploadCoverImageErrorState extends SocialStates {}

///UserUpdate
class SocialUserUpdateErrorState extends SocialStates {}
class SocialUserUpdateLoadingState extends SocialStates {}

///LogOut
class SocialLogOutSuccessState extends SocialStates {}
class SocialLogOutErrorState extends SocialStates {
  final String error;

  SocialLogOutErrorState(this.error);
}










