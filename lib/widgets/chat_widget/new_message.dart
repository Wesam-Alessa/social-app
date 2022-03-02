import 'dart:io';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:chat/widgets/video_picker_and_player/video_player.dart';
import 'package:chat/widgets/voice_picker_and_player_widgets/player.dart';
import 'package:chat/widgets/voice_picker_and_player_widgets/voice_recorder_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  File? _image;
  bool focus = false;
  File? _video;
  File? _voice;
  String receiverId = '';
  bool loading = false;

  _sendMessage(){
    if (_enteredMessage.isNotEmpty && _image == null && _video == null && _voice == null) {
      Provider.of<UserDataProvider>(context, listen: false).sendMessage(
          text: _enteredMessage,
          createdAt: DateTime.now().toIso8601String(),
          receiverId: receiverId
      );
      _controller.clear();
      setState(() {
        _enteredMessage = '';
        focus = false;
      });
    }
    else if (_enteredMessage.isEmpty && _image != null && _video == null && _voice == null) {
      FocusScope.of(context).unfocus();
      setState(() {
        loading = true;
      });
      Provider.of<UserDataProvider>(context, listen: false).sendMessage(
          image: _image,
          createdAt: DateTime.now().toIso8601String(),
          receiverId: receiverId
      ).then((value) {
        setState(() {
          loading = false;
        });
      });
      _controller.clear();
      setState(() {
        _enteredMessage = '';
        _image = null;
      });
    }
    else if (_enteredMessage.isEmpty && _image == null && _video != null && _voice == null) {
      FocusScope.of(context).unfocus();
      setState(() {
        loading = true;
      });
      Provider.of<UserDataProvider>(context, listen: false).sendMessage(
          video: _video,
          createdAt: DateTime.now().toIso8601String(),
          receiverId: receiverId
      ).then((value){
        setState(() {
          loading = false;
        });
      });
      _controller.clear();
      setState(() {
        _enteredMessage = '';
        _video = null;
        focus = false;
      });
    }
    else if (_enteredMessage.isEmpty && _image == null && _video == null && _voice != null) {
      FocusScope.of(context).unfocus();
      setState(() {
        loading = true;
      });
      Provider.of<UserDataProvider>(context, listen: false).sendMessage(
          voice: _voice,
          createdAt: DateTime.now().toIso8601String(),
          receiverId:receiverId
      ).then((value) {
        setState(() {
          loading = false;
        });
      });
      _controller.clear();
      setState(() {
        _enteredMessage = '';
        _voice = null;
        Provider.of<UserDataProvider>(context, listen: false).messageVoiceFile = null;
        focus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Consumer<UserDataProvider>(
      builder: (context, userProvider, _) {
        receiverId = userProvider.myFriendChat!.userId;
        _voice = userProvider.messageVoiceFile;
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Column(
              children: [
                if (_image != null || _video != null || _voice != null)SizedBox(height: 10,),
                Row(
                  children: [
                    if (!focus)
                      GestureDetector(
                      onTap: (){
                        userProvider
                            .pickAnyImage(ImageSource.gallery)
                            .then((value) {
                          _image = value;
                         }).catchError((error) {});
                        },
                      child: Icon(
                        IconBroken.Image,
                        size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (!focus)
                      SizedBox(width: 8.0,),
                    if (!focus)
                      GestureDetector(
                        onTap: (){
                          userProvider
                            .pickAnyVideo(ImageSource.gallery)
                            .then((value) {
                          _video = value;
                        }).catchError((error) {});},
                        child: Icon(
                            IconBroken.Video,
                            size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    if (!focus)SizedBox(width: 8.0,),
                    if (!focus)
                       VoiceRecorderWidget(),
                    if (!focus)SizedBox(width: 8.0,),
                    if (_image == null && _video == null && _voice == null && userProvider.messageVoiceFile == null)
                      Expanded(
                        child: userProvider.isRecordingVoiceMessage ?
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Image.asset('assets/images/recording.gif',
                            fit: BoxFit.cover,
                          ),
                        ):
                        TextFormField(
                          autocorrect: true,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _controller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'write your message...',
                              hintStyle: Theme.of(context).textTheme.caption),
                          onChanged: (value) {
                            setState(() {
                              focus = value.isNotEmpty ? true : false;
                              _enteredMessage = value;
                            });
                          },
                        ),
                      ),
                    if (_image != null || _video != null || userProvider.messageVoiceFile != null || userProvider.isRecordingVoiceMessage==true)
                      Spacer(),
                    if (_image != null || _video != null || userProvider.messageVoiceFile != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _image = null;
                            _video = null;
                            _voice = null;
                            userProvider.messageVoiceFile = null;
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    if (_image != null || _video != null || _voice != null) SizedBox(width: 10,),
                    loading == true
                        ? Container(width: 22,height: 22,child: CircularProgressIndicator())
                        : GestureDetector(
                            child: Icon(IconBroken.Send, color:Theme.of(context).primaryColor, size: 22,),
                            onTap: _enteredMessage.trim().isEmpty &&
                                    _image == null &&
                                    _video == null &&
                                     userProvider.messageVoiceFile == null
                                ? null
                                : _sendMessage,
                          ),
                  ],
                ),
                if (_image != null || _video != null || _voice != null)SizedBox(height: 10,),
                if (_image != null && _video == null && _voice == null)
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    child: Image.file(
                      _image!,
                    ),
                  ),
                if (_image == null && _video != null && _voice == null)
                  Container(
                    child: VideoPlayerWidget(
                      isOnlineVideo: true,
                      url: _video!.path,
                    ),
                  ),
                if (_enteredMessage.isEmpty && _image == null && _video == null && _voice != null)
                  AudioPlayerWidget(url: userProvider.messageVoiceFile!.path,),

              ],
            ),
          ),
        );
      },

    );
  }
}
