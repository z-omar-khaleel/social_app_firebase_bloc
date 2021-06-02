import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_register_state.dart';
import 'package:flutter_abd_firebase/model/User.dart';
import 'package:flutter_abd_firebase/services/sharedprefrence.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit(SocialRegisterStates initialState) : super(initialState);

  static SocialRegisterCubit get(context) =>
      BlocProvider.of<SocialRegisterCubit>(context);
  void userRegister({
    @required String email,
    @required String password,
    @required String phone,
    @required String name,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SocialRegisterSuccessState());
      createUser(email: email, phone: phone, name: name, id: value.user.uid);
    }).catchError((error) {
      print('error is $error');
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  createUser({String email, String name, String phone, String id}) async {
    final user = CreateUser(
        email: email,
        phone: phone,
        name: name,
        id: id,
        image:
            'https://image.freepik.com/free-photo/mand-holding-cup_1258-340.jpg',
        cover:
            'https://image.freepik.com/free-photo/podium-display-with-tropical-leaf-green-wall-3d-rendering_41470-3540.jpg',
        bio: 'This is bio');
    emit(SocialCreateUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(user.toJson())
        .then((value) {
      SharePref.setData(key: 'uid', data: id).then((value) {
        if (value) {
          emit(SocialCreateUserSuccessState());
        } else {
          emit(SocialCreateUserErrorState('error in sharePref'));
        }
      });
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
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
