import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/post_widget/full_post_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context,listen: true);
    var social = Provider.of<SocialProvider>(context,listen: true);
    userProvider.getSavedPosts();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color:social.isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          "Saved",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: ConditionalBuilder(
        condition: userProvider.savedPost.isNotEmpty,
        builder: (context)=> ListView.separated(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder:(_)=>FullPostScreen(post:userProvider.savedPost[index])));
              },
              child: Card(
                shadowColor:social.isDark ? Colors.white: Colors.black,
                color:social.isDark ? Colors.grey[600] :Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child:userProvider.savedPost[index].postImage.isNotEmpty?
                        FadeInImage(
                          placeholder: AssetImage('assets/images/loading.gif'),
                          image: NetworkImage(userProvider.savedPost[index].postImage),
                          fit: BoxFit.cover,
                        )
                        :null,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              userProvider.savedPost[index].textBody,
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              userProvider.savedPost[index].username,
                              style: Theme.of(context).textTheme.caption,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              "${userProvider.savedPost[index].comments.length} comments",
                              style: Theme.of(context).textTheme.caption,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          userProvider.deleteSavedPosts(userProvider.savedPost[index].postId)
                              .then((value){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('deleted post'),
                              backgroundColor: Colors.blueAccent,
                            ));
                          })
                              .catchError((e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('error'),
                              backgroundColor: Colors.blueAccent,
                            ));
                          });
                        },
                        child: Icon(
                            Icons.close
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(
            height: 10.0,
          ),
          itemCount: userProvider.savedPost.length,
        ),
        fallback: (context)=>Center(child: Text("There are no posts")),
      ),
    );
  }
}
