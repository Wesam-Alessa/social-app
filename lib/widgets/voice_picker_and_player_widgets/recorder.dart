// import 'dart:async';
// import 'dart:io';
// import 'package:chat/modules/post_model.dart';
// import 'package:chat/providers/userDataProvider.dart';
// import 'package:custom_timer/custom_timer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// //typedef _Fn = void Function();
//
// class AudioRecordWidget extends StatefulWidget {
//   final PostModel post;
//   final bool isReplay;
//   final int commentIndex;
//   AudioRecordWidget({required this.post,required this.isReplay,required this.commentIndex});
//   @override
//   _AudioRecordWidgetState createState() => _AudioRecordWidgetState();
// }
//
// class _AudioRecordWidgetState extends State<AudioRecordWidget> {
//   FlutterSoundPlayer? soundPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder? soundRecorder = FlutterSoundRecorder();
//   CustomTimerController timeController = new CustomTimerController();
//   bool soundPlayerIsInit = false;
//   bool soundRecorderIsInit = false;
//   bool soundPlaybackReady = false;
//   String? recordPath;
//   StreamSubscription? _recordDataSubscription;
//
//   var userProvider;
//   var recordeFile;
//
//   Timer? time;
//   int min = 09;
//   int sec = 59;
//   var counter ;
//
//   @override
//   void initState(){
//     super.initState();
//     counter = "";
//     userProvider = Provider.of<UserDataProvider>(context, listen: false);
//     soundPlayer!.openAudioSession().then((value) {
//       setState(() {
//         soundPlayerIsInit = true;
//       });
//     });
//     openRecorder();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     timeController.dispose();
//     counter = null;
//     stopPlayer();
//     soundPlayer!.closeAudioSession();
//     soundPlayer = null;
//     stopRecorder();
//     soundRecorder!.closeAudioSession();
//     soundRecorder = null;
//     time!.cancel();
//   }
//
//   Future<void> openRecorder() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permission not granted');
//     }
//     await soundRecorder!.openAudioSession();
//     setState(() {
//       soundRecorderIsInit = true;
//     });
//   }
//
//   // Future<IOSink> createFile() async {
//   //   var tempDir = await getTemporaryDirectory();
//   //   recordPath = '${tempDir.path}/flutter_sound_example.pcm';
//   //   var outputFile = File(recordPath!);
//   //   if (outputFile.existsSync()) {
//   //     await outputFile.delete();
//   //   }
//   //   return outputFile.openWrite();
//   // }
//
//   Future<void> startRecord() async {
//     timeController.reset();
//     assert(soundRecorderIsInit && soundPlayer!.isStopped);
//     timeController.start();
//     Directory tempDir = await getTemporaryDirectory();
//     File outputFile =  File ('${tempDir.path}/flutter_sound-tmp.aac');
//     recordPath = outputFile.path;
//     await soundRecorder!.startRecorder(
//       toFile: outputFile.path,
//       codec:Codec.aacADTS,
//     );
//     setState(() {});
//   }
//
//   Future<void> stopRecorder() async {
//     await soundRecorder!.stopRecorder();
//     if (_recordDataSubscription != null) {
//       await _recordDataSubscription!.cancel();
//       _recordDataSubscription = null;
//     }
//     soundPlaybackReady = true;
//     timeController.pause();
//     setState(() {});
//   }
//
//      getRecorderFn() {
//     if (!soundRecorderIsInit || !soundPlayer!.isStopped){
//       return null;
//     }
//     return soundRecorder!.isStopped
//         ? startRecord
//         : () {
//             stopRecorder().then((value) => setState(() {}));
//           };
//   }
//
//
//
//
// // no need it
//   void play() async {
//     assert(soundPlayerIsInit &&
//         soundPlaybackReady &&
//         soundRecorder!.isStopped &&
//         soundPlayer!.isStopped);
//     timeController.reset();
//     timeController.start();
//     await soundPlayer!.startPlayer(
//         fromURI:recordPath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           timeController.pause();
//           setState(() {});
//         });
//     setState(() {});
//   }
//   Future<void> stopPlayer() async {
//     timeController.pause();
//     await soundPlayer!.stopPlayer();
//   }
//    getPlaybackFn() {
//     if (!soundPlayerIsInit ||
//         !soundPlaybackReady ||
//         !soundRecorder!.isStopped) {
//       return null;
//     }
//     return soundPlayer!.isStopped
//         ? play
//         : () {
//             stopPlayer().then((value) => setState(() {}));
//           };
//   }
//
//   var loading = false;
//
//   Future<void> send() async {
//     if (!soundPlayerIsInit ||
//         !soundPlaybackReady ||
//         !soundRecorder!.isStopped) {
//       return null;
//     }
//     else{
//       loading = true;
//       recordeFile = File(recordPath!);
//       stopRecorder();
//       stopPlayer();
//       if(widget.isReplay){
//         return await Provider.of<UserDataProvider>(context,listen: false)
//             .newReplyVoiceComment(
//           post:widget.post,
//           voiceCommentUrl: recordPath!,
//           voiceFile: recordeFile,
//           commentIndex: widget.commentIndex,)
//             .then((value){
//           loading=false;
//         })
//             .catchError((error){
//           print(error.toString());
//         });
//       }
//       else{
//         return await Provider.of<UserDataProvider>(context,listen: false)
//             .newVoiceCommentOnPost(
//           post: widget.post,
//           voiceCommentUrl: recordPath!,
//           voiceFile: recordeFile,)
//             .then((value){
//           loading=false;
//         })
//             .catchError((error){
//           print(error.toString());
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var userProvider = Provider.of<UserDataProvider>(context, listen: true);
//       return Column(
//           children: [
//             SizedBox(height: 10.0,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   soundRecorder!.isRecording
//                       ? Icons.record_voice_over_outlined
//                       : Icons.mic,
//                   //size: 25,
//                 ),
//                 SizedBox(
//                   width: 10.0,
//                 ),
//                 Text(
//                     soundRecorder!.isRecording
//                         ? 'Recording ...'
//                         : 'Press on Record to recording your comment ',
//                     style: soundRecorder!.isRecording
//                         ? Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.red)
//                         :
//                     Theme.of(context).textTheme.subtitle1,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis),
//               ],
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             CustomTimer(
//               controller: timeController,
//               from: Duration(minutes:10),
//               to: Duration(seconds: 0),
//               interval: Duration(seconds: 1),
//               builder: (CustomTimerRemainingTime remaining) {
//                 counter =
//                     "${(min-(int.parse(remaining.minutes))) == -1 ? 0 : min-(int.parse(remaining.minutes))}"
//                         ":${(sec-(int.parse(remaining.seconds)))==59 ? 0 : sec-(int.parse(remaining.seconds))}";
//                 if(int.parse(remaining.minutes) == 00 && int.parse(remaining.seconds) == 01){
//                   timeController.pause();
//                   stopRecorder();
//                   getRecorderFn();
//                 }
//                 return Text(
//                   "$counter",
//                   style: TextStyle(fontSize: 30.0),
//                 );
//               },
//             ),
//             SizedBox(height: 5.0,),
//             Text('You only have 10 minutes per comment'),
//             SizedBox(
//               height: 20.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   width: 80,
//                   child: MaterialButton(
//                     onPressed: getRecorderFn(),
//                     color: soundRecorder!.isRecording? Colors.grey: Colors.white,
//                     textColor: Colors.black54,
//                     child: Icon(
//                       soundRecorder!.isRecording
//                           ? Icons.record_voice_over_outlined
//                           : Icons.fiber_manual_record,
//                       color: soundRecorder!.isRecording
//                           ? Colors.white
//                           : Colors.red,
//                     ),
//                     shape: CircleBorder(),
//                   ),
//                 ),
//                 Container(
//                   width: 60,
//                   child: Center(
//                     child: MaterialButton(
//                       onPressed:getPlaybackFn(),
//                       color: Colors.white,
//                       textColor: Colors.black54,
//                       child: //Text(soundPlayer!.isPlaying ? 'Stop' : 'Play'),
//                          soundPlayer!.isPlaying ?Icon(Icons.stop):Icon(Icons.play_arrow),
//                       shape: CircleBorder(),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 68,
//                   child: MaterialButton(
//                     onPressed:()=>send(),
//                     color: Colors.white,
//                     textColor: Colors.black54,
//                     child: Text('Send'),
//                     //Icon(Icons.send),
//                     shape: CircleBorder(),
//                   ),
//                 ),
//                 Container(
//                   width: 60,
//                   child: MaterialButton(
//                     onPressed: () {
//                       userProvider.changeOpenVoiceRecorderContainer();
//                     },
//                     color: Colors.white,
//                     textColor: Colors.black54,
//                     child: Text('Exit'),
//                     shape: CircleBorder(),
//                   ),
//                 )
//               ],
//             ),
//             if(loading)
//               LinearProgressIndicator()
//           ],
//       );
//   }
// }
