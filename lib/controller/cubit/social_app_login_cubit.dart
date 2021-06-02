import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/shop_app_login_states.dart';
import 'package:flutter_abd_firebase/model/chat_message_model.dart';
import 'package:flutter_abd_firebase/services/sharedprefrence.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit(SocialLoginStates initialState) : super(initialState);

  static SocialLoginCubit get(context) =>
      BlocProvider.of<SocialLoginCubit>(context);
  Future<void> userLogin({
    @required String email,
    @required String password,
  }) async {
    emit(SocialLoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      SharePref.setData(key: 'uid', data: value.user.uid).then((value) {
        if (value) {
          emit(SocialLoginSuccessState());
        } else {
          emit(SocialLoginErrorState('Error in store data'));
        }
      });
      print(value.user.email);
    }).catchError((error) {
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialChangePasswordVisibilityState());
  }
}
