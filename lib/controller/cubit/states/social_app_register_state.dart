abstract class SocialRegisterStates {}

class InitialRegisterState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterErrorState extends SocialRegisterStates {
  final String message;

  SocialRegisterErrorState(this.message);
}

class SocialChangePasswordVisibilityState extends SocialRegisterStates {}

class SocialCreateUserSuccessState extends SocialRegisterStates {}

class SocialCreateUserLoadingState extends SocialRegisterStates {}

class SocialCreateUserErrorState extends SocialRegisterStates {
  final String message;

  SocialCreateUserErrorState(this.message);
}
