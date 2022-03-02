import 'dart:io';

import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class VoiceRecorderWidget extends StatefulWidget {
  const VoiceRecorderWidget({Key? key}) : super(key: key);

  @override
  _VoiceRecorderWidgetState createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  FlutterSoundRecorder? soundRecorder = FlutterSoundRecorder();
  CustomTimerController timeController = new CustomTimerController();
  String recordPath = '';
  bool soundRecorderIsInit = false;
  var counter;
  bool isRecord = false;

  @override
  void initState() {
    super.initState();
    counter = "";
    openRecorder();
  }

  Future<void> openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await soundRecorder!.openAudioSession();
    setState(() {
      soundRecorderIsInit = true;
    });
  }

  Future<void> startRecord() async {
    print('START RECORD');
    setState(() {
      isRecord =true;
    });
    //timeController.reset();
    assert(soundRecorderIsInit);
    //timeController.start();
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');
    recordPath = outputFile.path;
    await soundRecorder!.startRecorder(
      toFile: outputFile.path,
      codec: Codec.aacADTS,
    );
    setState(() {});
  }

  Future<void> stopRecorder() async {
    await soundRecorder!.stopRecorder();
    //timeController.pause();
    setState(() {});
  }

  getRecorderFn() {
    if (!soundRecorderIsInit) {
      return null;
    }
    return soundRecorder!.isStopped
        ? startRecord
        : () {
            stopRecorder().then((value) => setState(() {}));
          };
  }


  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    return GestureDetector(
      onLongPress: () {
         setState(() {
           userProvider.changeIsRecordingVoiceMessage();
           startRecord();
         });
      },
      onLongPressUp: () {
        setState(() {
          isRecord = false;
          userProvider.changeIsRecordingVoiceMessage();
        });
        File? voiceFile;
        stopRecorder().then((value) {
          if(recordPath.isNotEmpty) {
            voiceFile = File(recordPath);
            userProvider..setMessageVoiceFile(voiceFile!);
          }
          print('STOP RECORD');
        });
      },
      child: Icon(
        IconBroken.Voice,
        size: 22,
        color: Theme.of(context).primaryColor,
      )
      // !isRecord ?
      // :
      // Container(
      //   height: 50,
      //   //width: 150,
      //   child: Row(
      //     children: [
      //       Icon(
      //         IconBroken.Voice,
      //         size: 22,
      //         color: Theme.of(context).primaryColor,
      //       ),
      //       Container(
      //           height: 50,
      //           width: 150,
      //           child: Image.asset('assets/images/loading.gif',fit: BoxFit.cover,)),
      //     ],
      //   ),
      //),
    );
  }
}
