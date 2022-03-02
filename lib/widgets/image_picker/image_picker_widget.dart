import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
        builder:(context,userProvider,_)=>Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white60,
                onPressed: () => userProvider.pickAnyImage(ImageSource.camera)
                  .then((value) {
                userProvider.commentImage = null;
                userProvider.commentImage = value;
              })
                  .catchError((error){
                print('error pick image camera');
              }),
                child: const Icon(IconBroken.Camera,color:Colors.black ,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white60,
                onPressed: () =>userProvider.pickAnyImage(ImageSource.gallery)
                    .then((value) {
                  userProvider.commentImage = null;
                  userProvider.commentImage = value;
                })
                    .catchError((error){
                  print('error pick image gallery');
                }),
                child:const Icon(IconBroken.Image_2,color:Colors.black ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white60,
                onPressed: () =>userProvider.changeOpenImagePickerCommentContainer(),
                child:const Icon(Icons.close,color:Colors.black ),
              ),
            ),
          ],
        )
    );

  }
}
