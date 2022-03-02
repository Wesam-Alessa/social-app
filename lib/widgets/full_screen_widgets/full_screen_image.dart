import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreenImage extends StatefulWidget {
  final String url;

  FullScreenImage({Key? key, required this.url}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> with SingleTickerProviderStateMixin {
  late TransformationController imageController;
  TapDownDetails? tapDownDetails;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  Dio dio = Dio();
  double progress = 0.0;
  bool loading = false;

  @override
  void initState(){
  super.initState();
  imageController = TransformationController();
  animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  )..addListener(() {
    imageController.value = animation!.value;
  });
}
  @override
  void dispose(){
    imageController.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<bool> requestDownloadFilePermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> saveFile(String url, bool isVideo, context) async {
    String fileName = isVideo ? 'video.mp4' : 'image.jpg';
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await requestDownloadFilePermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          print(directory.path);
          String newPath = '';
          List<String> folders = directory.path.split('/');
          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];
            if (folder != 'Android') {
              newPath += '/' + folder;
            } else {
              break;
            }
          }
          newPath = newPath + '/ChatApp';
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      } else {
        if (await requestDownloadFilePermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + '/$fileName');
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize;
          });
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> downloadFile(context, String url, bool isVideo) async {
    setState(() {
      loading = true;
    });
    bool downloaded = await saveFile(url, isVideo, context);
    if (downloaded) {
      print("File downloaded");
    } else {
      print("Problem Downloaded File");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                downloadFile(context, widget.url, false).then((value) {
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
        body: loading
            ? AlertDialog(
                title: Column(
                  children: [
                    Text(
                      'please wait...',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    LinearProgressIndicator(
                      minHeight: 10,
                      value: progress,
                    )
                  ],
                ),
              )
            : Center(
                child: Container(
                  color: Colors.black54,
                  child: buildImage()

                ),
              ));
  }

  Widget buildImage() => GestureDetector(
    onDoubleTapDown: (details)=> tapDownDetails = details,
    onDoubleTap: (){
      final position = tapDownDetails!.localPosition;
      final double scale = 3;
      final x = -position.dx * (scale - 1);
      final y = -position.dy * (scale - 1);
      final zoomed = Matrix4.identity()..translate(x,y)..scale(scale);
      // if you want to zooming directly
      // final value = imageController.value.isIdentity() ? zoomed : Matrix4.identity();
      // imageController.value = value;

      // zooming with animation duration 300 milliseconds
      final end = imageController.value.isIdentity() ? zoomed :  Matrix4.identity();
      animation = Matrix4Tween(
        begin: imageController.value,
        end: end,
      ).animate(CurveTween(curve:Curves.easeOut).animate(animationController));
      animationController.forward(from: 0);
    },
    child: InteractiveViewer(
      transformationController: imageController,
      clipBehavior: Clip.none,
      panEnabled: false,
      scaleEnabled: false,
      child: AspectRatio(
            aspectRatio: 1/2,
          child: Image.network(
          widget.url,
          ),
          ),
    ),
  );
}
