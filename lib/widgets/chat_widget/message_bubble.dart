import 'package:chat/modules/new_message_model.dart';
import 'package:chat/modules/post_model.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/widgets/global_widget/global_widget.dart';
import 'package:chat/widgets/post_widget/full_post_screen.dart';
import 'package:chat/widgets/voice_picker_and_player_widgets/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MessageBubble extends StatelessWidget {
  final NewMessageModel message;
  final bool isMe;
  final String senderImage;
  final String receiverImage;
  final PostModel? post;

  MessageBubble(
      {required this.message,
      required this.isMe,
      required this.senderImage,
      required this.receiverImage,
      this.post});

  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            radius: 10,
            backgroundImage: NetworkImage(receiverImage),
          ),
        Flexible(
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: isMe
                ? BoxDecoration(
                    color:social.isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: isMe ? Radius.circular(0) : Radius.circular(15),
                      topLeft: !isMe ? Radius.circular(0) : Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  )
                : BoxDecoration(
                    color:social.isDark?Colors.grey[700]: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: isMe ? Radius.circular(0) : Radius.circular(15),
                      topLeft: !isMe ? Radius.circular(0) : Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
            padding: message.text.isNotEmpty
                ? EdgeInsets.symmetric(vertical: 8, horizontal: 16)
                : null,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
            child: message.text.isNotEmpty
                ? Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.text,
                        style: TextStyle(
                          fontWeight:
                              Theme.of(context).textTheme.caption!.fontWeight,
                          color: !isMe
                              ? Theme.of(context).textTheme.bodyText1!.color
                              : Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        textAlign: !isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ],
                  )
                : message.image.isNotEmpty
                    ? Container(
                        width: 180,
                        height: 180,
                        child: buildImageContainer(message.image, context),
                      )
                    : message.video.isNotEmpty
                        ? Container(
                            width: 180,
                            height: 180,
                            child: buildVideoContainer(
                                message.video, true, context),
                          )
                        : message.voice.isNotEmpty
                            ? AudioPlayerWidget(url: message.voice)
                            : post != null
                                ? Container(
                                    width: 180,
                                    height: 310,
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    child: FadeInImage
                                                        .memoryNetwork(
                                                      width: 30,
                                                      height: 30,
                                                      placeholder:
                                                          kTransparentImage,
                                                      image:
                                                          '${post!.userImage}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(post!.username),
                                                ],
                                              ),
                                            ),
                                            if (post!.postVideo.isNotEmpty ||
                                                post!.postImage.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.5,
                                                        horizontal: 5.0),
                                                child: Text(
                                                  post!.textBody,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0,
                                                      vertical: 2.0),
                                              child: Container(
                                                height: 200,
                                                width: double.infinity,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                ),
                                                child: post!
                                                        .postImage.isNotEmpty
                                                    ? Image.network(
                                                        '${post!.postImage}',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : post!.postVideo.isNotEmpty
                                                        ? buildVideoContainer(
                                                            post!.postVideo,
                                                            true,
                                                            context)
                                                        : Text(
                                                            post!.textBody,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Center(
                                              child: Container(
                                                height: 20,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    color:social.isDark ? Colors.grey[800] : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    )),
                                                child: Text(
                                                  'go to main post',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FullPostScreen(post: post!),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
          ),
        ),
        if (isMe)
          CircleAvatar(
            radius: 10,
            backgroundImage: NetworkImage(senderImage),
          ),
      ],
    );
  }
}
