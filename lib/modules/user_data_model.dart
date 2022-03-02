class UserModel {
  String userId;
  String email;
  String password;
  String username;
  String userBio;
  String userImage;
  String coverImage;
  bool isEmailVerified;
  Map<String, dynamic> details;
  List<dynamic> myFriends = [];
  List<dynamic> myStory = [];
  List<dynamic> friendshipRequests = [];
  List<dynamic> saved = [];
  List<dynamic> hiddenPost = [];

  UserModel(
    this.userId,
    this.email,
    this.password,
    this.username,
    this.userBio,
    this.userImage,
    this.coverImage,
    this.isEmailVerified,
    this.details,
    this.myFriends,
    this.myStory,
    this.friendshipRequests,
    this.saved,
      this.hiddenPost
  );

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] ?? "",
        email = json['email'] ?? "",
        password = json['password'] ?? "",
        username = json['username'] ?? "",
        userBio = json['userBio'] ?? "",
        userImage = json['image_url'] ?? "",
        coverImage = json['cover_image'] ?? "",
        isEmailVerified = json['isEmailVerified'] ?? false,
        myFriends = json['my_friends'] ?? [],
        myStory = json['my_story'] ?? [],
        friendshipRequests = json['friendshipRequests'] ?? [],
        details = json['details'] ??
            {
              'works at': '',
              'lives in': '',
              'from': '',
              'relationship': '',
              'education': {
                'college': '',
                'high school': '',
              },
              'contact info': {
                "email": "",
                "mobile number": "",
              },
              'basic info': {
                'gender': '',
                'birthday': '',
                'languages': [],
              },
            },
        saved = json['saved'] ??[],
        hiddenPost =  json['hiddenPost'] ??[]

  ;

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "email": email,
        "password": password,
        "username": username,
        'userBio': userBio,
        "image_url": userImage,
        "cover_image": coverImage,
        "isEmailVerified": isEmailVerified,
        'details': details,
        'my_friends': myFriends,
        'my_story': myStory,
        'friendshipRequests': friendshipRequests,
        'saved':saved,
   'hiddenPost':hiddenPost,
      };
}
