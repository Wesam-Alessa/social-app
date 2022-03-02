import 'dart:io';

import 'package:chat/modules/friends_model.dart';
import 'package:chat/modules/new_message_model.dart';
import 'package:chat/modules/post_model.dart';
import 'package:chat/modules/user_data_model.dart';
import 'package:chat/modules/users_data_model.dart';
import 'package:chat/modules/story_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserDataProvider with ChangeNotifier {
  late UserModel user;
  ImagePicker imagePicker = ImagePicker();
  bool loading = false;


  void init() {
    var j = {
      "userId": '',
      "email": '',
      "password": '',
      "username": '',
      'userBio': '',
      "userImage": '',
      "coverImage": '',
      "isEmailVerified": true,
      'my_friends': [],
      'my_story': [],
      'details': {
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
      'saved': []
    };
    user = UserModel.fromJson(j);
  }

  void nullAllValues() {
    openVoiceRecorderContainer = false;
    openImagePickerCommentContainer = false;
    openVideoPickerCommentContainer = false;
    commentImage = null;
    commentVideo = null;
    replayCommentVideo = null;
    notifyListeners();
  }

  Future<void> getUserData({required String uId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      var data = value.data() ?? {};
      user = UserModel.fromJson(data);
    }).catchError((error) {
      print(error.toString());
      throw error;
    });
    if (user.myStory.isNotEmpty) {
      myStories = convertStoriesFromJsonToListOfStories(user.myStory);
    }
    getMyFriends();
    notifyListeners();
  }

  Future<File> pickAnyImage(ImageSource src) async {
    nullAllValues();
    var image;
    await imagePicker
        .pickImage(
      source: src,
    )
        .then((value) {
      image = File(value!.path);
    }).catchError((error) {
      print(error.toString());
    });
    notifyListeners();
    return image;
  }

  Future<File> pickAnyVideo(ImageSource src) async {
    nullAllValues();
    var video;
    await imagePicker
        .pickVideo(
      source: src,
    )
        .then((value) {
      video = File(value!.path);
    }).catchError((error) {
      print(error.toString());
    });
    notifyListeners();
    return video;
  }


  List searchList = [];
  void search(String searchChar)async{
    searchList = [];
    notifyListeners();
     if(searchChar.isNotEmpty){
      if(myFriends.isNotEmpty){
        myFriends.forEach((element) {
          if(element.username.toLowerCase().contains(searchChar.toLowerCase())){
            searchList.add({
              'type':'friend',
              'value':element
            });
          }
        });
      }
      if(allUsers.isNotEmpty){
        allUsers.forEach((element) {
          if(element.username.toLowerCase().contains(searchChar.toLowerCase())){
            searchList.add({
              'type':'user',
              'value':element
            });
          }
        });
      }
      // if(posts.isNotEmpty){
      //   posts.forEach((element){
      //     if(element.username != user.username){
      //       if(element.username.toLowerCase().contains(searchChar.toLowerCase()) ||
      //           element.textBody.toLowerCase().contains(searchChar.toLowerCase())){
      //         searchList.add({
      //           'type':'post',
      //           'value':element
      //         });
      //       }
      //     }
      //   });
      // }
      notifyListeners();
    }
  }

  //-------------------------- start suggestion Friends and Friendship Requests and chats functions ----------------------------------
  //*************************************************************************************
  List<FriendsModel> myFriends = [];
  List<UsersModel> allUsers = [];
  List outgoingFriendshipRequests = [];
  List incomingFriendshipRequests = [];
  List<UsersModel> usersOutgoingFriendshipRequests = [];
  List<UsersModel> usersIncomingFriendshipRequests = [];
  Map<String, dynamic> friendshipRequest = {
    'sender': '', // user.userId
    'receiver': '', // receiver Id
    'state': '', // acceptable or unAcceptable
  };
  File? messageVoiceFile;
  FriendsModel? myFriendChat;

  List<NewMessageModel> messages = [];
  bool isRecordingVoiceMessage = false;
  List<FriendsModel> friendsOfMyFriends = [];

  setMessageVoiceFile(File file) {
    messageVoiceFile = file;
    notifyListeners();
  }

  deleteMessageVoiceFile() {
    messageVoiceFile = null;
    commentVideo = null;
    commentImage = null;
    replayCommentVideo = null;
    notifyListeners();
  }

  void changeIsRecordingVoiceMessage() {
    isRecordingVoiceMessage = !isRecordingVoiceMessage;
    notifyListeners();
  }

  UsersModel findUsersFriendshipRequests(String id) {
    return allUsers.firstWhere((e) => e.userId == id);
  }

  void deleteUserFromAllUsers({required String id}) {
    allUsers.removeAt(allUsers.indexWhere((element) => element.userId == id));
    notifyListeners();
  }

  void sortFriendRequests() {
    outgoingFriendshipRequests.clear();
    incomingFriendshipRequests.clear();
    usersOutgoingFriendshipRequests.clear();
    usersIncomingFriendshipRequests.clear();
    if (user.friendshipRequests.isNotEmpty) {
      user.friendshipRequests.forEach((element) {
        if (element['sender'] == user.userId) {
          outgoingFriendshipRequests.add(element);
          usersOutgoingFriendshipRequests
              .add(findUsersFriendshipRequests(element['receiver'])
                  //UsersModel.fromJson(user.toMap())
                  );
          deleteUserFromAllUsers(id: element['receiver']);
        } else {
          incomingFriendshipRequests.add(element);
          usersIncomingFriendshipRequests
              .add(findUsersFriendshipRequests(element['sender']));
          deleteUserFromAllUsers(id: element['sender']);
        }
      });
    }
    notifyListeners();
  }

  Future<void> getMyFriends() async {
    if (user.myFriends.isNotEmpty && myFriends.isEmpty) {
     // myFriends = [];
      for (int i = 0; i < user.myFriends.length; i++) {
       await FirebaseFirestore.instance
            .collection('users')
            .doc(user.myFriends[i].toString())
            .get()
            .then((value) {
          var data = value.data() ?? {};
          if (myFriends.indexWhere((element) => data['userId'] == element.userId) == -1) {
            myFriends.add(FriendsModel.fromJson(data));
            if (myFriends[i].myStory.isNotEmpty) {
              myFriends[i].myStory =
                  convertStoriesFromJsonToListOfStories(myFriends[i].myStory);
            }
          }
        }).catchError((error) {
          print(error.toString());
          throw error;
        });
      }
      notifyListeners();
    }
    else if(user.myFriends.isNotEmpty && myFriends.isNotEmpty){
      List ides = [];
      user.myFriends.forEach((element) {
       if(myFriends.indexWhere((e) => element == e.userId) == -1){
         ides.add(element);
       }
      });
     for (int i = 0; i < ides.length; i++) {
       await FirebaseFirestore.instance
            .collection('users')
            .doc(ides[i].toString())
            .get()
            .then((value) {
          var data = value.data() ?? {};
          myFriends.add(FriendsModel.fromJson(data));
          if (myFriends[i].myStory.isNotEmpty) {
            myFriends[i].myStory =
                convertStoriesFromJsonToListOfStories(myFriends[i].myStory);
          }
        });
      }
     notifyListeners();
    }
  }

  Future<void> getAllUsers() async {
    await getUserData(uId: user.userId).then((v) async {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        allUsers.clear();
        value.docs.forEach((element) {
          if (element.data()['userId'] != user.userId
          &&
              (myFriends.indexWhere(
                      (e) => element.data()['userId'] == e.userId) ==
                  -1)
          ) {
            allUsers.add(UsersModel.fromJson(element.data()));
          }
        });
      }).catchError((error) {
        print(error.toString());
        throw error;
      });
    }).catchError((e) {
      throw e;
    });
    sortFriendRequests();
    notifyListeners();
  }

  Future<FriendsModel> getFriendsOfMyFriends(FriendsModel friend) async {
    List<FriendsModel> newFriends = [];
    friend.myFriends.forEach((element) {
       FirebaseFirestore.instance
           .collection('users')
          .doc(element)
          .get()
          .then((value) {
         var data = value.data() ?? {};
         newFriends.add(FriendsModel.fromJson(data));
      });
    });
    friend.myFriends = newFriends;
    return friend;
  }

  Future<void> addFriend({required String receiverId}) async {
    var request = friendshipRequest;
    request['sender'] = user.userId;
    request['receiver'] = receiverId;
    request['state'] = 'unAcceptable';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .update({
      'friendshipRequests': FieldValue.arrayUnion([request])
    }).then((value) async {
      var newUser = user;
      newUser.friendshipRequests.add(request);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .update(newUser.toMap())
          .then((value) {})
          .catchError((onError) {});
      getAllUsers();
      getUserData(uId: user.userId);
      notifyListeners();
    }).catchError((onError) {});
    notifyListeners();
  }

  Future<void> acceptFriendRequest(
      {required Map<String, dynamic> request}) async {
    await deleteFriendRequest(request: request).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request['receiver'])
          .update({
        'my_friends': FieldValue.arrayUnion([request['sender']])
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(request['sender'])
            .update({
              'my_friends': FieldValue.arrayUnion([request['receiver']])
            })
            .then((value) {})
            .catchError((onError) {});
      }).catchError((onError) {});
      getAllUsers();
      getUserData(uId: user.userId);
      notifyListeners();
    }).catchError((onError) {});
    notifyListeners();
  }

  Future<void> deleteFriendRequest(
      {required Map<String, dynamic> request}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(request['receiver'])
        .update({
      'friendshipRequests': FieldValue.arrayRemove([request])
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request['sender'])
          .update({
            'friendshipRequests': FieldValue.arrayRemove([request])
          })
          .then((value) {})
          .catchError((onError) {});
      getAllUsers();
    }).catchError((onError) {});
    notifyListeners();
  }

  void getMessages() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .collection('chats')
        .doc(myFriendChat!.userId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      addMessages(event.docs);
    });
  }

  void addMessages(List messagesList) {
    messages = [];
    messagesList.forEach((element) {
      messages.add(NewMessageModel.fromJson(element.data()));
    });
    notifyListeners();
  }

  Future<void> sendMessage({
    String? text,
    File? image,
    File? video,
    File? voice,
    String? postId,
    required String createdAt,
    required String receiverId,
  }) async {
    if (text != null &&
        postId == null &&
        image == null &&
        video == null &&
        messageVoiceFile == null) {
      var message = NewMessageModel(
        text: text,
        image: '',
        video: '',
        voice: '',
        postId: '',
        createdAt: createdAt,
        username: user.username,
        senderId: user.userId,
        receiverId: receiverId,
      );
      //set message into my chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .collection('chats')
          .doc(message.receiverId)
          .collection('messages')
          .add(message.toMap())
          .then((value) {})
          .catchError((error) {});
      //set message into my friend chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(message.receiverId)
          .collection('chats')
          .doc(user.userId)
          .collection('messages')
          .add(message.toMap())
          .then((value) {})
          .catchError((error) {});
    } else if (text == null &&
        postId == null &&
        image != null &&
        video == null &&
        messageVoiceFile == null) {
      //set image message into my chats
      await FirebaseStorage.instance
          .ref()
          .child(
              'chats/${user.userId}/$receiverId/images/${Uri.file(image.path).pathSegments}')
          .putFile(image)
          .then((value) {
        value.ref.getDownloadURL().then((val) async {
          var message = NewMessageModel(
            text: '',
            video: '',
            voice: '',
            postId: '',
            image: val.toString(),
            createdAt: createdAt,
            username: user.username,
            senderId: user.userId,
            receiverId: receiverId,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.userId)
              .collection('chats')
              .doc(message.receiverId)
              .collection('messages')
              .add(message.toMap())
              .then((value) {})
              .catchError((error) {});
          //set image message into my friend chats
          await FirebaseFirestore.instance
              .collection('users')
              .doc(message.receiverId)
              .collection('chats')
              .doc(user.userId)
              .collection('messages')
              .add(message.toMap())
              .then((value) {})
              .catchError((error) {});
        });
      }).catchError((error) {});
    } else if (text == null &&
        postId == null &&
        image == null &&
        video != null &&
        messageVoiceFile == null) {
      //set video message into my chats
      await FirebaseStorage.instance
          .ref()
          .child(
              'chats/${user.userId}/$receiverId/videos/${Uri.file(video.path).pathSegments}')
          .putFile(video)
          .then((value) {
        value.ref.getDownloadURL().then((val) async {
          var message = NewMessageModel(
            text: '',
            video: val.toString(),
            image: '',
            voice: '',
            postId: '',
            createdAt: createdAt,
            username: user.username,
            senderId: user.userId,
            receiverId: receiverId,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.userId)
              .collection('chats')
              .doc(message.receiverId)
              .collection('messages')
              .add(message.toMap())
              .then((value) {})
              .catchError((error) {});
          //set video message into my friend chats
          await FirebaseFirestore.instance
              .collection('users')
              .doc(message.receiverId)
              .collection('chats')
              .doc(user.userId)
              .collection('messages')
              .add(message.toMap())
              .then((value) {})
              .catchError((error) {});
        });
      }).catchError((error) {});
    } else if (text == null &&
        postId == null &&
        image == null &&
        video == null &&
        messageVoiceFile != null) {
      //set voice message into my chats
      await FirebaseStorage.instance
          .ref()
          .child(
              'chats/${user.userId}/$receiverId/voices/$createdAt + ${Uri.file(messageVoiceFile!.path).pathSegments}')
          .putFile(messageVoiceFile!)
          .then((value) {
        value.ref.getDownloadURL().then((val) async {
          var message = NewMessageModel(
            text: '',
            video: '',
            image: '',
            voice: val.toString(),
            postId: '',
            createdAt: createdAt,
            username: user.username,
            senderId: user.userId,
            receiverId: receiverId,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.userId)
              .collection('chats')
              .doc(message.receiverId)
              .collection('messages')
              .add(message.toMap())
              .then((value) {})
              .catchError((error) {});
          //set voice message into my friend chats
          await FirebaseFirestore.instance
              .collection('users')
              .doc(message.receiverId)
              .collection('chats')
              .doc(user.userId)
              .collection('messages')
              .add(message.toMap())
              .then((value) {
            messageVoiceFile = null;
          }).catchError((error) {});
        });
      }).catchError((error) {});
    } else if (text == null &&
        postId != null &&
        image == null &&
        video == null &&
        messageVoiceFile == null) {
      var message = NewMessageModel(
        text: '',
        image: '',
        video: '',
        voice: '',
        postId: postId,
        createdAt: createdAt,
        username: user.username,
        senderId: user.userId,
        receiverId: receiverId,
      );
      //set message into my chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .collection('chats')
          .doc(message.receiverId)
          .collection('messages')
          .add(message.toMap())
          .then((value) {})
          .catchError((error) {});
      //set message into my friend chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(message.receiverId)
          .collection('chats')
          .doc(user.userId)
          .collection('messages')
          .add(message.toMap())
          .then((value) {})
          .catchError((error) {});
    }
    //don't do notifyListeners() here because we did stream builder in chat screen;
  }

  //-------------------------- end suggestion Friends and Friendship Requests and chats functions ----------------------------------
  //*************************************************************************************

  //-------------------------- start post functions ----------------------------------
  //*************************************************************************************
  File? postImage;
  var postImageUrl;
  File? postVideo;
  var postVideoUrl;
  List<PostModel> posts = [];
  List<PostModel> savedPost = [];
  List<PostModel> myPosts = [];
  List<PostModel> myFriendPosts = [];

  void getPosts() {
    posts = [];
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      addPosts(event.docs);
    });
    //      .get()
    //      .then((value) {
    //      value.docs.forEach((element) {
    //        if(!user.hiddenPost.contains(element.id)){
    //          posts.add(PostModel.fromJson(element.data(), element.id));
    //          posts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    //        }
    //    });
    //  }).catchError((error) {
    //    print(error.toString());
    //    throw error;
    //  });
    //  getSavedPosts();
    // notifyListeners();
  }

  void addPosts(List allPosts) {
    posts = [];
    allPosts.forEach((element) {
      if (!user.hiddenPost.contains(element.id)) {
        posts.add(PostModel.fromJson(element.data(), element.id));
      }
    });
    posts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> deletePost(String postId) async{
    loading = true;
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value){
          loading = false;
    })
        .catchError((onError){
          loading = false;
    });
    notifyListeners();
  }

  void getSavedPosts() {
    savedPost.clear();
    if (user.saved.isNotEmpty) {
      user.saved.forEach((e) {
        savedPost.add(posts.firstWhere((element) => element.postId == e));
      });
    }
  }

  void getMyPost() {
    myPosts.clear();
    posts.forEach((element) {
      if (element.userId == user.userId) {
        myPosts.add(element);
        myPosts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      }
    });
  }

  void getMyFriendPosts(String friendId) {
    myFriendPosts.clear();
    posts.forEach((element) {
      if (element.userId == friendId) {
        myFriendPosts.add(element);
        myFriendPosts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      }
    });
    notifyListeners();
  }

  Future<void> createNewPost(
      {required String text,
      required List<String> tags,
      required String date,
      required String postImage,
      required String postVideo}) async {
    loading = true;
    notifyListeners();
    PostModel postModel = PostModel(
      '',
      user.userId,
      user.username,
      user.userImage,
      text,
      postImage,
      postVideo,
      tags,
      date,
      [],
      [],
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap(),)
        .then((value) {
         postModel.postId = value.id;
         FirebaseFirestore.instance
          .collection('posts')
         .doc(value.id)
         .update(postModel.toMap());
      //posts.add(postModel);
      loading = false;
    }).catchError((error) {
      //posts.remove(postModel);
      loading = false;
    });
   notifyListeners();
  }

  Future<void> hidePost(String postId) async {
    loading = true;
    user.hiddenPost.add(postId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(user.toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
        posts.remove(posts.firstWhere((element) => element.postId == postId));
      });
    }).catchError((error) {
      print('Error hide post' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateSavedPosts(List savedPosts) async {
    loading = true;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          user.details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          savedPosts,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        getSavedPosts();
        loading = false;
      });
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }

  Future<void> deleteSavedPosts(String postId) async {
    user.saved.remove(postId);
    updateSavedPosts(user.saved);
    savedPost
        .remove(savedPost.firstWhere((element) => element.postId == postId));
    notifyListeners();
  }

  void deletePostImage() {
    postImage = null;
    postImageUrl = null;
    notifyListeners();
  }

  void deletePostVideo() {
    postVideo = null;
    postVideoUrl = null;
    notifyListeners();
  }

  Future<void> uploadPostImage(
      {required String text,
      required List<String> tags,
      required String date}) async {
    loading = true;
    notifyListeners();
    await FirebaseStorage.instance
        .ref()
        .child(
            'posts/${user.userId}/$date/images/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((val) {
        postImageUrl = val.toString();
        createNewPost(
            text: text,
            tags: tags,
            date: date,
            postImage: val.toString(),
            postVideo: '');
        loading = false;
      });
    }).catchError((error) {
      loading = false;
    });
    notifyListeners();
  }

  Future<void> uploadPostVideo(
      {required String text,
      required List<String> tags,
      required String date}) async {
    if (postVideo != null) {
      loading = true;
      notifyListeners();
      await FirebaseStorage.instance
          .ref()
          .child(
              'posts/${user.userId}/$date/videos/${Uri.file(postVideo!.path).pathSegments.last}')
          .putFile(postVideo!)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          postVideoUrl = val.toString();
          createNewPost(
              text: text,
              tags: tags,
              date: date,
              postImage: '',
              postVideo: val.toString());
          loading = false;
        });
      }).catchError((error) {
        loading = false;
      });
    }
    notifyListeners();
  }

  //-------------------------- end post functions ----------------------------------
  //*************************************************************************************

  //-------------------------- start profile and stories functions ----------------------------------
  //*************************************************************************************
  File? profileImage;
  File? coverImage;
  File? storyFile;
  List<Story> myStories = [];
  List<Story> friendStories = [];

  // Future<void> pickProfileImage(ImageSource src) async {
  //   var pickedImageFile = await imagePicker.pickImage(
  //     source: src,
  //   );
  //
  //   if (pickedImageFile != null) {
  //     profileImage = File(pickedImageFile.path);
  //     notifyListeners();
  //   } else {
  //     print('No Image Selected');
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> pickCoverImage(ImageSource src) async {
  //   var pickedImageFile = await imagePicker.pickImage(
  //     source: src,
  //   );
  //
  //   if (pickedImageFile != null) {
  //     coverImage = File(pickedImageFile.path);
  //   } else {
  //     print('No Image Selected');
  //   }
  //   notifyListeners();
  // }

  List<Story> convertStoriesFromJsonToListOfStories(List<dynamic> stories) {
    List<Story> allStory = [];
    stories.forEach((element) {
      allStory.add(Story(
          url: element['url'],
          duration: element["duration"],
          media: element["media"]));
    });
    return allStory;
  }

  Future<void> uploadMyStory(bool isImage, context) async {
    if (storyFile != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  "please wait... ",
                  style: TextStyle(fontSize: 12),
                ),
              ));
      var url = '';
      var stories = user.myStory;
      await FirebaseStorage.instance
          .ref()
          .child(
              'users/${user.userId}/stories/_filePath ${Uri.file(storyFile!.path).pathSegments}')
          .putFile(storyFile!)
          .then((val) {
        val.ref.getDownloadURL().then((value) {
          url = value;
          stories.add(Story(
            url: url,
            media: isImage ? 'image' : 'video',
            duration: isImage
                ? Duration(seconds: 5).toString()
                : Duration(seconds: 10).toString(),
          ).toMap());
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.userId)
              .update(UserModel(
                user.userId,
                user.email,
                user.password,
                user.username,
                user.userBio,
                user.userImage,
                user.coverImage,
                user.isEmailVerified,
                user.details,
                user.myFriends,
                stories,
                user.friendshipRequests,
                user.saved,
                user.hiddenPost,
              ).toMap())
              .then((value) {
            user.myStory = stories;
            myStories = convertStoriesFromJsonToListOfStories(stories);
            //getUserData(uId: user.userId);
            //user.myStory = stories;

            notifyListeners();
          }).catchError((error) {
            stories.remove(storyFile);
            throw error;
          });
        });
      }).catchError((onError) {});
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> uploadProfileImage() async {
    if (profileImage != null) {
      var imageUrl = '';
      loading = true;
      await FirebaseStorage.instance
          .ref()
          .child('users/${user.userId}/profile_image/${user.userId + '.jpg'}')
          .delete()
          .then((value) {
        FirebaseStorage.instance
            .ref()
            .child('users/${user.userId}/profile_image/${user.userId + '.jpg'}')
            .putFile(profileImage!)
            .then((val) {
          val.ref.getDownloadURL().then((value) {
            imageUrl = value.toString();
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.userId)
                .update(UserModel(
                  user.userId,
                  user.email,
                  user.password,
                  user.username,
                  user.userBio,
                  imageUrl,
                  user.coverImage,
                  user.isEmailVerified,
                  user.details,
                  user.myFriends,
                  user.myStory,
                  user.friendshipRequests,
                  user.saved,
                  user.hiddenPost,
                ).toMap())
                .then((value) {
              getUserData(uId: user.userId);
              loading = false;
            }).catchError((error) {
              loading = false;
              print('error catch 11');
              print(error.toString());
              throw error;
            });
          });
        }).catchError((error) {
          loading = false;
          print('error catch 22');
          print(error.toString());
          throw error;
        });
      }).catchError((error) {
        loading = false;
        print('error catch 33');
        print(error.toString());
        throw error;
      });
    }
    notifyListeners();
  }

  Future<void> uploadCoverImage() async {
    if (coverImage != null) {
      var imageUrl = '';
      loading = true;
      if (user.coverImage.isEmpty) {
        await FirebaseStorage.instance
            .ref()
            .child(
                'users/${user.userId}/cover_image/${'cover' + user.userId + '.jpg'}')
            .putFile(coverImage!)
            .then((val) {
          val.ref.getDownloadURL().then((value) {
            imageUrl = value.toString();
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.userId)
                .update(UserModel(
                  user.userId,
                  user.email,
                  user.password,
                  user.username,
                  user.userBio,
                  user.userImage,
                  imageUrl,
                  user.isEmailVerified,
                  user.details,
                  user.myFriends,
                  user.myStory,
                  user.friendshipRequests,
                  user.saved,
                  user.hiddenPost,
                ).toMap())
                .then((value) {
              getUserData(uId: user.userId);
              loading = false;
            }).catchError((error) {
              loading = false;
              print('error catch 11');
              print(error.toString());
              throw error;
            });
          });
        }).catchError((error) {
          loading = false;
          print('error catch 22');
          print(error.toString());
          throw error;
        });
      } else {
        await FirebaseStorage.instance
            .ref()
            .child(
                'users/${user.userId}/cover_image/${'cover' + user.userId + '.jpg'}')
            .delete()
            .then((value) {
          FirebaseStorage.instance
              .ref()
              .child(
                  'users/${user.userId}/cover_image/${'cover' + user.userId + '.jpg'}')
              .putFile(coverImage!)
              .then((val) {
            val.ref.getDownloadURL().then((value) {
              imageUrl = value.toString();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.userId)
                  .update(UserModel(
                    user.userId,
                    user.email,
                    user.password,
                    user.username,
                    user.userBio,
                    user.userImage,
                    imageUrl,
                    user.isEmailVerified,
                    user.details,
                    user.myFriends,
                    user.myStory,
                    user.friendshipRequests,
                    user.saved,
                    user.hiddenPost,
                  ).toMap())
                  .then((value) {
                getUserData(uId: user.userId);
                loading = false;
              }).catchError((error) {
                loading = false;
                print('error catch 11');
                print(error.toString());
                throw error;
              });
            });
          }).catchError((error) {
            loading = false;
            print('error catch 22');
            print(error.toString());
            throw error;
          });
        }).catchError((error) {
          loading = false;
          print('error catch 33');
          print(error.toString());
          throw error;
        });
      }
      notifyListeners();
    }
  }

  Future<void> updateBio(String bio) async {
    loading = true;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          bio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          user.details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error Bio' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateWorkAt(String worksAt) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': worksAt.toString(),
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': user.details['contact info'],
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error Works At ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateLivesIn(String livesIn) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': livesIn.toString(),
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': user.details['contact info'],
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error Works At ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateFromCity(String from) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': from.toString(),
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': user.details['contact info'],
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error Works At ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateRelationship(String relationship) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': relationship.toString(),
      'education': user.details['education'],
      'contact info': user.details['contact info'],
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error Works At ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateEducation(String college, String highSchool) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': {
        'college': college.toString(),
        'high school': highSchool.toString(),
      },
      'contact info': user.details['contact info'],
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error Works At ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateContactInfoMobileNumber(String phoneNumber) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': {
        "email": user.details['contact info']['email'],
        "mobile number": phoneNumber.toString(),
      },
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error mobile number ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateContactInfoEmail(String email) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': {
        "email": email.toString(),
        "mobile number": user.details['contact info']['mobile number'],
      },
      'basic info': user.details['basic info'],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error mobile number ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateBasicInfoGender(String gender) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': user.details['contact info'],
      'basic info': {
        'gender': gender.toString(),
        'birthday': user.details['basic info']['birthday'],
        'languages': user.details['basic info']['languages'],
      },
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error mobile number ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateBasicInfoBirthday(String birthday) async {
    loading = true;
    Map<String, dynamic> details = {
      'works at': user.details['works at'],
      'lives in': user.details['lives in'],
      'from': user.details['from'],
      'relationship': user.details['relationship'],
      'education': user.details['education'],
      'contact info': user.details['contact info'],
      'basic info': {
        'gender': user.details['basic info']['gender'],
        'birthday': birthday.toString(),
        'languages': user.details['basic info']['languages'],
      },
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(UserModel(
          user.userId,
          user.email,
          user.password,
          user.username,
          user.userBio,
          user.userImage,
          user.coverImage,
          user.isEmailVerified,
          details,
          user.myFriends,
          user.myStory,
          user.friendshipRequests,
          user.saved,
          user.hiddenPost,
        ).toMap())
        .then((value) {
      getUserData(uId: user.userId).then((value) {
        loading = false;
      });
    }).catchError((error) {
      print('Error mobile number ' + error.toString());
      throw error;
    });
    notifyListeners();
  }

  //-------------------------- end profile and stories functions ----------------------------------
  //*************************************************************************************

  //-------------------------- start comment functions ----------------------------------
  //*************************************************************************************
  ImagePicker videoPicker = ImagePicker();
  XFile? commentVideo;
  XFile? replayCommentVideo;
  File? commentImage;
  bool openVoiceRecorderContainer = false;
  bool openImagePickerCommentContainer = false;
  bool openVideoPickerCommentContainer = false;
  bool isReplayComment = false;
  int commentIndex = -1;

  void changeReplayComment(bool isReplay, int index) {
    isReplayComment = isReplay;
    commentIndex = index;
    notifyListeners();
  }

  void deleteCommentIndexAndReplay() {
    isReplayComment = false;
    commentIndex = -1;
    notifyListeners();
  }

  void changeOpenVoiceRecorderContainer() {
    openVoiceRecorderContainer = !openVoiceRecorderContainer;
    openImagePickerCommentContainer = false;
    openVideoPickerCommentContainer = false;
    commentImage = null;
    commentVideo = null;
    notifyListeners();
  }

  void changeOpenImagePickerCommentContainer() {
    openImagePickerCommentContainer = !openImagePickerCommentContainer;
    openVoiceRecorderContainer = false;
    openVideoPickerCommentContainer = false;
    commentImage = null;
    commentVideo = null;
    notifyListeners();
  }

  void changeOpenVideoPickerCommentContainer() {
    openVideoPickerCommentContainer = !openVideoPickerCommentContainer;
    openImagePickerCommentContainer = false;
    openVoiceRecorderContainer = false;
    commentImage = null;
    commentVideo = null;
    replayCommentVideo = null;
    notifyListeners();
  }

  Future<void> likeOnPost({required PostModel post}) async {
    var index = posts.indexOf(post);
    var newPost = posts.firstWhere((element) => post.postId == element.postId);
    post.likes.contains(user.userId)
        ? newPost.likes.removeAt(
            newPost.likes.indexWhere((element) => element == user.userId))
        : newPost.likes.add(user.userId);
    posts[index] = newPost;
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(PostModel(
          post.postId,
          post.userId,
          post.username,
          post.userImage,
          post.textBody,
          post.postImage,
          post.postVideo,
          post.postTags,
          post.dateTime,
          newPost.likes,
          post.comments,
        ).toMap())
        .then((value) {})
        .catchError((error) {
      print("error ${error.toString()}");
    });
    notifyListeners();
  }

  Future<void> likeOnCommentInPost(
      {required PostModel post,
      required String commentId,
      required String commentBody}) async {
    print(
        'DONE --------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    var comment = post.comments.firstWhere((element) =>
        element['id'] == commentId &&
        element['body']['dateTime'] == commentBody);
    List<dynamic> likes = comment['body']['likes'];
    if (likes.contains(user.userId)) {
      likes.remove(user.userId);
    } else {
      likes.add(user.userId);
    }
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(PostModel(
          post.postId,
          post.userId,
          post.username,
          post.userImage,
          post.textBody,
          post.postImage,
          post.postVideo,
          post.postTags,
          post.dateTime,
          post.likes,
          post.comments,
        ).toMap())
        .then((value) {})
        .catchError((error) {
      print("error ${error.toString()}");
    });
    notifyListeners();
  }

  Future<void> likeOnReplyComment({
    required PostModel post,
    required int commentIndex,
    required int replyCommentIndex,
  }) async {
    var comment =
        post.comments[commentIndex]['replyComments'][replyCommentIndex];
    var likes = comment['body']['likes'];
    if (likes.contains(user.userId)) {
      likes.remove(user.userId);
    } else {
      likes.add(user.userId);
    }
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(PostModel(
          post.postId,
          post.userId,
          post.username,
          post.userImage,
          post.textBody,
          post.postImage,
          post.postVideo,
          post.postTags,
          post.dateTime,
          post.likes,
          post.comments,
        ).toMap())
        .then((value) {})
        .catchError((error) {
      print("error ${error.toString()}");
    });
    notifyListeners();
  }

  Future<void> newTextCommentOnPost(
      {required PostModel post, required String text}) async {
    var comments = post.comments;
    var commentModel = {
      'id': '${user.userId}',
      'comment_type': 'text',
      'replyComments': [],
      'body': {
        'userImage': user.userImage,
        'userName': user.username,
        'commentBody': {
          'text': text,
          'image': '',
          'video': '',
          'voice': '',
        },
        'dateTime': DateTime.now().toString(),
        'likes': [],
      }
    };
    comments.add(commentModel);
    post.comments = comments;
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(PostModel(
          post.postId,
          post.userId,
          post.username,
          post.userImage,
          post.textBody,
          post.postImage,
          post.postVideo,
          post.postTags,
          post.dateTime,
          post.likes,
          comments,
        ).toMap())
        .then((value) {})
        .catchError((error) {
      post.comments.remove(commentModel);
      print("error ${error.toString()}");
    });
    notifyListeners();
  }

  Future<void> newReplyTextComment(
      {required PostModel post,
      required String text,
      required int commentIndex}) async {
    var replyComments = post.comments[commentIndex]['replyComments'];
    var commentModel = {
      'id': '${user.userId}',
      'comment_type': 'text',
      'body': {
        'userImage': user.userImage,
        'userName': user.username,
        'commentBody': {
          'text': text,
          'image': '',
          'video': '',
          'voice': '',
        },
        'dateTime': DateTime.now().toString(),
        'likes': [],
      }
    };
    replyComments.add(commentModel);
    post.comments[commentIndex]['replyComments'] = replyComments;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(PostModel(
          post.postId,
          post.userId,
          post.username,
          post.userImage,
          post.textBody,
          post.postImage,
          post.postVideo,
          post.postTags,
          post.dateTime,
          post.likes,
          post.comments,
        ).toMap())
        .then((value) {})
        .catchError((error) {
      print("error ${error.toString()}");
    });
    notifyListeners();
  }

  Future<void> newCommentPictureOnPost({
    required PostModel post,
  }) async {
    if (commentImage != null) {
      var comments = post.comments;
      String url =
          'post_comments/${post.postId}/comments/${user.userId + "time" + DateTime.now().toString()}/comments_image/_filePath ${Uri.file(commentImage!.path).pathSegments}';
      loading = true;
      notifyListeners();
      await FirebaseStorage.instance
          .ref()
          .child(url)
          // .child(
          //     'comment_pictures/[comment picture] postId ${post.postId} _userId ${user.userId} _time ${DateTime.now().toString()} _filePath ${Uri.file(commentImage!.path).pathSegments}')
          .putFile(commentImage!)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          comments.add({
            'id': '${user.userId}',
            'comment_type': 'picture',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': '',
                'image': val.toString(),
                'video': '',
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                comments,
              ).toMap())
              .then((value) {
            commentImage = null;
            openImagePickerCommentContainer = false;
            loading = false;
            notifyListeners();
          }).catchError((error) {
            loading = false;
            notifyListeners();
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  Future<void> newReplyCommentPictureOnPost(
      {required PostModel post, required int commentIndex}) async {
    if (commentImage != null) {
      var replyComments = post.comments[commentIndex]['replyComments'];
      String url =
          'post_comments/${post.postId}/replay_comments/${user.userId + "time" + DateTime.now().toString()}/replay_comments_image/_filePath ${Uri.file(commentImage!.path).pathSegments}';
      loading = true;
      notifyListeners();
      await FirebaseStorage.instance
          .ref()
          // .child(
          //     'comment_pictures/[replay comment picture] postId ${post.postId} _userId '
          //     '${user.userId} _time ${DateTime.now().toString()} '
          //     '_filePath ${Uri.file(commentImage!.path).pathSegments}')
          .child(url)
          .putFile(commentImage!)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          replyComments.add({
            'id': '${user.userId}',
            'comment_type': 'picture',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': '',
                'image': val.toString(),
                'video': '',
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          post.comments[commentIndex]['replyComments'] = replyComments;
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                post.comments,
              ).toMap())
              .then((value) {
            commentImage = null;
            openImagePickerCommentContainer = false;
            loading = false;
            notifyListeners();
          }).catchError((error) {
            loading = false;
            notifyListeners();
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  Future<void> newVoiceCommentOnPost(
      {required PostModel post,
      required String voiceCommentUrl,
      required File voiceFile}) async {
    var comments = post.comments;
    String url =
        'post_comments/${post.postId}/comments/${user.userId + "time" + DateTime.now().toString()}/comments_voice/_filePath ${Uri.file(voiceFile.path).pathSegments.last}';
    await FirebaseStorage.instance
        .ref()
        // .child(
        //     'voice_comments/postId ${post.postId} _userId ${user.userId} _time ${DateTime.now().toString()} _filePath ${Uri.file(voiceFile.path).pathSegments.last}')
        .child(url)
        .putFile(voiceFile)
        .then((value) {
      value.ref.getDownloadURL().then((val) {
        comments.add({
          'id': '${user.userId}',
          'comment_type': 'record',
          'replyComments': [],
          'body': {
            'userImage': user.userImage,
            'userName': user.username,
            'commentBody': {
              'text': '',
              'image': '',
              'video': '',
              'voice': val.toString(),
            },
            'dateTime': DateTime.now().toString(),
            'likes': [],
          }
        });
        notifyListeners();
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post.postId)
            .update(PostModel(
              post.postId,
              post.userId,
              post.username,
              post.userImage,
              post.textBody,
              post.postImage,
              post.postVideo,
              post.postTags,
              post.dateTime,
              post.likes,
              comments,
            ).toMap())
            .then((value) {
          messageVoiceFile = null;
        }).catchError((error) {
          print("error ${error.toString()}");
        });
      });
    }).catchError((error) {
      loading = false;
    });
    notifyListeners();
  }

  Future<void> newReplyVoiceComment(
      {required PostModel post,
      required String voiceCommentUrl,
      required File voiceFile,
      required int commentIndex}) async {
    var replyComments = post.comments[commentIndex]['replyComments'];
    String url =
        'post_comments/${post.postId}/replay_comments/${user.userId + "time" + DateTime.now().toString()}/replay_comments_voice/_filePath ${Uri.file(voiceFile.path).pathSegments.last}';
    await FirebaseStorage.instance
        .ref()
        // .child(
        //     'voice_comments/[replay voice comment ]postId ${post.postId} _userId ${user.userId} _time ${DateTime.now().toString()} _filePath ${Uri.file(voiceFile.path).pathSegments.last}')
        .child(url)
        .putFile(voiceFile)
        .then((value) {
      value.ref.getDownloadURL().then((val) {
        replyComments.add({
          'id': '${user.userId}',
          'comment_type': 'record',
          'replyComments': [],
          'body': {
            'userImage': user.userImage,
            'userName': user.username,
            'commentBody': {
              'text': '',
              'image': '',
              'video': '',
              'voice': val.toString(),
            },
            'dateTime': DateTime.now().toString(),
            'likes': [],
          }
        });
        post.comments[commentIndex]['replyComments'] = replyComments;
        notifyListeners();
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post.postId)
            .update(PostModel(
              post.postId,
              post.userId,
              post.username,
              post.userImage,
              post.textBody,
              post.postImage,
              post.postVideo,
              post.postTags,
              post.dateTime,
              post.likes,
              post.comments,
            ).toMap())
            .then((value) {
          messageVoiceFile = null;
          // changeOpenVoiceRecorderContainer();
        }).catchError((error) {
          print("error ${error.toString()}");
        });
      });
    }).catchError((error) {
      loading = false;
    });
    notifyListeners();
  }

  void setCommentVideo(XFile file) {
    commentVideo = file;
    notifyListeners();
  }

  void setReplayCommentVideo(XFile file) {
    replayCommentVideo = file;
    notifyListeners();
  }

  Future<void> newVideoCommentOnPost({
    required PostModel post,
  }) async {
    loading = true;
    notifyListeners();
    var comments = post.comments;
    final videoFile = File(commentVideo!.path);
    if (commentVideo != null) {
      String url =
          'post_comments/${post.postId}/comments/${user.userId + "time" + DateTime.now().toString()}/comments_video/_filePath ${Uri.file(videoFile.path).pathSegments.last}';
      await FirebaseStorage.instance
          .ref()
          // .child('video_comments/postId ${post.postId} '
          //     '_userId ${user.userId} _time ${DateTime.now().toString()} '
          //     '_filePath ${Uri.file(videoFile.path).pathSegments.last}')
          .child(url)
          .putFile(videoFile)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          comments.add({
            'id': '${user.userId}',
            'comment_type': 'video',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': '',
                'image': '',
                'video': val.toString(),
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                comments,
              ).toMap())
              .then((value) {
            loading = false;
            changeOpenVideoPickerCommentContainer();
            notifyListeners();
          }).catchError((error) {
            loading = false;
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
      });
      notifyListeners();
    } else {
      loading = false;
      comments.clear();
      videoFile.delete();
      notifyListeners();
    }
  }

  Future<void> newReplyVideoCommentOnPost(
      {required PostModel post, required int commentIndex}) async {
    loading = true;
    notifyListeners();
    var replyComments = post.comments[commentIndex]['replyComments'];
    final videoFile = File(replayCommentVideo!.path);
    if (replayCommentVideo != null) {
      String url =
          'post_comments/${post.postId}/replay_comments/${user.userId + "time" + DateTime.now().toString()}/replay_comments_video/_filePath ${Uri.file(videoFile.path).pathSegments.last}';
      await FirebaseStorage.instance
          .ref()
          // .child('video_comments/[replay comment video]postId ${post.postId} '
          //     '_userId ${user.userId} _time ${DateTime.now().toString()} '
          //     '_filePath ${Uri.file(videoFile.path).pathSegments.last}')
          .child(url)
          .putFile(videoFile)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          replyComments.add({
            'id': '${user.userId}',
            'comment_type': 'video',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': '',
                'image': '',
                'video': val.toString(),
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          post.comments[commentIndex]['replyComments'] = replyComments;
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                post.comments,
              ).toMap())
              .then((value) {
            loading = false;
            changeOpenVideoPickerCommentContainer();
            notifyListeners();
          }).catchError((error) {
            loading = false;
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
      });
      notifyListeners();
    } else {
      loading = false;
      replayCommentVideo = null;
      videoFile.delete();
      notifyListeners();
    }
  }

  Future<void> newTextAndPictureCommentOnPost(
      {required PostModel post, required String text}) async {
    if (commentImage != null) {
      var comments = post.comments;
      String url =
          'post_comments/${post.postId}/comments/${user.userId + "time" + DateTime.now().toString()}/comments_image/_filePath ${Uri.file(commentImage!.path).pathSegments}';
      loading = true;
      notifyListeners();
      await FirebaseStorage.instance
          .ref()
          .child(url)
          // 'comment_pictures/[comment picture] postId ${post.postId} _userId ${user.userId} _time ${DateTime.now().toString()} _filePath ${Uri.file(commentImage!.path).pathSegments}')
          .putFile(commentImage!)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          comments.add({
            'id': '${user.userId}',
            'comment_type': 'text and picture',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': text,
                'image': val.toString(),
                'video': '',
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                comments,
              ).toMap())
              .then((value) {
            commentImage = null;
            openImagePickerCommentContainer = false;
            loading = false;
            notifyListeners();
          }).catchError((error) {
            loading = false;
            notifyListeners();
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  Future<void> newReplayTextAndPictureCommentOnPost(
      {required PostModel post,
      required String text,
      required int commentIndex}) async {
    if (commentImage != null) {
      loading = true;
      var replyComments = post.comments[commentIndex]['replyComments'];
      String url =
          'post_comments/${post.postId}/replay_comments/${user.userId + "time" + DateTime.now().toString()}/replay_comments_image/_filePath ${Uri.file(commentImage!.path).pathSegments}';
      notifyListeners();
      await FirebaseStorage.instance
          .ref()
          .child(url)
          // 'comment_pictures/[Replay comment picture] postId ${post.postId} _userId ${user.userId} _time ${DateTime.now().toString()} _filePath ${Uri.file(commentImage!.path).pathSegments}')
          .putFile(commentImage!)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          replyComments.add({
            'id': '${user.userId}',
            'comment_type': 'text and picture',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': text,
                'image': val.toString(),
                'video': '',
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          post.comments[commentIndex]['replyComments'] = replyComments;
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                post.comments,
              ).toMap())
              .then((value) {
            commentImage = null;
            openImagePickerCommentContainer = false;
            loading = false;
            notifyListeners();
          }).catchError((error) {
            loading = false;
            notifyListeners();
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  Future<void> newTextAndVideoCommentOnPost(
      {required PostModel post, required String text}) async {
    if (commentVideo != null) {
      var comments = post.comments;
      loading = true;
      notifyListeners();
      final videoFile = File(commentVideo!.path);
      String url =
          'post_comments/${post.postId}/comments/${user.userId + "time" + DateTime.now().toString()}/comments_video/_filePath ${Uri.file(videoFile.path).pathSegments.last}';
      await FirebaseStorage.instance
          .ref()
          .child(url)
          // 'video_comments/postId ${post.postId} '
          //     '_userId ${user.userId} _time ${DateTime.now().toString()} '
          //     '_filePath ${Uri.file(videoFile.path).pathSegments.last}'
          .putFile(videoFile)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          comments.add({
            'id': '${user.userId}',
            'comment_type': 'text and video',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': text,
                'image': '',
                'video': val.toString(),
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                comments,
              ).toMap())
              .then((value) {
            loading = false;
            changeOpenVideoPickerCommentContainer();
            videoFile.delete();
            comments.clear();
            notifyListeners();
          }).catchError((error) {
            loading = false;
            notifyListeners();
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  Future<void> newReplayTextAndVideoCommentOnPost(
      {required PostModel post,
      required String text,
      required int commentIndex}) async {
    if (replayCommentVideo != null) {
      var replyComments = post.comments[commentIndex]['replyComments'];
      loading = true;
      notifyListeners();
      final videoFile = File(replayCommentVideo!.path);
      String url =
          'post_comments/${post.postId}/replay_comments/${user.userId + "time" + DateTime.now().toString()}/replay_comments_video/_filePath ${Uri.file(videoFile.path).pathSegments.last}';
      await FirebaseStorage.instance
          .ref()
          .child(url)
          // 'video_comments/postId ${post.postId} '
          //     '_userId ${user.userId} _time ${DateTime.now().toString()} '
          //     '_filePath ${Uri.file(videoFile.path).pathSegments.last}')
          .putFile(videoFile)
          .then((value) {
        value.ref.getDownloadURL().then((val) {
          replyComments.add({
            'id': '${user.userId}',
            'comment_type': 'text and video',
            'replyComments': [],
            'body': {
              'userImage': user.userImage,
              'userName': user.username,
              'commentBody': {
                'text': text,
                'image': '',
                'video': val.toString(),
                'voice': '',
              },
              'dateTime': DateTime.now().toString(),
              'likes': [],
            }
          });
          notifyListeners();
          FirebaseFirestore.instance
              .collection('posts')
              .doc(post.postId)
              .update(PostModel(
                post.postId,
                post.userId,
                post.username,
                post.userImage,
                post.textBody,
                post.postImage,
                post.postVideo,
                post.postTags,
                post.dateTime,
                post.likes,
                post.comments,
              ).toMap())
              .then((value) {
            loading = false;
            changeOpenVideoPickerCommentContainer();
            videoFile.delete();
            replyComments = null;
            notifyListeners();
          }).catchError((error) {
            loading = false;
            notifyListeners();
            print("error ${error.toString()}");
          });
        });
      }).catchError((error) {
        loading = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

//*************************************************************************************
//-------------------------- end comment functions ----------------------------------

}
