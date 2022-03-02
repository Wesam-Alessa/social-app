import 'package:chat/modules/post_model.dart';
import 'package:chat/widgets/post_widget/Posts_widget.dart';
import 'package:flutter/material.dart';

class FullPostScreen extends StatefulWidget {

   PostModel post;

   FullPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _FullPostScreenState createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: PostWidget(post: widget.post,),
    );
  }
}
