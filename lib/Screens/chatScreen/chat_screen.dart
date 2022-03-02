
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/chat_widget/message.dart';
import 'package:chat/widgets/chat_widget/new_message.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserDataProvider,SocialProvider>(
      builder: (context,userProvider,social,_){
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 28.0,
            leading: IconButton(
              icon: Icon( IconBroken.Arrow___Left_2,color:social.isDark ? Colors.white : Colors.black,),
              onPressed: ()=> Navigator.pop(context),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userProvider.myFriendChat!.userImage),
                ),
                SizedBox(width: 8.0,),
                Text(userProvider.myFriendChat!.username,style: Theme.of(context).textTheme.bodyText1,),
              ],
            ) ,
            //leading:
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                    child: Messages()
                ),
                NewMessages(),
              ],
            ),
          ),
        );
      },
    );

  }
}
