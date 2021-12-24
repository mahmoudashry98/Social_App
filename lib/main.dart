import 'package:bloc/bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/layout/social_app/social_layout.dart';
import 'package:scoial_app/modules/social_app/social_login/login_screen.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/components/constants.dart';
import 'package:scoial_app/shared/cubit/cubit.dart';
import 'package:scoial_app/shared/cubit/states.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';
import 'package:scoial_app/shared/network/remote/dio_helper.dart';
import 'package:scoial_app/shared/style/color/themes.dart';
import 'layout/social_app/cubit/cubit.dart';
import 'shared/bloc_observer.dart';

Future <void> _firebaseMessagingBackgroundHandler(RemoteMessage message)
async{
  print('on background message');
  print(message.data.toString());
  showToast(text: 'on background message', state: ToastStates.SUCCESS);
}

void main() async {
  //بيأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //foreground fcm
  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
    showToast(text: 'on message', state: ToastStates.SUCCESS);
  });

  //when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(text: 'on message opened app', state: ToastStates.SUCCESS);
  });

  //background fcm
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');

  //bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;
  uId = CacheHelper.getData(key: 'uId');
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    //isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  //final bool isDark;
  final Widget startWidget;
  MyApp(
      {
      //this.isDark,
      this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
                //fromShared: isDark,
                ),
        ),
        BlocProvider(
            create: (BuildContext context) => SocialCubit()
              ..getUserData()
              ..getPosts()
        ),

      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode:
                  //AppCubit.get(context).isDark ? ThemeMode.dark :
                  ThemeMode.light,
              home: startWidget);
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
