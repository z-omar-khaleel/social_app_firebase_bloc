abstract class SocialAppStates {}

class InitialSocialAppState extends SocialAppStates {}

class SocialAppSuccessGetUserState extends SocialAppStates {}

class SocialAppErrorGetUserState extends SocialAppStates {}

class SocialAppLoadingGetUserState extends SocialAppStates {}

class SocialChangeBottomNavState extends SocialAppStates {}

class SocialChangeBottomNavPostState extends SocialAppStates {}

class SocialAppImagePickerProfileSuccessState extends SocialAppStates {}

class SocialAppImagePickerProfileErrorState extends SocialAppStates {
  final String message;

  SocialAppImagePickerProfileErrorState(this.message);
}

class SocialAppUpdateProfileSuccessState extends SocialAppStates {}

class SocialAppUpdateProfileLoadingState extends SocialAppStates {}

class SocialAppImagePickerPersonSuccessState extends SocialAppStates {}

class SocialAppImagePickerPersonErrorState extends SocialAppStates {
  final String message;

  SocialAppImagePickerPersonErrorState(this.message);
}

class SocialAppImagePickerPostSuccessState extends SocialAppStates {}

class SocialAppImagePickerPostErrorState extends SocialAppStates {
  final String message;

  SocialAppImagePickerPostErrorState(this.message);
}

class SocialAppPostImageUrlState extends SocialAppStates {}

class SocialAppUploadPostSuccessState extends SocialAppStates {}

class SocialAppUploadPostErrorState extends SocialAppStates {}

class SocialAppUploadPostLoadingState extends SocialAppStates {}

class SocialAppChangePostImageVal extends SocialAppStates {}

class SocialAppGetPostDataSuccess extends SocialAppStates {}

class SocialAppGetPostDataLoading extends SocialAppStates {}

class SocialAppGetPostDataError extends SocialAppStates {
  final String message;

  SocialAppGetPostDataError(this.message);
}

class SocialAppLikePostSuccess extends SocialAppStates {}

class SocialAppLikePostError extends SocialAppStates {}

class SocialAppChatLoading extends SocialAppStates {}

class SocialAppCheckFavSuccess extends SocialAppStates {}

class SocialAppChatSuccess extends SocialAppStates {}

class SocialAppChatError extends SocialAppStates {}

class SocialAppChatSendMessageSuccess extends SocialAppStates {}

class SocialAppChatSendMessageError extends SocialAppStates {}

class SocialAppChatGetMessageSuccess extends SocialAppStates {}

class SocialAppChatGetMessageError extends SocialAppStates {}
