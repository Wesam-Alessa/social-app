import 'package:chat/Screens/searchScreen/search_screen.dart';
import 'package:chat/modules/post_model.dart';
import 'package:chat/widgets/post_widget/Posts_widget.dart';

import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';

import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPostsScreen extends StatefulWidget {
  @override
  _MainPostsScreenState createState() => _MainPostsScreenState();
}

class _MainPostsScreenState extends State<MainPostsScreen> {

  @override
  Widget build(BuildContext context) {
    var socialProvider = Provider.of<SocialProvider>(context, listen: true);
    return Consumer<UserDataProvider>(
      builder: (context, userProvider, _) {
        List<PostModel> posts = userProvider.posts;
        return ConditionalBuilder(
          condition: userProvider.posts.length > 0,
          builder: (context) {
            userProvider.getMyPost();
            return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  socialProvider.titles[socialProvider.currentIndex],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        userProvider.searchList.clear();
                         Navigator.of(context).push(MaterialPageRoute(builder:(_)=>SearchScreen()));
                      },
                      icon: Icon(IconBroken.Search),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, postIndex) => PostWidget(post: posts[postIndex],),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8.0,
                      ),
                      itemCount: posts.length,
                    ),
                    SizedBox(
                      height: 8.0,
                    )
                  ],
                ),
              ),
            ),
          );
          },
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
//   Container(
//   padding: EdgeInsets.all(8.0),
//   child: Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Column(
//         children: [
//           ClipRRect(
//             borderRadius:BorderRadius.circular(15.0),
//             child: FadeInImage.memoryNetwork(
//               width: 30,
//               height: 30,
//               placeholder: kTransparentImage,
//               image: '${posts[postIndex].comments[commentIndex]['body']['userImage']}',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//       SizedBox(
//         width:
//         5.0,
//       ),
//       Container(
//         width:widthSize-80,
//         child:
//         Column(
//           crossAxisAlignment:
//           CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding:
//               EdgeInsets.all(5.0),
//               decoration:
//               BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${posts[postIndex].comments[commentIndex]['body']['userName']}',
//                     style: Theme.of(context).textTheme.subtitle2,
//                   ),
//                   SizedBox(
//                     height: 5.0,
//                   ),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'text')
//                     SelectableText(
//                       '${posts[postIndex].comments[commentIndex]['body']['commentBody']['text']}',
//                     ),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'record')
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'record')
//                     AudioPlayerWidget(url: posts[postIndex].comments[commentIndex]['body']['commentBody']['voice']),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'picture')
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'picture')
//                     FadeInImage.memoryNetwork(
//                       placeholder: kTransparentImage,
//                       image: '${posts[postIndex].comments[commentIndex]['body']['commentBody']['image']}',
//                     ),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'video')
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                   if (posts[postIndex].comments[commentIndex]['comment_type'] == 'video')
//                     Container(
//                       child: VideoPlayerWidget(
//                         url:'${posts[postIndex].comments[commentIndex]['body']['commentBody']['video']}',
//                         isOnlineVideo: true,
//                       ),
//                     ),
//                   if(posts[postIndex].comments[commentIndex]['comment_type'] == 'text and picture')
//                     Column(
//                       crossAxisAlignment : CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           child: SelectableText(
//                             '${posts[postIndex].comments[commentIndex]['body']['commentBody']['text']}',
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5.0,
//                         ),
//                         FadeInImage.memoryNetwork(
//                           placeholder: kTransparentImage,
//                           image: '${posts[postIndex].comments[commentIndex]['body']['commentBody']['image']}',
//                         ),
//                       ],
//                     ),
//                   if(posts[postIndex].comments[commentIndex]['comment_type'] == 'text and video')
//                     Column(
//                       crossAxisAlignment : CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           child: SelectableText(
//                             '${posts[postIndex].comments[commentIndex]['body']['commentBody']['text']}',
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5.0,
//                         ),
//                         Container(
//                           child: VideoPlayerWidget(
//                             url:'${posts[postIndex].comments[commentIndex]['body']['commentBody']['video']}',
//                             isOnlineVideo: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 Text('$timeNow'),
//                 SizedBox(
//                   width: 5.0,
//                 ),
//                 Container(
//                   child: TextButton(
//                     onPressed: () {
//                       userProvider.likeOnCommentInPost(
//                           post: posts[postIndex],
//                           commentId: posts[postIndex].comments[commentIndex]['id'],
//                           commentBody: posts[postIndex].comments[commentIndex]['body']['commentBody'])
//                           .then((value) {})
//                           .catchError((error) {});
//                     },
//                     child: Row(
//                       children: [
//                         Icon(
//                           posts[postIndex].comments[commentIndex]['body']['likes']
//                               .contains(userProvider.user.userId) ?
//                           Icons.favorite : Icons.favorite_border_outlined,
//                           color: Colors.red,
//                         ),
//                         if (posts[postIndex].comments[commentIndex]['body']['likes'].length != 0)
//                           SizedBox(
//                             width: 5.0,
//                           ),
//                         if (posts[postIndex].comments[commentIndex]['body']['likes'].length != 0)
//                           Text(
//                             '${posts[postIndex].comments[commentIndex]['body']['likes'].length}',
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                         SizedBox(
//                           width: 5.0,
//                         ),
//                         Text(
//                           'Like',
//                           style: Theme.of(context).textTheme.subtitle1,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 //REPLAY COMMENTS *********************************************** START FROM HERE
//                 Container(
//                   child: TextButton(
//                     onPressed: () {
//                       var height = MediaQuery.of(context).size.height;
//                       isReplayComment = true;
//                       userProvider.nullAllValues();
//                       showMaterialModalBottomSheet(
//                         clipBehavior: Clip.antiAlias,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadiusDirectional.only(
//                             topStart: Radius.circular(25.0),
//                             topEnd: Radius.circular(25.0),
//                           ),
//                         ),
//                         context: context,
//                         builder: (context) => Consumer<UserDataProvider>(
//                           builder: (context, value, _) => Container(
//                             height: height - 45,
//                             padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                             child: Scaffold(
//                               body: SafeArea(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Reply to ${posts[postIndex].comments[commentIndex]['body']['userName']} comment',
//                                           style: Theme.of(context).textTheme.subtitle2,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     if (posts[postIndex].comments[commentIndex]['replyComments'].length > 0)
//                                       Expanded(
//                                         child: ListView.builder(
//                                           itemCount: posts[postIndex].comments[commentIndex]['replyComments'].length,
//                                           itemBuilder: (context, replyCommentIndex) {
//                                             var replyTimeNow = DateTime.now().difference(DateTime.parse(posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['dateTime'])).toString();
//                                             if (replyTimeNow != "0") {
//                                               var i = replyTimeNow.indexOf(':');
//                                               var replyTimeNow1 = replyTimeNow.substring(0, i);
//                                               var hours = double.parse(replyTimeNow1);
//                                               if (hours >= 24) {
//                                                 hours = (hours / 24);
//                                                 replyTimeNow1 = '${hours.toInt().toString()}d';
//                                               } else if (hours >= 1 && hours < 24) {
//                                                 replyTimeNow1 = '${hours.toInt().toString()}h';
//                                               } else if (hours < 1) {
//                                                 replyTimeNow1 = "${replyTimeNow.substring(i + 1, i + 3)}m";
//                                               }
//                                               replyTimeNow = replyTimeNow1;
//                                             }
//                                             return Container(
//                                               padding: EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Column(
//                                                     children: [
//                                                       ClipRRect(
//                                                         borderRadius: BorderRadius.circular(15.0),
//                                                         child: FadeInImage.memoryNetwork(
//                                                           width: 30,
//                                                           height: 30,
//                                                           placeholder: kTransparentImage,
//                                                           image: '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['userImage']}',
//                                                           fit: BoxFit.cover,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(
//                                                     width: 10.0,
//                                                   ),
//                                                   Container(
//                                                     width: widthSize-80,
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Container(
//                                                           padding: EdgeInsets.all(5.0),
//                                                           decoration: BoxDecoration(
//                                                             color: Colors.grey[200],
//                                                             borderRadius: BorderRadius.circular(15.0),
//                                                           ),
//                                                           child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               Text(
//                                                                 '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['userName']}',
//                                                                 style: Theme.of(context).textTheme.subtitle2,
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 5.0,
//                                                               ),
//                                                               if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'text')
//                                                                 SelectableText(
//                                                                   '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['text']}',
//                                                                 ),
//                                                               if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'record')
//                                                                 SizedBox(
//                                                                   height: 5.0,
//                                                                 ),
//                                                               if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'record') AudioPlayerWidget(url: posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['voice']),
//                                                               if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'picture')
//                                                                 SizedBox(
//                                                                   height: 5.0,
//                                                                 ),
//                                                               if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'picture')
//                                                                 FadeInImage.memoryNetwork(
//                                                                   placeholder: kTransparentImage,
//                                                                   image: '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['image']}',
//                                                                 ),
//                                                               if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'video')
//                                                                 Container(
//                                                                   child: VideoPlayerWidget(
//                                                                     url:'${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['video']}',
//                                                                     isOnlineVideo: true,
//                                                                   ),
//                                                                 ),
//                                                               if(posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'text and picture')
//                                                                 Column(
//                                                                   crossAxisAlignment : CrossAxisAlignment.start,
//                                                                   children: [
//                                                                     Container(
//                                                                       child: SelectableText(
//                                                                         '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['text']}',
//                                                                       ),
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height: 5.0,
//                                                                     ),
//                                                                     FadeInImage.memoryNetwork(
//                                                                       placeholder: kTransparentImage,
//                                                                       image: '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['image']}',
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               if(posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['comment_type'] == 'text and video')
//                                                                 Column(
//                                                                   crossAxisAlignment : CrossAxisAlignment.start,
//                                                                   children: [
//                                                                     Container(
//                                                                       child: SelectableText(
//                                                                         '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['text']}',
//                                                                       ),
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height: 5.0,
//                                                                     ),
//                                                                     Container(
//                                                                       child: VideoPlayerWidget(
//                                                                         url:'${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['commentBody']['video']}',
//                                                                         isOnlineVideo: true,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Text('$replyTimeNow'),
//                                                             SizedBox(
//                                                               width: 5.0,
//                                                             ),
//                                                             Container(
//                                                               child: TextButton(
//                                                                 onPressed: () async {
//                                                                   await userProvider.likeOnReplyComment(post: posts[postIndex], commentIndex: commentIndex, replyCommentIndex: replyCommentIndex).then((value) {}).catchError((error) {});
//                                                                 },
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Icon(
//                                                                       posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['likes'].contains(userProvider.user.userId) ? Icons.favorite : Icons.favorite_border_outlined,
//                                                                       color: Colors.red,
//                                                                     ),
//                                                                     if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['likes'].length != 0)
//                                                                       SizedBox(
//                                                                         width: 5.0,
//                                                                       ),
//                                                                     if (posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['likes'].length != 0)
//                                                                       Text(
//                                                                         '${posts[postIndex].comments[commentIndex]['replyComments'][replyCommentIndex]['body']['likes'].length}',
//                                                                         style: Theme.of(context).textTheme.subtitle1,
//                                                                       ),
//                                                                     SizedBox(
//                                                                       width: 5.0,
//                                                                     ),
//                                                                     Text(
//                                                                       'Like',
//                                                                       style: Theme.of(context).textTheme.subtitle1,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     if (posts[postIndex].comments[commentIndex]['replyComments'].length == 0)
//                                       Expanded(
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Icon(IconBroken.Shield_Fail),
//                                             SizedBox(
//                                               height: 10.0,
//                                             ),
//                                             Text('No Reply Comments ...'),
//                                           ],
//                                         ),
//                                       ),
//                                     Align(
//                                       alignment: Alignment.bottomCenter,
//                                       child: Container(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: SingleChildScrollView(
//                                             child: Column(
//                                               children: [
//                                                 TextField(
//                                                   autocorrect: true,
//                                                   enableSuggestions: true,
//                                                   textCapitalization: TextCapitalization.sentences,
//                                                   controller: _replyCommentController,
//                                                   decoration: InputDecoration(
//                                                     labelText: 'Write a comment...',
//                                                   ),
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       _textComment = value;
//                                                     });
//                                                   },
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Container(
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.circular(25),
//                                                       ),
//                                                       child:
//                                                       Center(
//                                                         child:
//                                                         IconButton(
//                                                           onPressed: () async {
//                                                             setState(() {
//                                                               userProvider.changeOpenImagePickerCommentContainer();
//                                                             });
//                                                           },
//                                                           icon: Icon(
//                                                             IconBroken.Camera,
//                                                             size: 25,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.circular(25),
//                                                       ),
//                                                       child:
//                                                       Center(
//                                                         child:
//                                                         IconButton(
//                                                           onPressed: () async {
//                                                             setState(() {
//                                                               userProvider.changeOpenVideoPickerCommentContainer();
//                                                             });
//                                                           },
//                                                           icon: Icon(
//                                                             IconBroken.Video,
//                                                             size: 25,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(25),
//                                                       ),
//                                                       child: Center(
//                                                         child: IconButton(
//                                                           onPressed: () async {
//                                                             setState(() {
//                                                               userProvider.changeOpenVoiceRecorderContainer();
//                                                             });
//                                                           },
//                                                           icon: Icon(
//                                                             Icons.mic,
//                                                             size: 25,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Spacer(),
//                                                     userProvider.loading? CircularProgressIndicator()
//                                                         : IconButton(
//                                                         color: Theme.of(context).primaryColor,
//                                                         icon: Icon(Icons.send),
//                                                         onPressed: () async {
//                                                           FocusScope.of(context).unfocus();
//                                                           if (_textComment.isEmpty && userProvider.commentImage == null && userProvider.replayCommentVideo == null) {
//                                                             return null;
//                                                           }
//                                                           else if(_textComment.isNotEmpty && userProvider.commentImage == null && userProvider.replayCommentVideo == null){
//                                                             await userProvider.newReplyTextComment(post: posts[postIndex], text: _textComment, commentIndex: commentIndex).then((value) {
//                                                               print('success');
//                                                               _textComment = '';
//                                                               _replyCommentController.clear();
//                                                             }).catchError((error) {
//                                                               print('field');
//                                                             });
//                                                           }
//                                                           else if(_textComment.isEmpty && userProvider.replayCommentVideo == null && userProvider.commentImage != null){
//                                                             await userProvider.newReplyCommentPictureOnPost(
//                                                                 post: posts[postIndex],commentIndex: commentIndex)
//                                                                 .then((value){
//                                                               print('success replay comment picture');
//                                                             })
//                                                                 .catchError((error){
//                                                               print('error replay comment picture');
//                                                             });
//                                                           }
//                                                           else if(_textComment.isEmpty && userProvider.commentImage == null && userProvider.commentVideo == null && userProvider.replayCommentVideo != null){
//                                                             await userProvider.newReplyVideoCommentOnPost(post: posts[postIndex],commentIndex: commentIndex)
//                                                                 .then((value){
//                                                               print('success comment video');
//                                                             })
//                                                                 .catchError((error){
//                                                               print('error comment video');
//                                                             });
//                                                           }
//                                                           else if(_textComment.isNotEmpty && userProvider.commentImage != null && userProvider.commentVideo == null && userProvider.replayCommentVideo == null){
//                                                             await userProvider.newReplayTextAndPictureCommentOnPost(post: posts[postIndex],text: _textComment,commentIndex: commentIndex)
//                                                                 .then((value){
//                                                               _textComment = '';
//                                                               _commentController.clear();
//                                                               print('success comment image and text');
//                                                             })
//                                                                 .catchError((error){
//                                                               print('error comment image and text');
//                                                             });
//                                                           }
//                                                           else if(_textComment.isNotEmpty && userProvider.commentImage == null && userProvider.commentVideo == null && userProvider.replayCommentVideo != null){
//                                                             await userProvider.newReplayTextAndVideoCommentOnPost(post: posts[postIndex],text: _textComment,commentIndex: commentIndex)
//                                                                 .then((value){
//                                                               _textComment = '';
//                                                               _commentController.clear();
//                                                               print('success comment image and text');
//                                                             })
//                                                                 .catchError((error){
//                                                               print('error comment image and text');
//                                                             });
//                                                           }
//
//                                                         }),
//                                                   ],
//                                                 ),
//                                                 if (userProvider.commentImage != null)
//                                                   Consumer<UserDataProvider>(
//                                                     builder: (context, value, _){
//                                                       return Container(
//                                                         height: 100.0,
//                                                         clipBehavior:
//                                                         Clip.antiAlias,
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Colors.white,
//                                                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                                         ),
//                                                         child:Image.file(userProvider.commentImage!),
//                                                       );
//                                                     },
//                                                   ),
//                                                 if (userProvider.openImagePickerCommentContainer)
//                                                   Consumer<UserDataProvider>(
//                                                     builder:(context,value,_) {
//                                                       return Container(
//                                                         height: 60.0,
//                                                         child:ImagePickerWidget(),
//                                                       );
//                                                     },
//                                                   ),
//                                                 if (userProvider.openVideoPickerCommentContainer)
//                                                   Consumer<UserDataProvider>(
//                                                     builder: (context, value, _) {
//                                                       return Container(
//                                                         height: userProvider.replayCommentVideo != null ?180:60,
//                                                         width: double.infinity,
//                                                         clipBehavior: Clip.antiAlias,
//                                                         decoration: BoxDecoration(
//                                                           color: Colors.grey[200],
//                                                         ),
//                                                         child: VideoPickerWidget(isReplay: true,),
//                                                       );
//                                                     },
//                                                   ),
//                                                 if (userProvider.openVoiceRecorderContainer)
//                                                   Consumer<UserDataProvider>(
//                                                     builder: (context, value, _) {
//                                                       return Container(
//                                                         height: 200.0,
//                                                         clipBehavior: Clip.antiAlias,
//                                                         decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
//                                                         child: AudioRecordWidget(
//                                                           post: posts[postIndex],
//                                                           isReplay: true,
//                                                           commentIndex: commentIndex,
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       //),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'Reply',
//                       style: Theme.of(context).textTheme.subtitle1,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// );



// GestureDetector(
//   onTap: () {
//     userProvider
//         .pickAnyVideo(ImageSource.gallery)
//         .then((value) {
//       userProvider.storyFile = value;
//       userProvider
//           .uploadMyStory(false,context)
//           .then((value) {
//         Navigator.pop(context);
//       }).catchError((error) {
//       });
//     }).catchError((onError) {
//     });
//   },
//   child: Padding(
//     padding: const EdgeInsets.symmetric(
//         horizontal: 20, vertical: 10),
//     child: Container(
//       padding: const EdgeInsets.all(5.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(IconBroken.Video,
//               size: 35,
//               color:
//               Theme.of(context).primaryColor),
//           SizedBox(
//             width: 20.0,
//           ),
//           Text('add video to your story',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyText2),
//         ],
//       ),
//     ),
//   ),
// ),