import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_register_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_register_state.dart';
import 'package:flutter_abd_firebase/utils/components/component.dart';
import 'package:flutter_abd_firebase/utils/navigation/navigation.dart';
import 'package:flutter_abd_firebase/view/screens/main_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();
    var nameController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) =>
          SocialRegisterCubit(InitialRegisterState()),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialRegisterSuccessState) {
            Fluttertoast.showToast(
                msg: 'Success',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 5,
                webBgColor: true,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is SocialRegisterErrorState) {
            Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is SocialCreateUserSuccessState)
            pushNavAndReplace(context, MainScreen());
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Register Screen'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register'.toUpperCase(),
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        Text(
                          'Register now to connect with yours friend',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))),
                          validator: (val) {
                            if (val.isEmpty) return 'Please Enter Your Name';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                              labelText: 'Phone',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))),
                          validator: (val) {
                            if (val.isEmpty) return 'Please Enter phone';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          isPassword:
                              SocialRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          onSubmit: (value) {
                            if (formKey.currentState.validate()) {
                              SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);
                            }
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                SocialRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text);
                              }
                            },
                            child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text('Register')),
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' have an account?',
                            ),
                            defaultTextButton(
                              function: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => SocialLoginScreen()),
                                    (route) => false);
                              },
                              text: 'Login',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
