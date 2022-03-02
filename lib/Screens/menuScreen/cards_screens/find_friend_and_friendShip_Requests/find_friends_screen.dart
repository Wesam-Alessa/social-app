import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({Key? key}) : super(key: key);

  @override
  _FindFriendsScreenState createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider,SocialProvider>(
      builder: (context, userProvider,social, _) {
        var users = userProvider.allUsers;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                IconBroken.Arrow___Left,
                color:social.isDark ? Colors.white: Colors.black,
              ),
            ),
            title: currentIndex == 0
                ? Text(
                    'Friends',
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                : currentIndex == 1
                    ? Text(
                        'Requests',
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    : Text(
                        'Sent Requests',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
          ),
          body: currentIndex == 0
              ? RefreshIndicator(
                  onRefresh: () => userProvider.getAllUsers(),
                  child: ConditionalBuilder(
                      condition: userProvider.allUsers.isNotEmpty,
                      builder: (context) => ListView.separated(
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 7.0,
                                  bottom: 7.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: FadeInImage.memoryNetwork(
                                      width: 70,
                                      height: 70,
                                      placeholder: kTransparentImage,
                                      image: '${users[index].userImage}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${users[index].username}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                      Row(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              userProvider
                                                  .addFriend(
                                                      receiverId:
                                                          users[index].userId)
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text('added friend'),
                                                    backgroundColor:
                                                        Colors.blue[800],
                                                  ),
                                                );
                                                setState(() {});
                                              }).catchError((onError) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'failed add friend'),
                                                    backgroundColor:
                                                        Colors.blue[800],
                                                  ),
                                                );
                                                setState(() {});
                                              });
                                            },
                                            color: Colors.blue[700],
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text('Add Friend'),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          MaterialButton(
                                            color: Colors.grey[300],
                                            textColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            onPressed: () {
                                              userProvider
                                                  .deleteUserFromAllUsers(
                                                      id: users[index].userId);
                                              setState(() {});
                                            },
                                            child: Text('Remove'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                            itemCount: userProvider.allUsers.length,
                          ),
                      fallback: (context) => Center(child: Text("Loading..."))),
                )
              : currentIndex == 1
                  ? RefreshIndicator(
                      onRefresh: () => userProvider.getAllUsers(),
                      child: ConditionalBuilder(
                        condition: userProvider
                            .usersIncomingFriendshipRequests.isNotEmpty,
                        builder: (context) => ListView.separated(
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 7.0, bottom: 7.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: FadeInImage.memoryNetwork(
                                    width: 70,
                                    height: 70,
                                    placeholder: kTransparentImage,
                                    image:
                                        '${userProvider.usersIncomingFriendshipRequests[index].userImage}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '${userProvider.usersIncomingFriendshipRequests[index].username}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          MaterialButton(
                                            color: Colors.blue[700],
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            onPressed: () {
                                              userProvider
                                                  .acceptFriendRequest(
                                                      request: userProvider.user
                                                              .friendshipRequests[
                                                          index])
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Accept friend request '),
                                                    backgroundColor:
                                                        Colors.blue[800],
                                                  ),
                                                );
                                                setState(() {});
                                              }).catchError((onError) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed Accept friend request'),
                                                    backgroundColor:
                                                        Colors.blue[800],
                                                  ),
                                                );
                                                setState(() {});
                                              });
                                            },
                                            child: Text('Accept'),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          MaterialButton(
                                            color: Colors.grey[300],
                                            textColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            onPressed: () {
                                              userProvider
                                                  .deleteFriendRequest(
                                                      request: userProvider.user
                                                              .friendshipRequests[
                                                          index])
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'removed friend request'),
                                                    backgroundColor:
                                                        Colors.blue[800],
                                                  ),
                                                );
                                                setState(() {});
                                              }).catchError((onError) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed remove friend request'),
                                                    backgroundColor:
                                                        Colors.blue[800],
                                                  ),
                                                );
                                                setState(() {});
                                              });
                                            },
                                            child: Text('Remove'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                          itemCount: userProvider
                              .usersIncomingFriendshipRequests.length,
                        ),
                        fallback: (context) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconBroken.User,
                                size: 75,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text('No friendship requests')
                            ],
                          ),
                        ),
                      ),
                    )
                  : currentIndex == 2
                      ? RefreshIndicator(
                          onRefresh: () => userProvider.getAllUsers(),
                          child: ConditionalBuilder(
                              condition: userProvider
                                  .usersOutgoingFriendshipRequests.isNotEmpty,
                              builder: (context) => ListView.separated(
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 7.0,
                                          bottom: 7.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            child: FadeInImage.memoryNetwork(
                                              width: 70,
                                              height: 70,
                                              placeholder: kTransparentImage,
                                              image:
                                                  '${userProvider.usersOutgoingFriendshipRequests[index].userImage}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${userProvider.usersOutgoingFriendshipRequests[index].username}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: MaterialButton(
                                                        color: Colors.grey[300],
                                                        textColor: Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        onPressed: () {
                                                          userProvider
                                                              .deleteFriendRequest(
                                                                  request: userProvider
                                                                          .user
                                                                          .friendshipRequests[
                                                                      index])
                                                              .then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'removed friend request sent'),
                                                                backgroundColor:
                                                                    Colors.blue[
                                                                        800],
                                                              ),
                                                            );
                                                            setState(() {});
                                                          }).catchError(
                                                                  (onError) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Failed remove friend request sent'),
                                                                backgroundColor:
                                                                    Colors.blue[
                                                                        800],
                                                              ),
                                                            );
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        height: 1.0,
                                      ),
                                    ),
                                    itemCount: userProvider
                                        .usersOutgoingFriendshipRequests.length,
                                  ),
                              fallback: (context) => Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          IconBroken.Add_User,
                                          size: 75,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                            'There are no friend requests sent'),
                                      ],
                                    ),
                                  )),
                        )
                      : Container(),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: [
              IconBroken.User1,
              IconBroken.User,
              IconBroken.Add_User,
            ],
            activeIndex: currentIndex,
            gapWidth: 1,
            // activeColor: Colors.blue,
            activeColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            inactiveColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
