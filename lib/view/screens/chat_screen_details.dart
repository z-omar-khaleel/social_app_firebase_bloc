import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/model/User.dart';
import 'package:flutter_abd_firebase/utils/constant/constat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetails extends StatelessWidget {
  final CreateUser model;
  final _controller = TextEditingController();
  ChatDetails(this.model);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (c) {
      SocialAppCubit.get(context).getChatMessage(model.id);
      return BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(model.image),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    model.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Expanded(
                    child: ConditionalBuilder(
                      condition:
                          SocialAppCubit.get(context).messages.length > 0,
                      builder: (c) {
                        return ListView.separated(
                            itemBuilder: (c, index) {
                              final message =
                                  SocialAppCubit.get(context).messages[index];
                              if (message.senderId == uId) {
                                return buildMyMessage(message.message);
                              }
                              return buildMessage(message.message);
                            },
                            separatorBuilder: (c, i) {
                              return Padding(padding: EdgeInsets.all(10));
                            },
                            itemCount:
                                SocialAppCubit.get(context).messages.length);
                      },
                      fallback: (c) =>
                          !(SocialAppCubit.get(context).messages.length == 0 &&
                                  state is SocialAppChatGetMessageSuccess)
                              ? Center(child: CircularProgressIndicator())
                              : Center(
                                  child: Text(''),
                                ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey[300])),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            onFieldSubmitted: (v) async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              await SocialAppCubit.get(context)
                                  .uploadChatMessage(
                                      senderId: uId,
                                      reciverId: model.id,
                                      text: _controller.text);
                            },
                            controller: _controller,
                            decoration: InputDecoration(
                                hintText: 'Enter Your Message Here ....',
                                border: InputBorder.none),
                          ),
                        )),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(.8),
                              borderRadius: BorderRadius.circular(5)),
                          child: MaterialButton(
                            onPressed: () async {
                              await SocialAppCubit.get(context)
                                  .uploadChatMessage(
                                      senderId: uId,
                                      reciverId: model.id,
                                      text: _controller.text);
                            },
                            child: Icon(
                              Icons.send_rounded,
                              size: 15,
                              color: Colors.white.withOpacity(.9),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Align buildMyMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(.4),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Align buildMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        child: Text(
          message,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
