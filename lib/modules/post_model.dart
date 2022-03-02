

class PostModel{
  String postId;
  String userId;
  String username;
  String userImage;
  String textBody;
  String postImage;
  String postVideo;
  String dateTime;
  List<dynamic> likes ;
  List<dynamic> comments ;
  List<dynamic> postTags;

  PostModel(
      this.postId,
      this.userId,
      this.username,
      this.userImage,
      this.textBody,
      this.postImage,
      this.postVideo,
      this.postTags,
      this.dateTime,
      this.likes,
      this.comments,

      );


  PostModel.fromJson(Map<String, dynamic> json, String id) :
        postId = id,
        userId = json['userId'] ?? "",
        username = json['username'] ?? "",
        userImage = json['userImage'] ?? "",
        textBody = json['textBody'] ?? "",
        postImage = json['postImage'] ?? '',
        postVideo = json['postVideo'] ?? '',
        dateTime = json['dateTime'] ?? '',

        likes = json['likes'] ?? [],
        comments = json['comments']??[],
        postTags = json['postTags'] ?? [];


  Map<String, dynamic> toMap()=> {
    'postId':postId,
    "userId": userId,
    "username": username,
    "userImage": userImage,
    "textBody": textBody,
    "dateTime": dateTime,
    "postImage": postImage,
    'postVideo':postVideo,
    'likes':likes,
    'comments':comments,
    'postTags':postTags,
  };
}