abstract class SocialLoginStates {}

class InitialLoginState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginErrorState extends SocialLoginStates {
  final String message;

  SocialLoginErrorState(this.message);
}

class SocialChangePasswordVisibilityState extends SocialLoginStates {}
