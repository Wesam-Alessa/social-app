import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/chat_widget/message_bubble.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context, listen: false).getMessages();
  }
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Consumer<UserDataProvider>(
          builder: (context, userProvider, _) {
            return ConditionalBuilder(
              condition: userProvider.messages.isNotEmpty,
              builder: (context) => ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8),
                reverse: true,
                itemCount: userProvider.messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: userProvider.messages[index],
                    isMe: userProvider.user.userId == userProvider.messages[index].senderId
                            ? true
                            : false,
                    senderImage: userProvider.user.userImage,
                    receiverImage: userProvider.myFriends
                        .firstWhere((element) =>
                            element.userId == userProvider.myFriendChat!.userId)
                        .userImage,
                    post: userProvider.messages[index].postId.isNotEmpty ?
                    userProvider.posts.firstWhere((element) => element.postId == userProvider.messages[index].postId)
                    : null ,
                  );
                },
              ),
              fallback: (context) => Center(child: Text('No messages')),
            );
          },
        );
      },

    );
  }
}
