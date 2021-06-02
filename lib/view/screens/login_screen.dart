import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_login_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/shop_app_login_states.dart';
import 'package:flutter_abd_firebase/utils/components/component.dart';
import 'package:flutter_abd_firebase/utils/navigation/navigation.dart';
import 'package:flutter_abd_firebase/view/screens/main_screen.dart';
import 'package:flutter_abd_firebase/view/screens/register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SocialLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(InitialLoginState()),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginSuccessState) {
            Fluttertoast.showToast(
                msg: "Success",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 5,
                webBgColor: true,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            if (state is SocialLoginSuccessState)
              pushNavAndReplace(context, MainScreen());
          }
          if (state is SocialLoginErrorState) {
            Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Login Screen')),
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
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        Text(
                          'Login now to Connect with yours Friend',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        SizedBox(
                          height: 30.0,
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
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: SocialLoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState.validate()) {
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                await SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                print('access');
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'login'.toUpperCase(),
                              ),
                            ),
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
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                              function: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => SocialRegisterScreen()),
                                    (route) => false);
                              },
                              text: 'register',
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
