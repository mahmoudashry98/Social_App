import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/modules/social_app/social_login/login_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';

///Get
///Post
///Update
///Delete
/// base url : https://newsapi.org/
/// method(url) : v2/top-headlines?
/// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

String token = '';

String uId = '';

void signOut(context) {

  CacheHelper.removeData(key:'uId');
  // uId = CacheHelper.getData(key: 'uId');
  navigateAndFinish(
    context,
    LoginScreen(),
  );
  SocialCubit.get(context).currentIndex=0;
  SocialCubit.get(context).users=[];
  SocialCubit.get(context).posts=[];
  SocialCubit.get(context).postsId=[];
  SocialCubit.get(context).likes=[];

}

void printFullText(String text) {
  final pattern = RegExp('.{1.800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}


