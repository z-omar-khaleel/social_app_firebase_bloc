import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/services/sharedprefrence.dart';
import 'package:flutter_abd_firebase/utils/components/component.dart';
import 'package:flutter_abd_firebase/utils/constant/constat.dart';
import 'package:flutter_abd_firebase/view/screens/login_screen.dart';
import 'package:flutter_abd_firebase/view/screens/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controller/observer/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //when app is in foreground
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data);
    print('When App open');
    showToast(text: 'When App Open', state: ToastStates.SUCCESS);
  });

  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  //when click on message on background
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data);
    print('When app open in background');
  });
  //on background or terminated

  Bloc.observer = MyBlocObserver();
  uId = await SharePref.getData(key: 'uid');
  Widget widget;
  if (uId != null) {
    widget = MainScreen();
  } else {
    widget = SocialLoginScreen();
  }
  print(uId);
  runApp(Home(
    widget: widget,
  ));
}

class Home extends StatelessWidget {
  Widget widget;

  Home({this.widget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (c) => SocialAppCubit(InitialSocialAppState())
              ..getPostData()
              ..getUserData()
              ..getUserChat())
      ],
      child: MaterialApp(
          theme: ThemeData(
              primaryTextTheme:
                  TextTheme(headline6: TextStyle(color: Colors.black87)),
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.black87,
                ),
                titleTextStyle: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
                textTheme:
                    TextTheme(headline1: TextStyle(color: Colors.black87)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              )),
          debugShowCheckedModeBanner: false,
          home: widget),
    );
  }
}
