import 'dart:io';

import 'package:chat/widgets/video_picker_and_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreenVideo extends StatefulWidget {
  final bool isOnline;
  final String url;
   FullScreenVideo({Key? key,required this.url, required this.isOnline}) : super(key: key);

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {


  Future<bool> requestDownloadFilePermission(Permission permission) async {
    if(await permission.isGranted){
      return true;
    }else{
      var result = await permission.request();
      if(result == PermissionStatus.granted){
        return true;
      }else{
        return false;
      }
    }
  }

  Dio dio = Dio();
  double progress = 0.0;
  bool loading = false;

  Future<bool> saveFile(String url,bool isVideo,context) async {
    String fileName = isVideo ? 'video.mp4' : 'image.jpg';
    Directory directory;
    try{
      if(Platform.isAndroid){
        if(await requestDownloadFilePermission(Permission.storage)){
          directory = (await getExternalStorageDirectory())!;
          print(directory.path);
          String newPath = '';
          List<String> folders = directory.path.split('/');
          for(int i = 1;i<folders.length;i++){
            String folder = folders[i];
            if(folder !='Android'){
              newPath += '/'+folder;
            }else{
              break;
            }
          }
          newPath = newPath+'/ChatApp';
          directory = Directory(newPath);
          print(directory.path);
        }else{
          return false;
        }
      }
      else{
        if(await requestDownloadFilePermission(Permission.photos)){
          directory = await getTemporaryDirectory();
        }
        else{
          return false;
        }
      }
      if(!await directory.exists() ){
        await directory.create(recursive: true);
      }
      if(await directory.exists()){
        File saveFile = File(directory.path+'/$fileName');
        await dio.download(url, saveFile.path,onReceiveProgress:(downloaded,totalSize){
          setState(() {
            progress = downloaded/totalSize;
          });
        });
        if(Platform.isIOS){
          await ImageGallerySaver.saveFile(saveFile.path,isReturnPathOfIOS: true);
        }
        return true;
      }
    }
    catch(e){
      print(e);
    }
    return false;
  }

  Future<void> downloadFile(context,String url,bool isVideo) async {
    setState(() {
      loading = true;
    });
    bool downloaded = await saveFile(url,isVideo,context);
    if(downloaded){
      print("File downloaded");
    }
    else{
      print("Problem Downloaded File");
    }
   setState(() {
     loading = false;
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black54 ,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              downloadFile(context, widget.url, true)
                  .then((value){
                Navigator.pop(context);
              });
            },
            icon: Icon(
              Icons.download,
              size: 22.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: loading ?
      AlertDialog(
        title: Column(
          children: [
            Text(
              'please wait...',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 5.0,),
            LinearProgressIndicator(
              minHeight: 10,
              value: progress,
            )
          ],
        ),
      )
          :
      Center(
    child: Container(
    color: Colors.black54,
      child: VideoPlayerWidget(isOnlineVideo:widget.isOnline ,url:widget.url),
    ),
    ),
    );
  }
}
