import 'package:chat/widgets/full_screen_widgets/full_screen_image.dart';
import 'package:chat/widgets/full_screen_widgets/full_screen_video.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

buildVideoContainer(String url,bool isOnline,context){
  VideoPlayerController? _videoController;
  _videoController = VideoPlayerController.network(url,)
    ..initialize().then((_) {
    });
  return Container(
      width: double.infinity,
      height: 140.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_)=> FullScreenVideo(url:url ,isOnline: isOnline,))),
        child: Stack(
          children: [
            VideoPlayer(_videoController),
            Center(child: Icon(IconBroken.Play,color: Colors.grey,size: 60,)),
          ],
        ),
      )
  );
}

buildImageContainer(String url,context){
  return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_)=> FullScreenImage(url: url,))),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      )
  );
}

buildAlertDialogWithDownloader(String title,double progress,context){
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 5.0,),
            LinearProgressIndicator(
              minHeight: 10,
              value: progress,
            )
          ],
        ),
      ),
  );
}