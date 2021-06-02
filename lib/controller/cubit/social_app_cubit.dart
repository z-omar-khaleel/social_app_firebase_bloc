import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/model/User.dart';
import 'package:flutter_abd_firebase/model/chat_message_model.dart';
import 'package:flutter_abd_firebase/model/post_model.dart';
import 'package:flutter_abd_firebase/utils/constant/constat.dart';
import 'package:flutter_abd_firebase/view/screens/add_post.dart';
import 'package:flutter_abd_firebase/view/widgets/chat_screen.dart';
import 'package:flutter_abd_firebase/view/widgets/feeds_screen.dart';
import 'package:flutter_abd_firebase/view/widgets/seetings_screen.dart';
import 'package:flutter_abd_firebase/view/widgets/user_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SocialAppCubit extends Cubit<SocialAppStates> {
  SocialAppCubit(SocialAppStates initialState) : super(initialState);
  CreateUser getUser;
  static SocialAppCubit get(context) =>
      BlocProvider.of<SocialAppCubit>(context);
  getUserData() async {
    print('ooooookkkkk');
    emit(SocialAppLoadingGetUserState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      emit(SocialAppSuccessGetUserState());
      print(value.data());
      getUser = CreateUser.fromJson(value.data());
      print(getUser.email);
    }).catchError((error) {
      emit(SocialAppErrorGetUserState());
    });
  }

  List<Widget> bottomScreens = [
    FeedsScreen(),
    AddPost(),
    ChatScreen(),
    SettingsScreen(),
  ];
  int currentIndex = 0;
  void changeBottomNav(int index) {
    if (index == 1) {
      emit(SocialChangeBottomNavPostState());
    } else {
      currentIndex = index;

      emit(SocialChangeBottomNavState());
    }
    print(currentIndex);
  }

  List<String> titles = ['Feeds', "", 'Chat', 'Settings'];

  File profileImage;
  File personImage;
  File postImage;
  final picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialAppImagePickerProfileSuccessState());
    } else {
      print('No image selected.');
      emit(SocialAppImagePickerProfileErrorState('No image selected.'));
    }
  }

  Future<void> getPersonImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      personImage = File(pickedFile.path);
      emit(SocialAppImagePickerPersonSuccessState());
    } else {
      print('No image selected.');
      emit(SocialAppImagePickerPersonErrorState('No image selected.'));
    }
  }

  var _fireStorage = FirebaseStorage.instance;
  var _fireStore = FirebaseFirestore.instance;
  uploadProfileImage() async {
    if (profileImage != null) {
      await _fireStorage
          .ref()
          .child('user/${Uri.file(profileImage.path).pathSegments.last}')
          .putFile(profileImage)
          .then((val) async {
        _fireStore
            .collection('users')
            .doc(getUser.id)
            .update({'cover': await val.ref.getDownloadURL()});
      }).catchError((error) => print(error));
    }
  }

  uploadPersonImage() async {
    if (personImage != null) {
      await _fireStorage
          .ref()
          .child('user/${Uri.file(personImage.path).pathSegments.last}')
          .putFile(personImage)
          .then((val) async {
        _fireStore
            .collection('users')
            .doc(getUser.id)
            .update({'image': await val.ref.getDownloadURL()});
      }).catchError((error) => print(error));
    }
  }

  updateProfile({String name = '', String bio = '', String phone = ''}) async {
    emit(SocialAppUpdateProfileLoadingState());
    if (personImage != null) {
      await uploadPersonImage();
    }
    if (profileImage != null) {
      await uploadProfileImage();
    }
    await _fireStore.collection('users').doc(getUser.id).update({
      'name': name.isEmpty ? getUser.name : name,
      'phone': phone.isEmpty ? getUser.name : phone,
      'bio': bio.isEmpty ? getUser.name : bio,
    });
    await getUserData();
    emit(SocialAppUpdateProfileSuccessState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialAppImagePickerPostSuccessState());
    } else {
      print('No image selected.');
      emit(SocialAppImagePickerPostErrorState('No image selected.'));
    }
  }

  String postImageUrl;
  uploadPostImage() async {
    if (postImage != null) {
      await _fireStorage
          .ref()
          .child('posts/${Uri.file(postImage.path).pathSegments.last}')
          .putFile(postImage)
          .then((val) async {
        postImageUrl = await val.ref.getDownloadURL();
        emit(SocialAppPostImageUrlState());
      }).catchError((error) => print(error));
    }
  }

  uploadPost({String text}) async {
    emit(SocialAppUploadPostLoadingState());

    await uploadPostImage();
    final post = PostModel(
        uId: getUser.id,
        name: getUser.name,
        image: getUser.image,
        postImage: postImageUrl ?? getUser.image,
        text: text,
        dateTime: DateTime.now().toString());
    await _fireStore.collection('posts').add(post.toMap()).then((value) async {
      await value.collection('likes').doc(uId).set({'like': false});
      emit(SocialAppUploadPostSuccessState());
      await getPostData();
    }).catchError((error) {
      emit(SocialAppUploadPostErrorState());
    });
  }

  changePostUrlValue(File val) {
    postImage = val;
    emit(SocialAppChangePostImageVal());
  }

  Set<PostModel> posts = {};
  Set<String> postId = {};
  List<int> like = [];
  List<bool> likeState = [];
  getPostData() async {
    emit(SocialAppGetPostDataLoading());
    await _fireStore.collection('posts').get().then((value) async {
      await _postLoop(value);
      emit(SocialAppGetPostDataSuccess());
    }).catchError((onError) {
      print(onError.toString());
      print(onError.runtimeType);
      emit(SocialAppGetPostDataError(onError.toString()));
    });
  }

  _postLoop(QuerySnapshot<Map<String, dynamic>> value) async {
    posts = {};
    postId = {};
    like = [];
    likeState = [];

    for (var element in value.docs) {
      var likeStateVal =
          await element.reference.collection('likes').doc(uId).get();
      print('likeStateVal $likeStateVal');
      if (!likeStateVal.exists || likeStateVal == null) {
        print('This nis null val');
        await element.reference
            .collection('likes')
            .doc(uId)
            .set({'like': false});
        likeState.add(false);
      } else {
        likeState.add(await likeStateVal.data()['like']);
      }
      var likeValue = await element.reference.collection('likes').get();
      print('2');
      like.add(likeValue.docs
          .where((element1) => element1.data()['like'] == true)
          .toList()
          .length);
      print(3);

      print(4);
      postId.add(element.id);
      posts.add(PostModel.fromMap(element.data()));
      print('postId.length ${postId.length}');
      print('posts.length ${posts.length}');
      print('likeState.length ${likeState.length}');
      print('like.length ${like.length}');
    }
  }

  Future<void> likePost(String postId, int index) async {
    likeState[index] = !likeState[index];
    await _fireStore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uId)
        .set({'like': likeState[index]})
        .then((value) => emit(SocialAppLikePostSuccess()))
        .catchError((error) {
          SocialAppLikePostError();
        });
    await _fireStore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value1) {
      like[index] = value1.docs
          .where((element) => element.data()['like'] == true)
          .toList()
          .length;
      print(like[index]);
      emit(SocialAppLikePostSuccess());
    }).catchError((eror) => print(eror));
  }

  List<CreateUser> users = [];
  getUserChat() async {
    emit(SocialAppChatLoading());
    await _fireStore.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['id'] != uId)
          users.add(CreateUser.fromJson(element.data()));
      });
      emit(SocialAppChatSuccess());
    }).catchError((error) => emit(SocialAppChatError()));
  }

  uploadChatMessage({String senderId, String reciverId, String text}) async {
    final message = MessageChatModel(
        senderId: senderId,
        reciverId: reciverId,
        message: text,
        dateTime: DateTime.now().toString());

    await _fireStore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(reciverId)
        .collection('message')
        .add(message.toMap())
        .then((value) => emit(SocialAppChatSendMessageSuccess()))
        .catchError((error) => emit(SocialAppChatError()));
    await _fireStore
        .collection('users')
        .doc(reciverId)
        .collection('chats')
        .doc(senderId)
        .collection('message')
        .add(message.toMap())
        .then((value) => emit(SocialAppChatSendMessageSuccess()))
        .catchError((error) => emit(SocialAppChatError()));
  }

  List<MessageChatModel> messages = [];
  getChatMessage(String reciverId) {
    _fireStore
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(reciverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageChatModel.fromMap(element.data()));
      });
      print(messages.length);
      emit(SocialAppChatGetMessageSuccess());
    });
  }
}
