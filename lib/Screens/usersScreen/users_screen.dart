import 'package:chat/Screens/chatScreen/chat_screen.dart';
import 'package:chat/modules/friends_model.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/modules/story_model.dart';
import 'package:chat/widgets/story_widget/story_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider,SocialProvider>(
      builder: (context, userProvider,socialProvider, _) {
        return ConditionalBuilder(
          condition: userProvider.myFriends.isNotEmpty,
          builder: (context) => Scaffold(
            appBar: AppBar(
              leadingWidth: 120,
              leading: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: FadeInImage.memoryNetwork(
                      width: 40,
                      height: 40,
                      placeholder: kTransparentImage,
                      image: '${userProvider.user.userImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    socialProvider.titles[socialProvider.currentIndex],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showMaterialModalBottomSheet(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(25.0),
                          topEnd: Radius.circular(25.0),
                        ),
                      ),
                      backgroundColor: Theme.of(context).cardTheme.color,
                      context: context,
                      builder: (context) => Container(
                        height: 150.0,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                userProvider
                                    .pickAnyImage(ImageSource.gallery)
                                    .then((value) {
                                  userProvider.storyFile = value;
                                  userProvider
                                      .uploadMyStory(true, context)
                                      .then((value) {
                                    Navigator.pop(context);
                                    // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>UsersScreen()));
                                  }).catchError((error) {});
                                }).catchError((onError) {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: socialProvider.isDark ? Colors.grey[600] :Colors.grey[200],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(IconBroken.Image,
                                          size: 35,
                                          color:
                                              Theme.of(context).iconTheme.color),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Text('add photo to your story',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                userProvider
                                    .pickAnyVideo(ImageSource.gallery)
                                    .then((value) {
                                  userProvider.storyFile = value;
                                  userProvider
                                      .uploadMyStory(false, context)
                                      .then((value) {
                                    Navigator.pop(context);
                                  }).catchError((error) {});
                                }).catchError((onError) {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color:socialProvider.isDark ? Colors.grey[600] : Colors.grey[200],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(IconBroken.Video,
                                          size: 35,
                                          color:
                                              Theme.of(context).iconTheme.color),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Text('add video to your story',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(IconBroken.Camera),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 120,
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 110,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 25.0,
                                    child: Icon(Icons.video_call_sharp),
                                  ),
                                  Container(
                                    width: 60,
                                    child: Text(
                                      'Create Room',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (userProvider.user.myStory.isNotEmpty)
                            Container(
                              height: 110,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StoryScreen(
                                        stories: userProvider.myStories,
                                        name: userProvider.user.username,
                                        image: userProvider.user.userImage,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      //backgroundColor: Colors.blue[400],
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: FadeInImage.memoryNetwork(
                                          width: 50,
                                          height: 50,
                                          placeholder: kTransparentImage,
                                          image:
                                              '${userProvider.user.myStory[0]['url']}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        '${userProvider.user.username}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        //softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Container(
                            height: 120,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  buildUserStoryItem(
                                      context, userProvider.myFriends[index]),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 10.0,
                              ),
                              itemCount: userProvider.myFriends.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        buildUserItem(context, userProvider.myFriends[index]),
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        height: 1.0,
                      ),
                    ),
                    itemCount: userProvider.myFriends.length,
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: Text(
                'You don\'t have any friend to \n start conversation with him'),
          ),
        );
      },
    );
  }

  Widget buildUserStoryItem(context, FriendsModel myFriend) => InkWell(
        onTap: () {
          Provider.of<UserDataProvider>(context, listen: false).myFriendChat =
              myFriend;
          if (myFriend.myStory.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StoryScreen(
                  stories: myFriend.myStory as List<Story>,
                  name: myFriend.username,
                  image: myFriend.userImage,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Container(
                height: 60,
                child: CircleAvatar(
                  radius: myFriend.myStory.isEmpty ? 25 : 28,
                  //backgroundColor: Colors.blue[400],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: FadeInImage.memoryNetwork(
                      width: 50,
                      height: 50,
                      placeholder: kTransparentImage,
                      image: myFriend.myStory.isEmpty
                          ? '${myFriend.userImage}'
                          : '${myFriend.myStory[0].url}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: 60,
                child: Text(
                  '${myFriend.username}',
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  //softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildUserItem(context, FriendsModel myFriend) => InkWell(
        onTap: () {
          Provider.of<UserDataProvider>(context, listen: false).myFriendChat =
              myFriend;
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ChatScreen()));
        },
        child: Padding(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 7.0, bottom: 7.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: FadeInImage.memoryNetwork(
                  width: 50,
                  height: 50,
                  placeholder: kTransparentImage,
                  image: '${myFriend.userImage}',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '${myFriend.username}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      );
}
