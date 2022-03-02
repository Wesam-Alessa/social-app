import 'package:audioplayers/audioplayers.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  AudioPlayerWidget({required this.url});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  //AnimationController? _animController;
  var audioPlayerState = PlayerState.PAUSED;
  int timeProgress = 0;
  int audioDuration = 0;

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(widget.url);
    audioPlayer.onDurationChanged.listen(
          (Duration duration) {
        // _animController!.stop();
        setState(() {
          audioDuration = duration.inSeconds + 1;
        });

        //_animController!.duration =
        // Duration(seconds: audioDuration
        // );
        //_animController!.forward();
      },
    );
    audioPlayer.onAudioPositionChanged.listen((Duration position){
      setState(() {
        timeProgress = position.inSeconds + 1;
      });
      if (audioDuration == timeProgress) {
        setState(() {
          audioPlayerState = PlayerState.PAUSED;
          //_animController!.stop();
        });
      }
    });
    //_animController = AnimationController(vsync: this);
   // _animController!.addStatusListener((status) {
    //  if (status == AnimationStatus.completed) {
      //  _animController!.stop();
      //  audioPlayerState = PlayerState.PAUSED;
      //  setState(() {});
       // _animController!.reset();
     // }
    //});
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    //_animController!.dispose();
  }

  playMusic() async {
    setState(() {
      audioPlayerState = PlayerState.PLAYING;
    });
    await audioPlayer.play(
      widget.url,
    );


  }

  pauseMusic() async {
    setState(() {
      audioPlayerState = PlayerState.PAUSED;
      //_animController!.stop();
    });
    await audioPlayer.pause();
  }

  // void seekToSec(int sec) {
  //   Duration newPos = Duration(seconds: sec);
  //   setState(() {
  //     audioPlayer.seek(newPos);
  //   });
  // }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';

    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

   buildContainer(double width, Color color) {
    return Container(
      height: 35.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    return Container(
      width: 165,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: OutlinedButton(
        onPressed: () {

          audioPlayerState == PlayerState.PLAYING ? pauseMusic() : playMusic();
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 12,
              child: Center(
                child: Icon(
                  audioPlayerState == PlayerState.PLAYING
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              height: 2,
              width: 40,
              color: audioPlayerState == PlayerState.PLAYING
                 ? null : Colors.blueAccent,
              child:audioPlayerState == PlayerState.PLAYING
                ? LinearProgressIndicator(backgroundColor: Colors.blueAccent,color: Colors.white,)
              :null,
            ),
            Container(
              width:90,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.blueAccent)
              ),
              child: Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color:audioPlayerState == PlayerState.PLAYING
                          ? null : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: audioPlayerState == PlayerState.PLAYING
                        ? LinearProgressIndicator(backgroundColor: Colors.blueAccent,color: Colors.white,)
                        :null,
                  ),
                  Padding(
                    padding:  EdgeInsets.all(1.0),
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "${getTimeString(timeProgress)} / ${getTimeString(audioDuration)}",
                            style:social.isDark ?
                            Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)
                            :
                            Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
