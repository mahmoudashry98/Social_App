abstract class SocialRegisterStates {}

//User Register
class SocialRegisterInitialState extends SocialRegisterStates {}
class SocialRegisterLoadingState extends SocialRegisterStates {}
class SocialRegisterSuccessState extends SocialRegisterStates {}
class SocialRegisterErrorState extends SocialRegisterStates
{
  final String error;
  SocialRegisterErrorState(this.error);
}

//User Create Account
class SocialCreateUserSuccessState extends SocialRegisterStates
{
  final String uId;
  SocialCreateUserSuccessState(this.uId);
}
class SocialCreateUserErrorState extends SocialRegisterStates
{
  final String error;
  SocialCreateUserErrorState(this.error);
}
class SocialRegisterChangePasswordVisibilityState extends SocialRegisterStates {}

//User Picked Image
class SocialRegisterProfileImagePickedSuccessState extends SocialRegisterStates {}
class SocialRegisterProfileImagePickedErrorState extends SocialRegisterStates{}

//User Upload Image
class UploadRegisterProfileImageLoadingState extends SocialRegisterStates {}
class UploadRegisterProfileImageSuccessState extends SocialRegisterStates {}
class UploadRegisterProfileImageErrorState extends SocialRegisterStates {}



