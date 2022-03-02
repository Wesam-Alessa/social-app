import 'package:chat/Screens/profile/profile_screen/friend_profile_screen.dart';
import 'package:chat/modules/friends_model.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/widgets/post_widget/full_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider,SocialProvider>(
      builder: (context, userProvider,social, _) {
        List searchItem = userProvider.searchList;
        return Scaffold(
          backgroundColor:social.isDark?Colors.grey[700]: Colors.grey[350],
          appBar: AppBar(
            leadingWidth: 25,
            leading: IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(IconBroken.Arrow___Left_2,color:social.isDark ? Colors.white: Colors.black,),
            ),
            //titleSpacing: 10,
            title: isSearching
                ? Container(
                    height: 50,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: social.isDark ? Colors.black : Colors.white,
                          //   ),
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          labelText: "search",
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      onChanged: (value) {
                        userProvider.search(controller.text);
                      },
                    ),
                  )
                : null,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching = !isSearching;
                      if(isSearching == false){
                        searchItem = [];
                        userProvider.searchList = [];
                        controller.text = '';
                        setState(() {
                        });
                      }
                    });
                  },
                  child: Icon(!isSearching
                      ? IconBroken.Search
                      : IconBroken.Close_Square),
                ),
              )
            ],
          ),
          body: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async{
                  if (searchItem[index]['type'] == 'friend') {
                    FriendsModel user = userProvider.myFriends.firstWhere(
                            (element) =>
                        element.userId == searchItem[index]['value'].userId);
                    userProvider.getMyFriendPosts(searchItem[index]['value'].userId);
                    await userProvider.getFriendsOfMyFriends(user).then((
                        value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FriendProfileScreen(
                                friendsModel: value,
                              ),
                        ),
                      );
                    });
                  }
                  else if (searchItem[index]['type'] == 'user') {
                    var user = userProvider.allUsers.firstWhere(
                            (element) =>
                        element.userId == searchItem[index]['value'].userId);
                    FriendsModel friend = FriendsModel(
                      user.userId,
                      user.email,
                      user.username,
                      user.userBio,
                      user.userImage,
                      user.coverImage,
                      user.details,
                      user.myFriends,
                      user.myStory,
                    );
                    userProvider.getMyFriendPosts(searchItem[index]['value'].userId);
                    userProvider.getFriendsOfMyFriends(friend).then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FriendProfileScreen(
                            friendsModel: value,
                          ),
                        ),
                      );
                    });
                  }
                  else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              FullPostScreen(post: searchItem[index]['value'])),
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: social.isDark ? Colors.grey[500]:Colors.white ,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        if (searchItem[index]['type'] == 'friend' ||
                            searchItem[index]['type'] == 'user')
                          CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                searchItem[index]['value'].userImage),
                          ),
                        if (searchItem[index]['type'] == 'friend' ||
                            searchItem[index]['type'] == 'user')
                          SizedBox(
                            width: 15,
                          ),
                        if (searchItem[index]['type'] == 'friend' ||
                            searchItem[index]['type'] == 'user')
                          Text(
                            searchItem[index]['value'].username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        if (searchItem[index]['type'] == 'post' &&
                            searchItem[index]['value'].postImage != '')
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    searchItem[index]['value'].postImage),
                              ),
                            ),
                          ),
                        if (searchItem[index]['type'] == 'post')
                          SizedBox(
                            width: 15,
                          ),
                        if (searchItem[index]['type'] == 'post')
                          Flexible(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchItem[index]['value'].username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  searchItem[index]['value'].textBody,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                color: Colors.white,
                height: 1,
              ),
            ),
            itemCount: userProvider.searchList.length,
          ),
        );
      },
    );
  }
}
