class CommentModel {

  String id;
  String commentType;
  List<dynamic> replyComments;
  String userImage;
  String userName;
  String text;
  String image;
  String video;
  String voice;
  String dateTime;
  List<dynamic> likes;
  Map<String,dynamic> body;


  CommentModel({
    required this.id,
    required this.commentType,
    required this.replyComments,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.image,
    required this.video,
    required this.voice,
    required this.dateTime,
    required this.likes,
    required this.body,

  });

}