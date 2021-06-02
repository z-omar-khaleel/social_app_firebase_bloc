import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/model/User.dart';
import 'package:flutter_abd_firebase/utils/navigation/navigation.dart';
import 'package:flutter_abd_firebase/view/screens/chat_screen_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final userModel = SocialAppCubit.get(context).users;
        return ConditionalBuilder(
          builder: (c) => ListView.separated(
            itemCount: SocialAppCubit.get(context).users.length,
            itemBuilder: (c, index) => chatItem(userModel[index], context),
            separatorBuilder: (c, index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Divider(),
            ),
          ),
          fallback: (c) => Center(
            child: CircularProgressIndicator(),
          ),
          condition: SocialAppCubit.get(context).users.length > 0,
        );
      },
    );
  }

  Widget chatItem(CreateUser user, context) {
    return InkWell(
      onTap: () {
        pushNav(context, ChatDetails(user));
      },
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: NetworkImage(user.image),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              user.name,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
            )
          ],
        ),
      ),
    );
  }
}
