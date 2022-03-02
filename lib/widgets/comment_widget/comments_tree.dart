import 'package:chat/modules/comment_model.dart';
import 'package:chat/modules/post_model.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/full_screen_widgets/full_screen_image.dart';
import 'package:chat/widgets/full_screen_widgets/full_screen_video.dart';
import 'package:chat/widgets/voice_picker_and_player_widgets/player.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CommentsTree extends StatefulWidget {
  final PostModel post;
  final CommentModel comment;
  final List<CommentModel> comments;

  const CommentsTree(
      {Key? key,
      required this.post,
      required this.comment,
      required this.comments})
      : super(key: key);

  @override
  State<CommentsTree> createState() => _CommentsTreeState();
}

class _CommentsTreeState extends State<CommentsTree> {
  final _commentController = TextEditingController();
  String _textComment = '';
  bool isReplayComment = false;
  bool seeMore = false;
  List<CommentModel> comments = [];
  var timeNow;
  String replyTimeNow = '';

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider,SocialProvider>(
      builder: (context, userProvider,social, _) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: CommentTreeWidget<CommentModel, CommentModel>(
                widget.comment,
                comments,
                treeThemeData:
                    TreeThemeData(lineColor:social.isDark?Colors.blue: Colors.green[300]!, lineWidth: 3),
                // MY COMMENT
                avatarRoot: (context, data) {
                  timeNow = DateTime.now()
                      .difference(DateTime.parse(data.dateTime))
                      .toString();
                  if (timeNow != "0") {
                    var i = timeNow.indexOf(':');
                    var timeNow1 = timeNow.substring(0, i);
                    var hours = double.parse(timeNow1);
                    if (hours >= 24) {
                      hours = (hours / 24);
                      timeNow1 = '${hours.toInt().toString()}d';
                    } else if (hours >= 1 && hours < 24) {
                      timeNow1 = '${hours.toInt().toString()}h';
                    } else if (hours < 1) {
                      timeNow1 = "${timeNow.substring(i + 1, i + 3)}m";
                    }
                    timeNow = timeNow1;
                  }
                  return PreferredSize(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(data.userImage),
                    ),
                    preferredSize: const Size.fromRadius(18),
                  );
                },
                contentRoot: (context, data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color:social.isDark ? Colors.grey[700]: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.userName,
                            style: Theme.of(context)
                                .textTheme
                              .subtitle2!.copyWith(fontWeight: FontWeight.w600,)
                                //.caption!
                            //     .copyWith(
                            //         fontSize: 16,
                            //
                            //         //color: Colors.black
                            // ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          if (data.commentType == 'text')
                            SelectableText(
                              data.text,
                              style: Theme.of(context)
                                  .textTheme
                                .subtitle1!.copyWith(fontWeight: FontWeight.w300,)
                            //       .caption!
                            //       .copyWith(
                            //           fontSize: 14,
                            //
                            //           color: Colors.black),
                              ),

                          if (data.commentType == 'record')
                            AudioPlayerWidget(url: data.voice),

                          if (data.commentType == 'picture')
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FullScreenImage(url: data.image),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(top: 5.0),
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Image.network(
                                    data.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                          if (data.commentType == 'video')
                            Builder(
                              builder: (context) {
                                VideoPlayerController? _videoController;
                                _videoController =
                                    VideoPlayerController.network(
                                  data.video,
                                )..initialize().then((_) {});
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
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
                                            url: data.video,
                                            isOnline: true,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          VideoPlayer(_videoController),
                                          const Center(
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
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

                          if (data.commentType == 'text and picture')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  data.text,
                                  style: Theme.of(context)
                                      .textTheme
                                    .subtitle1!.copyWith(fontWeight: FontWeight.w300,)
                                      // .caption!
                                      // .copyWith(
                                      //     fontSize: 14,
                                      //
                                      //     color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FullScreenImage(url: data.image),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        top: 5.0),
                                    child: Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Image.network(
                                        data.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          if (data.commentType == 'text and video')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  data.text,
                                  style: Theme.of(context)
                                      .textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w300,)
                                      // .caption!
                                      // .copyWith(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w300,
                                      //     color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Builder(
                                  builder: (context) {
                                    VideoPlayerController? _videoController;
                                    _videoController =
                                        VideoPlayerController.network(
                                      data.video,
                                    )..initialize().then((_) {});
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: double.infinity,
                                        height: 140.0,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => FullScreenVideo(
                                                url: data.video,
                                                isOnline: true,
                                              ),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              VideoPlayer(_videoController),
                                              const Center(
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
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
                              ],
                            ),
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: GestureDetector(
                              onTap: widget.comments.isNotEmpty
                                  ? () {
                                      setState(() {
                                        seeMore = !seeMore;
                                        if (seeMore) {
                                          comments = widget.comments;
                                        } else {
                                          comments = [];
                                        }
                                      });
                                    }
                                  : () {},
                              child: Text(
                                widget.comments.isEmpty
                                    ? "no replies"
                                    : seeMore
                                        ? 'See less replies '
                                        : 'See more replies ',
                                style: widget.comments.isNotEmpty
                                    ?
                                Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,)
                                    :
                                Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Text(timeNow,style: social.isDark?
                                  TextStyle(color: Colors.white):TextStyle(color: Colors.grey),),
                                SizedBox(
                                  width: 8,
                                ),
                                if (data.likes.isNotEmpty)
                                  Text(
                                    '${data.likes.length}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                Icon(
                                  data.likes.contains(userProvider.user.userId)
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    userProvider
                                        .likeOnCommentInPost(
                                            post: widget.post,
                                            commentId: data.id,
                                            commentBody: data.dateTime)
                                        .then((value) {})
                                        .catchError((error) {
                                      print(error.toString());
                                    });
                                  },
                                  child: Text('Like',style:social.isDark?
                                  TextStyle(color: Colors.white):TextStyle(color: Colors.grey),),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    var index =
                                    widget.post.comments.indexWhere((element) => element['body']['dateTime'] == data.dateTime);
                                    userProvider.changeReplayComment(!userProvider.isReplayComment,index);
                                  },
                                  child: Text('Reply',style: social.isDark?
                                  TextStyle(color: Colors.white):TextStyle(color: Colors.grey),),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                //--------------------------------------------------------------------
                // REPLAY COMMENT

                avatarChild: (context, data) {
                  if (seeMore) {
                    return PreferredSize(
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(data.userImage),
                      ),
                      preferredSize: const Size.fromRadius(12),
                    );
                  }
                  else {
                    return PreferredSize(
                      child: Container(),
                      preferredSize: const Size.fromRadius(0),
                    );
                  }
                },
                contentChild: (context, data) {
                  if (seeMore) {
                    replyTimeNow = DateTime.now().difference(DateTime.parse(data.dateTime)).toString();
                    if (replyTimeNow != "0") {
                      var i = replyTimeNow.indexOf(':');
                      var replyTimeNow1 = replyTimeNow.substring(0, i);
                      var hours = double.parse(replyTimeNow1);
                      if (hours >= 24) {
                        hours = (hours / 24);
                        replyTimeNow1 = '${hours.toInt().toString()}d';
                      } else if (hours >= 1 && hours < 24) {
                        replyTimeNow1 = '${hours.toInt().toString()}h';
                      } else if (hours < 1) {
                        replyTimeNow1 =
                        "${replyTimeNow.substring(i + 1, i + 3)}m";
                      }
                      replyTimeNow = replyTimeNow1;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color:social.isDark ? Colors.grey[700] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.userName,
                                style: Theme.of(context)
                                    .textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600,)
                                    // .caption!
                                    // .copyWith(
                                    //     fontSize: 16,
                                    //     color: Colors.black),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              if (data.commentType == 'text')
                                SelectableText(
                                  data.text,
                                  style: Theme.of(context)
                                      .textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w300,)
                                      // .caption!
                                      // .copyWith(
                                      //     fontSize: 14,
                                      //
                                      //     color: Colors.black),
                                ),
                              if (data.commentType == 'picture')
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImage(
                                            url: widget.comment.image),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        top: 5.0),
                                    child: Container(
                                      width: double.infinity,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Image.network(
                                        data.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              if (data.commentType == 'video')
                                Builder(
                                  builder: (context) {
                                    VideoPlayerController? _videoController;
                                    _videoController =
                                        VideoPlayerController.network(
                                      data.video,
                                    )..initialize().then((_) {});
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: double.infinity,
                                        height: 140.0,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      FullScreenVideo(
                                                        url: data.video,
                                                        isOnline: true,
                                                      ))),
                                          child: Stack(
                                            children: [
                                              VideoPlayer(_videoController),
                                              const Center(
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
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
                              if (data.commentType == 'text and picture')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      data.text,
                                      style: Theme.of(context)
                                          .textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w300,)
                                          // .textTheme
                                          // .caption!
                                          // .copyWith(
                                          //     fontSize: 14,
                                          //     fontWeight: FontWeight.w300,
                                          //     color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => FullScreenImage(
                                                    url: data.image)));
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                top: 5.0),
                                        child: Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Image.network(
                                            data.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (data.commentType == 'text and video')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      data.text,
                                      style: Theme.of(context)
                                          .textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w300,)
                                          // .textTheme
                                          // .caption!
                                          // .copyWith(
                                          //     fontSize: 14,
                                          //     fontWeight: FontWeight.w300,
                                          //     color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Builder(
                                      builder: (context) {
                                        VideoPlayerController? _videoController;
                                        _videoController =
                                            VideoPlayerController.network(
                                          data.video,
                                        )..initialize().then((_) {});
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: double.infinity,
                                            height: 140.0,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      FullScreenVideo(
                                                    url: data.video,
                                                    isOnline: true,
                                                  ),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  VideoPlayer(_videoController),
                                                  const Center(
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
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
                                  ],
                                ),
                            ],
                          ),
                        ),
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children:  [
                                Text(replyTimeNow,
                                  style: social.isDark ?
                                TextStyle(color: Colors.white)
                                    :
                                TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                if (data.likes.isNotEmpty)
                                  Text(
                                    '${data.likes.length}',
                                    style:
                                    Theme.of(context).textTheme.subtitle1,
                                  ),
                                Icon(
                                  data.likes.contains(userProvider.user.userId)
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                    onTap:(){
                                      var index =
                                      widget.post.comments.indexWhere((element) => element['body']['dateTime'] == widget.comment.dateTime);
                                      var replayIndex = comments.indexWhere((element) => element.dateTime == data.dateTime );
                                      userProvider.likeOnReplyComment(
                                           post: widget.post,
                                           commentIndex: index,
                                           replyCommentIndex: replayIndex)
                                           .then((value) {

                                       }).catchError((error) {

                                       });
                                    },
                                    child: Text('Like', style: social.isDark ?
                                    TextStyle(color: Colors.white)
                                        :
                                    TextStyle(color: Colors.grey),),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
