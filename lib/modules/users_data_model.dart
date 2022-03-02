
class UsersModel {

  String userId;

  String email;

  String username;

  String userBio;

  String userImage;

  String coverImage;

  Map<String,dynamic> details;

  List<dynamic> myFriends = [];

  List<dynamic> myStory = [];

  UsersModel(
      this.userId,
      this.email,
      this.username,
      this.userBio,
      this.userImage,
      this.coverImage,
      this.details,
      this.myFriends,
      this.myStory
      );


  UsersModel.fromJson(Map<String, dynamic> json) :
        userId = json['userId'] ?? "",
        email = json['email'] ?? "",
        username = json['username'] ?? "",
        userBio = json['userBio'] ?? "",
        userImage = json['image_url'] ?? "",
        coverImage = json['cover_image'] ?? "",
        myFriends = json['my_friends'] ?? [],
        myStory = json['my_story'] ?? [],
        details = json['details'] ?? {
          'works at':'',
          'lives in':'',
          'from':'',
          'relationship':'',
          'education':{
            'college':'',
            'high school':'',
          },
          'contact info':{
            "email":"",
            "mobile number":"",
          },
          'basic info':{
            'gender':'',
            'birthday':'',
            'languages':[],
          },
        };


  Map<String, dynamic> toMap()=> {
    "userId": userId,
    "email": email,
    "username": username,
    'userBio': userBio,
    "image_url": userImage,
    "cover_image": coverImage,
    'details':details,
    'my_friends':myFriends,
    'my_story':myStory,
  };
}
