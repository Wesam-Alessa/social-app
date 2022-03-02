import 'package:chat/Screens/menuScreen/cards_screens/find_friend_and_friendShip_Requests/find_friends_screen.dart';
import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_main_screen.dart';
import 'package:chat/Screens/profile/edit_your_about_info/edit_your_about_info_screen.dart';
import 'package:chat/modules/friends_model.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:chat/widgets/full_screen_widgets/full_screen_image.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/widgets/post_widget/Posts_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'friend_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            IconBroken.Arrow___Left_2,
            color:social.isDark?Colors.white: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserDataProvider>(builder: (context, userProvider, _) {
          var user = userProvider.user;
          return Hero(
            tag: 'profile',
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (userProvider.loading) LinearProgressIndicator(),
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                if (userProvider.coverImage == null &&
                                    user.coverImage.isEmpty)
                                  Container(
                                    width: double.infinity,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      color:social.isDark ? Colors.grey[700]  : Colors.white ,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                if (userProvider.coverImage == null &&
                                    user.coverImage.isNotEmpty)
                                  GestureDetector(
                                    onTap: ()=>Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_)=>
                                            FullScreenImage(url:user.coverImage),),),
                                    child: Container(
                                      width: double.infinity,
                                      height: 140.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${user.coverImage}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (userProvider.coverImage != null)
                                  Container(
                                    width: double.infinity,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                      image: DecorationImage(
                                        image:
                                            FileImage(userProvider.coverImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await userProvider
                                          .pickAnyImage(ImageSource.gallery)
                                          .then((value) {
                                        userProvider.coverImage = value;
                                        if (userProvider.coverImage != null) {
                                          userProvider
                                              .uploadCoverImage()
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'The profile cover picture has been successfully modified'),
                                                backgroundColor: Colors.blue[800],
                                              ),
                                            );
                                          });
                                        }
                                        else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('No Image Selected'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'The profile cover picture has not been successfully modified'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 18.0,
                                      child: Icon(
                                        IconBroken.Camera,
                                        color: Colors.black,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              if (userProvider.profileImage == null)
                                GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_)=>
                                          FullScreenImage(url:user.userImage),),),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 64,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          NetworkImage('${user.userImage}'),
                                    ),
                                  ),
                                ),
                              if (userProvider.profileImage != null)
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 64,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        FileImage(userProvider.profileImage!),
                                  ),
                                ),
                              if (user.userImage.isEmpty &&
                                  userProvider.profileImage == null)
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 64,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              Positioned(
                                right: 5,
                                bottom: 7,
                                child: GestureDetector(
                                  onTap: () async {
                                    await userProvider
                                        .pickAnyImage(ImageSource.gallery)
                                        .then((value) {
                                      userProvider.profileImage = value;
                                      if (userProvider.profileImage != null) {
                                        userProvider
                                            .uploadProfileImage()
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'The profile picture has been successfully modified'),
                                              backgroundColor: Colors.blue[800],
                                            ),
                                          );
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('No Image Selected'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }).catchError((error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'The profile picture has not been successfully modified'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    radius: 15.0,
                                    child: Icon(
                                      IconBroken.Camera,
                                      color: Colors.black,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${user.username}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${user.userBio}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: social.isDark ? Colors.grey[700] : Colors.blue ,
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(25.0),
                                  topEnd: Radius.circular(25.0),
                                ),
                              ),
                              backgroundColor: social.isDark ? Colors.grey[800] : Colors.grey[300],
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
                                          }).catchError((error) {});
                                        }).catchError((onError) {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color:social.isDark ? Colors.grey[600] : Colors.grey[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(IconBroken.Image,
                                                  size: 35,
                                                  color: Theme.of(context)
                                                      .iconTheme.color),
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
                                            color:social.isDark ? Colors.grey[600] : Colors.grey[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(IconBroken.Video,
                                                  size: 35,
                                                  color: Theme.of(context)
                                                      .iconTheme.color),
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
                          child: Row(
                            children: [
                              Icon(IconBroken.Plus, color: Colors.white),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Add to Story',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        MaterialButton(
                          color:social.isDark ?  Colors.grey[700] :Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditProfileScreen()));
                          },
                          child: Row(
                            children: [
                              Icon(IconBroken.Edit,color:social.isDark ?  Colors.white : Colors.grey[300],),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text('Edit Profile',
                               style: TextStyle(
                                 color: Colors.white
                               ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 10.0,
                        // ),
                        //Expanded(
                        //   child: MaterialButton(
                        //     color: Colors.grey[300],
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(5.0)),
                        //     onPressed: () {},
                        //     child: Icon(Icons.more_horiz),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      color: Colors.grey[300],
                      height: 1.0,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditYourAboutInfoScreen())),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            if (user.details['works at'] != '')
                              Row(
                                children: [
                                  Icon(IconBroken.Work),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'Works at ',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(
                                    '${user.details['works at']}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                            if (user.details['works at'] != '')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (user.details['lives in'] != '')
                              Row(
                                children: [
                                  Icon(IconBroken.Home),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'Live in ',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(
                                    '${user.details['lives in']}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                            if (user.details['lives in'] != '')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (user.details['from'] != '')
                              Row(
                                children: [
                                  Icon(IconBroken.Location),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'From ',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(
                                    '${user.details['from']}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                            if (user.details['from'] != '')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (user.details['college'] != '')
                              Row(
                                children: [
                                  Icon(Icons.school_outlined),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'College',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    '${user.details['education']['college']}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            if (user.details['college'] != '')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (user.details['high school'] != '')
                              Row(
                                children: [
                                  Icon(Icons.account_balance_outlined),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'High School',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    '${user.details['education']['high school']}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            if (user.details['high school'] != '')
                              SizedBox(
                                height: 10.0,
                              ),
                            if (user.details['relationship'] != '')
                              Row(
                                children: [
                                  Icon(IconBroken.Heart),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    '${user.details['relationship']}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            if (user.details['relationship'] != '')
                              SizedBox(
                                height: 10.0,
                              ),
                            Row(
                              children: [
                                Icon(Icons.more_horiz),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'See Your About Info ',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            MaterialButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditProfileScreen())),
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              color:social.isDark ?Colors.grey[600]  :Colors.blue[50] ,
                              child: Text(
                                'Edit Public Details',
                                style: TextStyle(
                                  color:social.isDark ?  Colors.white:Colors.blue[800] ,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      height: 1.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Friends',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FindFriendsScreen())),
                          child: Text(
                            'Find\nFriends',
                            style:!social.isDark ?
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.blue[800],
                                    ):
                            Theme.of(context).textTheme.subtitle1
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.grey[300],
                      height: 1.0,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () async {
                          if (userProvider.user.myFriends
                              .contains(userProvider.myFriends[index].userId)) {
                            FriendsModel newUser = userProvider.myFriends
                                .firstWhere((element) =>
                                    element.userId ==
                                    userProvider.myFriends[index].userId);
                            userProvider.getMyFriendPosts(newUser.userId);
                            await userProvider
                                .getFriendsOfMyFriends(newUser)
                                .then((value) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FriendProfileScreen(
                                    friendsModel: value,
                                  ),
                                ),
                              );
                            });
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Stack(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              children: [
                                Container(
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Colors.white,
                                    ),
                                    child: Image.network(
                                      userProvider.myFriends[index].userImage,
                                      fit: BoxFit.cover,
                                    )),
                                Positioned(
                                  bottom: 2,
                                  left: 2,
                                  right: 2,
                                  child: Container(
                                    color: social.isDark ? Colors.grey[500] :Colors.white.withOpacity(0.7) ,
                                    child: Text(
                                      '${userProvider.myFriends[index].username}',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: userProvider.myFriends.length > 6
                          ? 6
                          : userProvider.myFriends.length,
                    ),
                    social.isDark ?
                      Container(
                      color: Colors.grey[300],
                      height: 10.0,
                    ) :
                    Container(
                      color: Colors.grey[300],
                      height: 5.0,
                    ),
                    ConditionalBuilder(
                      condition: userProvider.myPosts.isNotEmpty,
                      builder: (BuildContext context) => ListView.separated(
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            PostWidget(post: userProvider.myPosts[index]),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 8.0,
                        ),
                        itemCount: userProvider.myPosts.length,
                      ),
                      fallback: (BuildContext context) =>
                          Center(child: Text('There are no posts',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          ),
                    ),
                    SizedBox(
                      height: 8.0,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
