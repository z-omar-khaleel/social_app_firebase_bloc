import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_abd_firebase/controller/cubit/social_app_cubit.dart';
import 'package:flutter_abd_firebase/controller/cubit/states/social_app_states.dart';
import 'package:flutter_abd_firebase/model/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async =>
              await SocialAppCubit.get(context).getPostData(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8),
                  child: Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image(
                          width: double.infinity,
                          height: 150,
                          image: NetworkImage(
                              'https://t3.ftcdn.net/jpg/04/16/33/10/240_F_416331012_5vZmIGhlMcLTeYIcyUWivjLxCwLL4tUz.jpg'),
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Communication with Friends',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.white)
                                    .color),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: SocialAppCubit.get(context).getUser != null &&
                      SocialAppCubit.get(context).posts.length > 0,
                  builder: (c) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    elevation: 10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: ListView.separated(
                      itemBuilder: (c, i) => buildFeed(
                          SocialAppCubit.get(context).posts.elementAt(i), i),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (c, i) => Divider(
                        thickness: 12,
                        color: Colors.grey[400],
                      ),
                      itemCount: SocialAppCubit.get(context).posts.length,
                    ),
                  ),
                  fallback: (c) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class buildFeed extends StatelessWidget {
  final PostModel model;
  int index;
  buildFeed(this.model, this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(model.image),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              model.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                        Text(
                          DateTime.now().toString(),
                          style: TextStyle(height: 1.3),
                        )
                      ],
                    ),
                  ),
                  IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.grey[400],
              ),
              Text(
                model.text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 7,
              ),
              Wrap(
                spacing: 3,
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    height: 25,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 1,
                      mouseCursor: MouseCursor.defer,
                      child: Text(
                        '#software',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 25,
                    padding: EdgeInsets.zero,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 1,
                      child: Text(
                        '#flutter',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(
                      model.postImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(SocialAppCubit.get(context)
                              .like
                              .elementAt(index)
                              .toString())
                        ],
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.message,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text('120 comments')
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(model.image),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('write comment ...'),
                  Spacer(),
                  InkWell(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            SocialAppCubit.get(context).likeState[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await SocialAppCubit.get(context).likePost(
                                SocialAppCubit.get(context)
                                    .postId
                                    .elementAt(index),
                                index);
                          },
                        ),
                        Text('Like')
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
