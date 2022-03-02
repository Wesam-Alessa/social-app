import 'package:chat/providers/userDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ShareWidget extends StatefulWidget {
  final postId;

  ShareWidget({Key? key, required this.postId}) : super(key: key);

  @override
  State<ShareWidget> createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  List<bool> isDone = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userProvider, _) {
       // userProvider.myFriends.add(userProvider.myFriends[0]);
        userProvider.myFriends.forEach((element) {
          isDone.add(false);
        });
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title:userProvider.myFriends.isNotEmpty?
            Text('Share with your friends',
                style: Theme.of(context).textTheme.bodyText1):
            Text('Friends list is empty',
                style: Theme.of(context).textTheme.bodyText1),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  height: 1,
                  color: Colors.grey,
                ),
                if (userProvider.myFriends.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                      ),
                      itemCount: userProvider.myFriends.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 300,
                          width: 100,
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                child: CircleAvatar(
                                  radius: 25,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: FadeInImage.memoryNetwork(
                                      width: 50,
                                      height: 50,
                                      placeholder: kTransparentImage,
                                      image:
                                          '${userProvider.myFriends[index].userImage}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Text(
                                  '${userProvider.myFriends[index].username}',
                                  style: Theme.of(context).textTheme.subtitle1,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  //softWrap: true,
                                ),
                              ),
                              //SizedBox(height: 10,),
                              Container(
                                height: 20,
                                width: 60,
                                child: ElevatedButton(
                                  onPressed: isDone[index] == false
                                      ? () {
                                    userProvider
                                        .sendMessage(
                                      postId: widget.postId,
                                      createdAt: DateTime.now().toIso8601String(),
                                      receiverId: userProvider.myFriends[index].userId,
                                    )
                                        .then((value) {
                                       setState(() {
                                      isDone[index] = true;
                                         //textB = 'done';
                                      });
                                    });
                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white54,
                                  ),
                                  child: Center(
                                    child: Text(
                                      isDone[index]==true?'done':'send',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

String textB = 'send';
}
ElevatedButton sendButton(UserDataProvider userProvider, index, context,postId) {
  String textB = 'send';
  return ElevatedButton(
    onPressed: textB == 'send'
        ? () {
      userProvider
          .sendMessage(
        postId: postId,
        createdAt: DateTime.now().toIso8601String(),
        receiverId: userProvider.myFriends[index].userId,
      )
          .then((value) {
       // setState(() {
          textB = 'done';
        //});
      });
    }
        : null,
    style: ElevatedButton.styleFrom(
      primary: Colors.white54,
    ),
    child: Center(
      child: Text(
        textB,
        style: Theme.of(context).textTheme.caption,
      ),
    ),
  );
}
