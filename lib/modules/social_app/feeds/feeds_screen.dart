import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scoial_app/layout/social_app/cubit/cubit.dart';
import 'package:scoial_app/layout/social_app/cubit/states.dart';
import 'package:scoial_app/models/social_app/post_model.dart';
import 'package:scoial_app/shared/components/components.dart';
import 'package:scoial_app/shared/style/color/color.dart';

class FeedsScreen extends StatelessWidget {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var posts = SocialCubit.get(context).posts;
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length > 0,
          builder: (context) => LiquidPullToRefresh(
            key: _refreshIndicatorKey,
            onRefresh: SocialCubit.get(context).handleRefresh,
            showChildOpacityTransition: false,
            color: Theme.of(context).scaffoldBackgroundColor,
            backgroundColor: defaultColor,
            child: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      margin: EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://image.freepik.com/free-photo/portrait-happy-young-woman-holding-empty-speech-bubble-standing-isolated-yellow-wall_231208-10128.jpg'),
                            fit: BoxFit.cover,
                            height: 200.0,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'communicate with friends',
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPostItem(
                          SocialCubit.get(context).posts[index], context, index),
                      itemCount: SocialCubit.get(context).posts.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8.0,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => posts.length == 0
              ? Column(children: [
                  Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5.0,
              margin: EdgeInsets.all(8.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Image(
                    image: NetworkImage(
                        'https://image.freepik.com/free-photo/portrait-happy-young-woman-holding-empty-speech-bubble-standing-isolated-yellow-wall_231208-10128.jpg'),
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'communicate with friends',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
                  Spacer(),
                  Center(
                    child: Text(
                      'No Posts yet',
                      style: TextStyle(color: Colors.black38, fontSize: 35),
                    ),
                  ),
                  Spacer(),
                ])
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(PostModel model, context, index) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //Image Account
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                SizedBox(
                  width: 15.0,
                ),
                //Name, Icon Profile(CheckIcon), DatTime
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          )
                        ],
                      ),
                      Text('${model.dateTime}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(height: 1.4)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                    ),
                    onPressed: () {})
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: myDivider(),
            ),
            //Post
            Text(
              '${model.text}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            //If Post Have Image
            if (model.postImage != '')
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 15.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 180.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage('${model.postImage}'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            //Row Likes
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.comment,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '0 comments',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Row Comments
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            //Comment
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      //View Comments
                      showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.favorite,color: Colors.red,),
                                      SizedBox(width: 10,),
                                      Text(
                                        '${SocialCubit.get(context).likes[index]}',
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        ' and Other',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Icon(Icons.arrow_forward_ios),
                                      Spacer(),
                                      Icon(Icons.favorite_border),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                myDivider(),
                                SizedBox(height: 10,),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => buildComment(model, context, index,),
                                  separatorBuilder: (context, index) => SizedBox(height: 8.0,),
                                  itemCount: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).userModel.image}'),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                         Text('Write a comment ...',
                              style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                  onTap: () {
                    SocialCubit.get(context)
                        .likePost(SocialCubit.get(context).postsId[index]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildComment(PostModel model, context,index) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 20,
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Mahmoud Ashry',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        'datadnjgoldhngoidbgoihnodfighboigfhoidmnvkodhgdfioshfgiusguigfsdihugiurfhgiufhiuhgiufhgiufbvidfhguignfijbviufgbijgbiufnkdjbnfiudfd;sofjioawpehw',
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 75.0),
        child: Row(
          children: [
            Container(
              child:  Text(
                '4h',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              child:  Text(
                'like',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
