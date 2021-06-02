import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPost extends StatelessWidget {
  final textController = TextEditingController(text: 'Write Post ...');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [
          TextButton(
              onPressed: () {
                SocialAppCubit.get(context).uploadPost(
                  text: textController.text,
                );
              },
              child: Text('Post'))
        ],
      ),
      body: BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final data = SocialAppCubit.get(context).getUser;
          return Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                if (state is SocialAppUploadPostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialAppUploadPostLoadingState)
                  SizedBox(
                    height: 10,
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(data.image),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        data.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  controller: textController,
                )),
                if (SocialAppCubit.get(context).postImage != null)
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image(
                          image:
                              FileImage(SocialAppCubit.get(context).postImage),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {
                            SocialAppCubit.get(context)
                                .changePostUrlValue(null);
                          },
                          icon: Icon(Icons.cancel),
                          color: Colors.blueAccent,
                          iconSize: 29,
                        )
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                        child: TextButton.icon(
                      icon: Icon(
                        Icons.image,
                      ),
                      label: Text('Add Photo'),
                      onPressed: () async {
                        await SocialAppCubit.get(context).getPostImage();
                      },
                    )),
                    Expanded(
                        child: TextButton(
                      child: Text('#Tags '),
                      onPressed: () {},
                    )),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
