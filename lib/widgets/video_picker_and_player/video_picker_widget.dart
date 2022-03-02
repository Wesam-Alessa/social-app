import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/widgets/video_picker_and_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VideoPickerWidget extends StatefulWidget {
  final bool isReplay;

  const VideoPickerWidget({required this.isReplay});

  @override
  _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();

  XFile? videoFile;

  var path;

  @override
  void dispose() {
    path = null;
    super.dispose();
  }

  void _onImageButtonPressed(ImageSource source,) async {
    if (isVideo) {
      videoFile = await _picker
          .pickVideo(
        source: source,
      )
          .then((value) async {
        widget.isReplay == false
            ? Provider.of<UserDataProvider>(context, listen: false)
                .setCommentVideo(value!)
            : Provider.of<UserDataProvider>(context, listen: false)
                .setReplayCommentVideo(value!);
        path = value.path;
      }).catchError((onError) {
        print("Not Selected any Video");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(builder: (context, userProvider, _) {
      return Scaffold(
          body: userProvider.commentVideo != null ||
                  userProvider.replayCommentVideo != null
              ? Stack(
                  children: [
                    Container(
                      child: VideoPlayerWidget(url: path, isOnlineVideo: false),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.white38,
                          onPressed: () => Provider.of<UserDataProvider>(
                                  context,
                                  listen: false)
                              .changeOpenVideoPickerCommentContainer(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white60,
                              onPressed: () {
                                isVideo = true;
                                _onImageButtonPressed(ImageSource.camera);
                              },
                              heroTag: 'video1',
                              tooltip: 'Take a Video',
                              child: const Icon(IconBroken.Video,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white60,
                              onPressed: () {
                                isVideo = true;
                                _onImageButtonPressed(ImageSource.gallery);
                              },
                              heroTag: 'video0',
                              tooltip: 'Pick Video from gallery',
                              child: const Icon(IconBroken.Folder,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white60,
                              onPressed: () => Provider.of<UserDataProvider>(
                                      context,
                                      listen: false)
                                  .changeOpenVideoPickerCommentContainer(),
                              child:
                                  const Icon(Icons.close, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
    });
  }
}
