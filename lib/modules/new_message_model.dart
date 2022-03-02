class NewMessageModel {
  String text;
  String createdAt;
  String username;
  String senderId;
  String receiverId;
  String image;
  String video;
  String voice;
  String postId;

  NewMessageModel({
    required this.text,
    required this.createdAt,
    required this.username,
    required this.senderId,
    required this.receiverId,
    required this.image,
    required this.video,
    required this.voice,
    required this.postId

  });

  NewMessageModel.fromJson(Map<String, dynamic> json) :
        senderId = json['senderId'] ?? "",
        receiverId = json['receiverId'] ?? "",
        text = json['text'] ?? "",
        image = json['image'] ?? "",
        video = json['video'] ?? "",
        voice = json['voice'] ?? "",
        postId = json['postId'] ?? "",
        createdAt = json['createdAt'] ?? "",
        username = json['username'] ?? "";

  Map<String, dynamic> toMap()=> {
    "senderId": senderId,
    "receiverId": receiverId,
    "text": text,
    "image": image,
    "video": video,
    "voice": voice,
    'postId':postId,
    "username": username,
    'createdAt': createdAt,
  };

}
