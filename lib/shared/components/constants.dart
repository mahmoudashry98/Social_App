

import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';

///Get
///Post
///Update
///Delete
/// base url : https://newsapi.org/
/// method(url) : v2/top-headlines?
/// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      // navigateAndFinish(
      //   context,
      //   ShopLoginScreen(),
      // );
    }
  });
}

void printFullText(String text)
{
  final pattern = RegExp('.{1.800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';

String uId = '';