import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/widgets/video_picker_and_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var socialProvider = Provider.of<SocialProvider>(context, listen: true);
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          socialProvider.titles[socialProvider.currentIndex],
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () async {
              if(textController.text.isEmpty && userProvider.postImage == null && userProvider.postVideo == null ){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter text, image or video'),
                    backgroundColor: Colors.blue[800],
                  ),
                );
              }
              else{
                var dateTime = DateTime.now().toString();
                if (userProvider.postImage != null && userProvider.postVideo == null) {
                  await userProvider
                      .uploadPostImage(
                    text: textController.text,
                    tags: [],
                    date: dateTime,
                  )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('successfully create post'),
                        backgroundColor: Colors.blue[800],
                      ),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('error on upload photo'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
                else if (userProvider.postImage == null && userProvider.postVideo != null) {
                  await userProvider
                      .uploadPostVideo(
                    text: textController.text,
                    tags: [],
                    date: dateTime,
                  )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('successfully create post'),
                        backgroundColor: Colors.blue[800],
                      ),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('error on upload photo'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
                else if (textController.text.isNotEmpty && userProvider.postImage == null && userProvider.postVideo == null) {
                  userProvider
                      .createNewPost(
                      text: textController.text,
                      tags: [],
                      date: dateTime,
                      postImage: '',
                      postVideo: '')
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('successfully create post'),
                        backgroundColor: Colors.blue[800],
                      ),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('error on create post'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
              }
            },
            child: Text(
              'Post',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (userProvider.loading) LinearProgressIndicator(),
              if (userProvider.loading) SizedBox(height: 10.0,),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                      '${userProvider.user.userImage}',
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '${userProvider.user.username}',
                    style:Theme.of(context).textTheme.subtitle2
                  ),
                ],
              ),
              TextFormField(
                maxLines: null,
                controller: textController,
                decoration: InputDecoration(
                    hintText: 'what\'s on your mind?',
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.subtitle1
                ),
              ),
              if (userProvider.postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 140.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                              image: FileImage(userProvider.postImage!),
                              fit: BoxFit.cover)),
                    ),
                    ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      //borderRadius: BorderRadius.circular(100.0),
                      child: IconButton(
                        color: Colors.grey,
                        onPressed: () {
                          userProvider.deletePostImage();
                        },
                        icon: Icon(Icons.close,color: Theme.of(context).iconTheme.color,),
                      ),
                    ),
                  ],
                ),
              if (userProvider.postVideo != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: VideoPlayerWidget(isOnlineVideo: false , url: userProvider.postVideo!.path,),
                    ),
                    ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: IconButton(
                        color: Colors.grey,
                        onPressed: () {
                          userProvider.deletePostVideo();
                        },
                        icon: Icon(Icons.close,color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        //await userProvider.pickPostImage(ImageSource.gallery);
                        await userProvider.pickAnyImage(ImageSource.gallery)
                            .then((value){
                          userProvider.postImage = value;
                        }).catchError((onError){
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconBroken.Image,color: Theme.of(context).iconTheme.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('add photo',style:Theme.of(context).textTheme.caption,),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        await userProvider.pickAnyVideo(ImageSource.gallery)
                            .then((value){
                          userProvider.postVideo = value;
                        }).catchError((onError){
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconBroken.Video,color: Theme.of(context).iconTheme.color),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('add video',style:Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: Text('# tags'),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
