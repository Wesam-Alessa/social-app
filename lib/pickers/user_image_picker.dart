import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickedFn;

  UserImagePicker(this.imagePickedFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageFile =
        await _picker.pickImage(source: src, imageQuality: 50, maxWidth: 150);

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickedFn(_pickedImage!);
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:()=> _pickImage(ImageSource.camera),
              child: CircleAvatar(
                radius: 18,
                backgroundColor:Color(0xff14279B) ,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Icon(
                    Icons.photo_camera,
                    color:Colors.white ,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: ()=>_pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 18,
                backgroundColor:Color(0xff14279B) ,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Icon(
                    Icons.image_outlined,
                    color:Colors.white ,
                  ),
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () => _pickImage(ImageSource.camera),
            //   icon: Icon(
            //     Icons.photo_camera,
            //     color: Colors.white,
            //   ),
            //   color: Color(0xff14279B),
            //   // label: Text('',
            //   //  // "Add Image\nfrom Camera",
            //   //   style: TextStyle(color: Colors.white),
            //   //   textAlign: TextAlign.center,
            //   // ),
            // ),
            // ElevatedButton.icon(
            //   onPressed: () => _pickImage(ImageSource.gallery),
            //   icon: Icon(Icons.image_outlined),
            //   label: Text(
            //     '',
            //     //"Add Image\nfrom Gallery",
            //     style: TextStyle(color: Colors.white),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
