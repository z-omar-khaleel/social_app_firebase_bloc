import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/utils/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_post.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = SocialAppCubit.get(context);

    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        if (state is SocialChangeBottomNavPostState)
          pushNav(context, AddPost());
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
            ],
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey[400],
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.food_bank_sharp), label: 'Foods'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.post_add), label: 'Post'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            currentIndex: cubit.currentIndex,
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
        );
      },
    );
  }
}
