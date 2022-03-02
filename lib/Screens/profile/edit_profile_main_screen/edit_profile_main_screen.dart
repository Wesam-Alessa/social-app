import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_screen/edit_details_profile_screen.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'edit_profile_screen/edit_bio_screen/edit_profile_bio_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var profileImage = Provider.of<UserDataProvider>(context, listen: true).profileImage;
    var coverImage = Provider.of<UserDataProvider>(context, listen: true).coverImage;
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 5.0,
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          leading: IconButton(
            onPressed: () {
               userProvider.coverImage = null;
               userProvider.profileImage = null;
              Navigator.pop(context);
            },
            icon: Icon(
              IconBroken.Arrow___Left_2,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                if(userProvider.loading)
                  LinearProgressIndicator(),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Text(
                      'Profile Picture',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Spacer(),
                    Container(
                      width: 40.0,
                      child: TextButton(
                        onPressed: ()async{
                        // await userProvider.pickProfileImage(ImageSource.gallery);
                         await userProvider.pickAnyImage(ImageSource.gallery)
                         .then((value){
                           userProvider.profileImage = value;
                         });
                        },
                        child: Text(
                          'Edit',
                          style: !social.isDark ?
                          Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.blue[800])
                          : TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                if (profileImage !=null)
                  CircleAvatar(
                  radius: 70.0,
                  backgroundImage:FileImage(profileImage),
                ) else
                  CircleAvatar(
                  radius: 70.0,
                  backgroundImage: NetworkImage('${user.userImage}')
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Text(
                      'Cover Photo',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Spacer(),
                    Container(
                      width: 40.0,
                      child: TextButton(
                        onPressed: ()async{
                          await userProvider.pickAnyImage(ImageSource.gallery)
                          .then((value){
                            userProvider.coverImage = value;
                          });
                        },
                        child: Text(
                          'Edit',
                          style:! social.isDark ? Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.blue[800])
                              :
                          TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: coverImage == null && user.coverImage.isEmpty ?
                    Container()
                        :
                    coverImage == null && user.coverImage.isNotEmpty ?
                    Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '${user.coverImage}',
                      ),
                    )
                        :
                    Image(
                      fit: BoxFit.cover,
                      image: FileImage(
                        coverImage!,
                      ),
                    ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Text(
                      'Bio',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Spacer(),
                    Container(
                      width: 40.0,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditBioScreen())),
                        child: Text(
                          'Edit',
                          style:  !social.isDark ? Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.blue[800]):
                          TextStyle(color: Colors.white)  ,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                    child: Text(
                  '${user.userBio}',
                  style: Theme.of(context).textTheme.subtitle1,
                )),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Spacer(),
                    Container(
                      width: 40.0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditDetailsScreen()));
                        },
                        child: Text(
                          'Edit',
                          style:!social.isDark ?  Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.blue[800]):TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(IconBroken.Work),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Works at ',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            '${user.details['works at']}',
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(IconBroken.Home),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Live in ',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            '${user.details['lives in']} ',
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(IconBroken.Location),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'From ',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            '${user.details['from']}',
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(IconBroken.Heart),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            '${user.details['relationship']}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.school_outlined),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            '${user.details['education']['college']}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.account_balance_outlined),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            '${user.details['education']['high school']}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
