import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/utils/components/component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key key}) : super(key: key);
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          titleSpacing: 5,
          actions: [
            TextButton(
                onPressed: () async {
                  await SocialAppCubit.get(context).updateProfile(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text);
                },
                child: Text('Update')),
            SizedBox(
              width: 4,
            )
          ],
        ),
        body: BlocConsumer<SocialAppCubit, SocialAppStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            final data = SocialAppCubit.get(context).getUser;
            final imageProfile = SocialAppCubit.get(context).profileImage;
            final imagePerson = SocialAppCubit.get(context).personImage;
            nameController.text =
                SocialAppCubit.get(context).getUser.name ?? '';
            bioController.text = SocialAppCubit.get(context).getUser.bio ?? '';
            phoneController.text =
                SocialAppCubit.get(context).getUser.phone ?? '';

            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    if (state is SocialAppUpdateProfileLoadingState)
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: LinearProgressIndicator()),
                    if (state is SocialAppUpdateProfileLoadingState)
                      SizedBox(
                        height: 10,
                      ),
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 120,
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: imageProfile == null
                                              ? NetworkImage(data.cover)
                                              : FileImage(imageProfile))),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blueAccent,
                                  size: 24,
                                ),
                                onPressed: () {
                                  SocialAppCubit.get(context).getProfileImage();
                                },
                              )
                            ],
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
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
                                              image: imagePerson == null
                                                  ? NetworkImage(data.image)
                                                  : FileImage(imagePerson),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueAccent,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    SocialAppCubit.get(context)
                                        .getPersonImage();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                        label: 'Name',
                        type: TextInputType.text,
                        validate: (val) {
                          return null;
                        },
                        prefix: Icons.person_add,
                        controller: nameController),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        label: 'Bio',
                        type: TextInputType.text,
                        validate: (val) {
                          return null;
                        },
                        prefix: Icons.description_outlined,
                        controller: bioController),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        label: 'Phone',
                        type: TextInputType.phone,
                        validate: (val) {
                          return null;
                        },
                        prefix: Icons.phone,
                        controller: phoneController),
                  ])),
            );
          },
        ));
  }
}
