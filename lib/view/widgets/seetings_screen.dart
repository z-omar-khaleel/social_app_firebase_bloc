import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/utils/navigation/navigation.dart';
import 'package:flutter_abd_firebase/view/screens/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final data = SocialAppCubit.get(context).getUser;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(data.cover == null
                                    ? 'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg'
                                    : data.cover))),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(data.image),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                data.name,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${data.bio} ...',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[500]),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        '100',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Posts')
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        '200',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Photos')
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        '10k',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Followers')
                    ],
                  )),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '120',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Following')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 17,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text('Add Photos'),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      pushNav(context, EditProfileScreen());
                    },
                    child: Icon(
                      Icons.edit,
                      size: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        FirebaseMessaging.instance.subscribeToTopic('zeco');
                      },
                      child: Text('subscribe')),
                  OutlinedButton(
                      onPressed: () {
                        FirebaseMessaging.instance.unsubscribeFromTopic('zeco');
                      },
                      child: Text('unsubscribe')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
