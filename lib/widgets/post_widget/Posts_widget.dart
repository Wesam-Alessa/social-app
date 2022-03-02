import 'package:chat/Screens/profile/profile_screen/friend_profile_screen.dart';
import 'package:chat/Screens/profile/profile_screen/profile_screen.dart';
import 'package:chat/modules/comment_model.dart';
import 'package:chat/modules/friends_model.dart';
import 'package:chat/modules/post_model.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/comment_widget/comments_tree.dart';
import 'package:chat/widgets/full_screen_widgets/full_screen_image.dart';
import 'package:chat/widgets/full_screen_widgets/full_screen_video.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/widgets/image_picker/image_picker_widget.dart';
import 'package:chat/widgets/share_widget/share_widget.dart';
import 'package:chat/widgets/video_picker_and_player/video_picker_widget.dart';
import 'package:chat/widgets/voice_picker_and_player_widgets/player.dart';
import 'package:chat/widgets/voice_picker_and_player_widgets/voice_recorder_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final _commentController = TextEditingController();
  String _textComment = '';
  bool seeMore = false;
  String textButton = 'send';

  @override
  void initState(){
    super.initState();
    Provider.of<UserDataProvider>(context,listen: false).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider,SocialProvider>(
      builder: (context, userProvider,social, _) {
        return Card(
          color: Theme.of(context).cardTheme.color,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                        if (widget.post.userId == userProvider.user.userId) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(),
                            ),
                          );
                        }
                        else if (userProvider.user.myFriends.contains(widget.post.userId)) {
                          FriendsModel user = userProvider.myFriends.firstWhere(
                                  (element) =>
                              element.userId == widget.post.userId);
                          userProvider.getMyFriendPosts(widget.post.userId);
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
                      else {
                        if (userProvider.allUsers.isEmpty) {
                          userProvider.getAllUsers().then((value) {
                            var user = userProvider.allUsers.firstWhere(
                                (element) =>
                                    element.userId == widget.post.userId);
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
                            userProvider.getMyFriendPosts(widget.post.userId);
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
                          });
                        }
                        else {
                          var user = userProvider.allUsers.firstWhere(
                              (element) =>
                                  element.userId == widget.post.userId);
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
                          userProvider.getMyFriendPosts(widget.post.userId);
                          userProvider.getFriendsOfMyFriends(friend).then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FriendProfileScreen(
                                  friendsModel: friend,
                                ),
                              ),
                            );
                          });
                        }
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: FadeInImage.memoryNetwork(
                        width: 40,
                        height: 40,
                        placeholder: kTransparentImage,
                        image: '${widget.post.userImage}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.post.username}',
                              style:Theme.of(context).textTheme.subtitle1
                              //TextStyle(height: 1.4),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).iconTheme.color,
                              size: 16.0,
                            ),
                          ],
                        ),
                        Text(
                          '${DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.parse(widget.post.dateTime))}',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
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
                        context: context,
                        builder: (context) => Container(
                          height: 150.0,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (userProvider.user.saved
                                      .contains(widget.post.postId)) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'This post has already been saved'),
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('saved post'),
                                      backgroundColor: Colors.blueAccent,
                                    ));
                                    userProvider.user.saved
                                        .add(widget.post.postId);
                                    userProvider
                                        .updateSavedPosts(
                                            userProvider.user.saved)
                                        .then((value) {})
                                        .catchError((onError) {
                                      // Navigator.pop(context);
                                      userProvider.user.saved
                                          .remove(widget.post.postId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'An error occurred while saving the post'),
                                        backgroundColor: Colors.blueAccent,
                                      ));
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.save_outlined,
                                          size: 35,
                                          color: Theme.of(context).iconTheme.color,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text('Save Post',
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
                                  if (userProvider.user.hiddenPost
                                      .contains(widget.post.postId)) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'This post has already been hide'),
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                    );
                                  }
                                  else if(widget.post.userId == userProvider.user.userId){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Post has been deleted'),
                                      backgroundColor: Colors.blueAccent,
                                    ));
                                    userProvider
                                        .deletePost(widget.post.postId)
                                        .then((value) {})
                                        .catchError((onError) {
                                      // userProvider.user.saved
                                      //     .remove(widget.post.postId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'An error occurred while delete the post'),
                                        backgroundColor: Colors.blueAccent,
                                      ));
                                    });
                                  }
                                  else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Post has been hidden'),
                                      backgroundColor: Colors.blueAccent,
                                    ));
                                    userProvider
                                        .hidePost(widget.post.postId)
                                        .then((value) {})
                                        .catchError((onError) {
                                      userProvider.user.saved
                                          .remove(widget.post.postId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'An error occurred while hiding the post'),
                                        backgroundColor: Colors.blueAccent,
                                      ));
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          widget.post.userId == userProvider.user.userId ?
                                          IconBroken.Delete
                                              :
                                          IconBroken.Hide,
                                          size: 35,
                                          color: Theme.of(context).iconTheme.color,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                            widget.post.userId == userProvider.user.userId ?
                                            'Delete Post'
                                            :
                                            'Hide Post',
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
                    icon: Icon(
                      Icons.more_horiz,
                      size: 18.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  height: 1.0,
                ),
              ),
              if (widget.post.textBody != '')
                Align(
                  alignment: Alignment.topLeft,
                  child: widget.post.textBody.length < 60
                      ? SelectableText(
                          '${widget.post.textBody}',
                          style: Theme.of(context).textTheme.subtitle1,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                        )
                      : SelectableText(
                          '${widget.post.textBody}',
                          style: Theme.of(context).textTheme.subtitle1,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          maxLines: seeMore ? null : 3,
                          onTap: () {
                            setState(() {
                              seeMore = !seeMore;
                            });
                          },
                        ),
                ),
              if (widget.post.postTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 5.0),
                          child: Container(
                            height: 20.0,
                            child: MaterialButton(
                              minWidth: 1.0,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Text(
                                "${widget.post.postTags}",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.post.postImage != '')
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FullScreenImage(
                                url: '${widget.post.postImage}')));
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 140.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/loading.gif",
                        image: '${widget.post.postImage}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (widget.post.postVideo != '')
                Builder(
                  builder: (context) {
                    VideoPlayerController? _videoController;
                    _videoController = VideoPlayerController.network(
                      '${widget.post.postVideo}',
                    )..initialize().then((_) {});
                    return Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        height: 140.0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenVideo(
                                url: '${widget.post.postVideo}',
                                isOnline: true,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              VideoPlayer(_videoController),
                              Center(
                                child: Icon(
                                  IconBroken.Play,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              size: 20.0,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${widget.post.likes.length}',
                              style: Theme.of(context).textTheme.caption,
                            )
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
                              IconBroken.Chat,
                              size: 20.0,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${widget.post.comments.length} comment',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: FadeInImage.memoryNetwork(
                            width: 30,
                            height: 30,
                            placeholder: kTransparentImage,
                            image: '${userProvider.user.userImage}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            var height = MediaQuery.of(context).size.height;
                            userProvider.nullAllValues();
                            showMaterialModalBottomSheet(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(25.0),
                                  topEnd: Radius.circular(25.0),
                                ),
                              ),
                              context: context,
                              backgroundColor: social.isDark ? Colors.grey[800] : Colors.white,
                              builder: (ctx) => Consumer2<UserDataProvider,SocialProvider>(
                                builder: (context, value,socialValue, _) => Container(
                                  height: height - 30,
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Scaffold(
                                    body: SafeArea(
                                      child: Column(
                                        children: [
                                          if (widget.post.comments.length > 0)
                                            Expanded(
                                              child: ListView.separated(
                                                reverse: true,
                                                itemCount:
                                                    widget.post.comments.length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(
                                                  height: 10.0,
                                                ),
                                                itemBuilder:
                                                    (context, commentIndex) {
                                                  List<CommentModel>
                                                      replayComments = [];
                                                  CommentModel comment =
                                                      CommentModel(
                                                    id: widget.post.comments[
                                                        commentIndex]['id'],
                                                    commentType:
                                                        widget.post.comments[
                                                                commentIndex]
                                                            ['comment_type'],
                                                    replyComments:
                                                        widget.post.comments[
                                                                commentIndex]
                                                            ['replyComments'],
                                                    userName: widget
                                                                .post.comments[
                                                            commentIndex]
                                                        ['body']['userName'],
                                                    userImage: widget
                                                                .post.comments[
                                                            commentIndex]
                                                        ['body']['userImage'],
                                                    text: widget.post.comments[
                                                                commentIndex]
                                                            ['body']
                                                        ['commentBody']['text'],
                                                    image: widget.post.comments[
                                                                commentIndex]
                                                            ['body'][
                                                        'commentBody']['image'],
                                                    video: widget.post.comments[
                                                                commentIndex]
                                                            ['body'][
                                                        'commentBody']['video'],
                                                    voice: widget.post.comments[
                                                                commentIndex]
                                                            ['body'][
                                                        'commentBody']['voice'],
                                                    dateTime: widget
                                                                .post.comments[
                                                            commentIndex]
                                                        ['body']['dateTime'],
                                                    likes: widget.post.comments[
                                                            commentIndex]
                                                        ['body']['likes'],
                                                    body: widget.post.comments[
                                                            commentIndex]
                                                        ['body']['commentBody'],
                                                  );
                                                  comment.replyComments.forEach(
                                                    (element) {
                                                      replayComments.add(
                                                        CommentModel(
                                                          id: element['id'],
                                                          commentType: element[
                                                              'comment_type'],
                                                          replyComments: [],
                                                          userName:
                                                              element['body']
                                                                  ['userName'],
                                                          userImage:
                                                              element['body']
                                                                  ['userImage'],
                                                          text: element['body'][
                                                                  'commentBody']
                                                              ['text'],
                                                          image: element['body']
                                                                  [
                                                                  'commentBody']
                                                              ['image'],
                                                          video: element['body']
                                                                  [
                                                                  'commentBody']
                                                              ['video'],
                                                          voice: element['body']
                                                                  [
                                                                  'commentBody']
                                                              ['voice'],
                                                          dateTime:
                                                              element['body']
                                                                  ['dateTime'],
                                                          likes: element['body']
                                                              ['likes'],
                                                          body: element['body']
                                                              ['commentBody'],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  return CommentsTree(
                                                      post: widget.post,
                                                      comment: comment,
                                                      comments: replayComments);
                                                },
                                              ),
                                            ),
                                          if (widget.post.comments.length < 1)
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(IconBroken.Shield_Fail),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text('No Comments ...'),
                                                ],
                                              ),
                                            ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          if (userProvider
                                                              .isReplayComment)
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    'Reply to ${widget.post.comments[userProvider.commentIndex]['body']['userName']}',
                                                                    style: socialValue.isDark ?
                                                                    TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,color: Colors.white):TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.bold,color: Colors.black)),

                                                                GestureDetector(
                                                                  onTap: () {
                                                                    userProvider
                                                                        .deleteCommentIndexAndReplay();
                                                                  },
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: 14,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextField(
                                                            autocorrect: true,
                                                            enableSuggestions: true,
                                                            textCapitalization: TextCapitalization.sentences,
                                                            controller: _commentController,
                                                            decoration: InputDecoration(
                                                              enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: social.isDark ? Colors.white : Colors.black,
                                                                ),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              labelText: 'Write a comment...',
                                                              labelStyle: social.isDark ? TextStyle(color:Colors.white):TextStyle(color:Colors.black)
                                                            ),
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  _textComment =
                                                                      value;
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    userProvider
                                                                        .changeOpenImagePickerCommentContainer();
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  IconBroken
                                                                      .Camera,
                                                                  size: 22,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 12.0,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    userProvider
                                                                        .changeOpenVideoPickerCommentContainer();
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  IconBroken
                                                                      .Video,
                                                                  size: 22,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 12.0,
                                                              ),
                                                              VoiceRecorderWidget(),
                                                              if (userProvider
                                                                  .isRecordingVoiceMessage)
                                                                Container(
                                                                  width: 100,
                                                                  height: 50,
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/recording.gif',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              Spacer(),
                                                              if (userProvider.messageVoiceFile != null
                                                                  || userProvider.commentImage != null
                                                                  || userProvider.commentVideo != null
                                                                  || userProvider.replayCommentVideo != null)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    userProvider
                                                                        .deleteMessageVoiceFile();
                                                                  },
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              userProvider
                                                                      .loading
                                                                  ? CircularProgressIndicator()
                                                                  : IconButton(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      icon: Icon(
                                                                          Icons
                                                                              .send),
                                                                      onPressed:
                                                                          () async {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        if (userProvider
                                                                            .isReplayComment) {
                                                                          if (_textComment.isEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            return null;
                                                                          } else if (_textComment.isNotEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newReplyTextComment(post: widget.post, text: _textComment, commentIndex: userProvider.commentIndex).then((value) {
                                                                              print('success');
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                            }).catchError((error) {
                                                                              print('field');
                                                                            });
                                                                          } else if (_textComment.isEmpty &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.commentImage != null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newReplyCommentPictureOnPost(post: widget.post, commentIndex: userProvider.commentIndex).then((value) {
                                                                              print('success replay comment picture');
                                                                            }).catchError((error) {
                                                                              print('error replay comment picture');
                                                                            });
                                                                          } else if (_textComment.isEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.replayCommentVideo != null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newReplyVideoCommentOnPost(post: widget.post, commentIndex: userProvider.commentIndex).then((value) {
                                                                              print('success comment video');
                                                                            }).catchError((error) {
                                                                              print('error comment video');
                                                                            });
                                                                          } else if (_textComment.isNotEmpty &&
                                                                              userProvider.commentImage != null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newReplayTextAndPictureCommentOnPost(post: widget.post, text: _textComment, commentIndex: userProvider.commentIndex).then((value) {
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                              print('success comment image and text');
                                                                            }).catchError((error) {
                                                                              print('error comment image and text');
                                                                            });
                                                                          } else if (_textComment.isNotEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.replayCommentVideo != null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newReplayTextAndVideoCommentOnPost(post: widget.post, text: _textComment, commentIndex: userProvider.commentIndex).then((value) {
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                              print('success comment image and text');
                                                                            }).catchError((error) {
                                                                              print('error comment image and text');
                                                                            });
                                                                          } else if (_textComment.isEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.messageVoiceFile != null) {
                                                                            await userProvider.newReplyVoiceComment(post: widget.post, voiceCommentUrl: userProvider.messageVoiceFile!.path, voiceFile: userProvider.messageVoiceFile!, commentIndex: userProvider.commentIndex).then((value) {
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                              print('success voice comment ');
                                                                            }).catchError((error) {
                                                                              print('error voice comment ');
                                                                            });
                                                                          }
                                                                        }
                                                                        else {
                                                                          if (_textComment.isEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            return null;
                                                                          } else if (_textComment.isNotEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newTextCommentOnPost(post: widget.post, text: _textComment).then((value) {
                                                                              print('success');
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                            }).catchError((error) {
                                                                              print('field');
                                                                            });
                                                                          } else if (_textComment.isEmpty &&
                                                                              userProvider.commentImage != null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newCommentPictureOnPost(post: widget.post).then((value) {
                                                                              print('success comment picture');
                                                                            }).catchError((error) {
                                                                              print('error comment picture');
                                                                            });
                                                                          } else if (_textComment.isEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo != null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newVideoCommentOnPost(post: widget.post).then((value) {
                                                                              print('success comment video');
                                                                            }).catchError((error) {
                                                                              print('error comment video');
                                                                            });
                                                                          } else if (_textComment.isNotEmpty &&
                                                                              userProvider.commentImage != null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newTextAndPictureCommentOnPost(post: widget.post, text: _textComment).then((value) {
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                              print('success comment image and text');
                                                                            }).catchError((error) {
                                                                              print('error comment image and text');
                                                                            });
                                                                          } else if (_textComment.isNotEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo != null &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.messageVoiceFile == null) {
                                                                            await userProvider.newTextAndVideoCommentOnPost(post: widget.post, text: _textComment).then((value) {
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                              print('success comment image and text');
                                                                            }).catchError((error) {
                                                                              print('error comment image and text');
                                                                            });
                                                                          } else if (_textComment.isEmpty &&
                                                                              userProvider.commentImage == null &&
                                                                              userProvider.commentVideo == null &&
                                                                              userProvider.replayCommentVideo == null &&
                                                                              userProvider.messageVoiceFile != null) {
                                                                            await userProvider
                                                                                .newVoiceCommentOnPost(
                                                                              post: widget.post,
                                                                              voiceCommentUrl: userProvider.messageVoiceFile!.path,
                                                                              voiceFile: userProvider.messageVoiceFile!,
                                                                            )
                                                                                .then((value) {
                                                                              _textComment = '';
                                                                              _commentController.clear();
                                                                              print('success voice comment ');
                                                                            }).catchError((error) {
                                                                              print('error voice comment ');
                                                                            });
                                                                          }
                                                                        }
                                                                      }),
                                                            ],
                                                          ),
                                                          if (userProvider
                                                                  .commentImage !=
                                                              null)
                                                            Consumer<
                                                                UserDataProvider>(
                                                              builder: (context,
                                                                  value, _) {
                                                                return Container(
                                                                    height:
                                                                        100.0,
                                                                    clipBehavior:
                                                                        Clip
                                                                            .antiAlias,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15.0),),
                                                                    ),
                                                                    child: Image.file(
                                                                        userProvider
                                                                            .commentImage!),);
                                                              },
                                                            ),
                                                          if (userProvider
                                                              .openImagePickerCommentContainer)
                                                            Consumer<
                                                                UserDataProvider>(
                                                              builder: (context,
                                                                  value, _) {
                                                                return Container(
                                                                  height: 60.0,
                                                                  child:
                                                                      ImagePickerWidget(),
                                                                );
                                                              },
                                                            ),
                                                          if (userProvider
                                                                  .openVideoPickerCommentContainer &&
                                                              userProvider
                                                                      .isReplayComment ==
                                                                  false)
                                                            Consumer<
                                                                UserDataProvider>(
                                                              builder: (context,
                                                                  value, _) {
                                                                return Container(
                                                                  height:
                                                                      userProvider.commentVideo !=
                                                                              null
                                                                          ? 180
                                                                          : 60,
                                                                  width: double
                                                                      .infinity,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                  ),
                                                                  child:
                                                                      VideoPickerWidget(
                                                                    isReplay:
                                                                        false,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          if (userProvider
                                                                  .openVideoPickerCommentContainer &&
                                                              userProvider
                                                                      .isReplayComment ==
                                                                  true)
                                                            Consumer<
                                                                UserDataProvider>(
                                                              builder: (context,
                                                                  value, _) {
                                                                return Container(
                                                                  height:
                                                                      userProvider.replayCommentVideo !=
                                                                              null
                                                                          ? 180
                                                                          : 60,
                                                                  width: double
                                                                      .infinity,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                  ),
                                                                  child:
                                                                      VideoPickerWidget(
                                                                    isReplay:
                                                                        true,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          if (userProvider
                                                                  .messageVoiceFile !=
                                                              null)
                                                            Consumer<
                                                                UserDataProvider>(
                                                              builder: (context,
                                                                  value, _) {
                                                                return Container(
                                                                    decoration: BoxDecoration(
                                                                      color: social.isDark ? Colors.white : Colors.grey,
                                                                      borderRadius: BorderRadius.all(Radius.circular(15.0),)
                                                                      // only(
                                                                      //   topLeft: Radius.circular(15.0),
                                                                      //   topRight: Radius.circular(15.0),
                                                                      // ),
                                                                    ),
                                                                    child:
                                                                        AudioPlayerWidget(
                                                                      url: userProvider
                                                                          .messageVoiceFile!
                                                                          .path,
                                                                    ),
                                                                );
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'write a comment ...',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await userProvider
                          .likeOnPost(post: widget.post)
                          .then((value) {})
                          .catchError((error) {});
                    },
                    child: Row(
                      children: [
                        Icon(
                          widget.post.likes.contains(userProvider.user.userId)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ShareWidget(postId: widget.post.postId),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          size: 20.0,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Share',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      },
    );
  }

}
