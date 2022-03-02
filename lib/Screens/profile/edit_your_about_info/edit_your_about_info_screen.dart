import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_screen/edit_details_screen/edit_details_education_screen.dart';
import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_screen/edit_details_screen/edit_details_from_city_screen.dart';
import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_screen/edit_details_screen/edit_details_live_in_screen.dart';
import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_screen/edit_details_screen/edit_details_relashinShip_screen.dart';
import 'package:chat/Screens/profile/edit_profile_main_screen/edit_profile_screen/edit_details_screen/edit_details_work_at_screen.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'edit_basic_info/edit_gender/edit_gender_screen.dart';
import 'edit_contact_info/edit_email/edit_email_screen.dart';
import 'edit_contact_info/edit_mobile_number/edit_mobile_number_screen.dart';

class EditYourAboutInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5.0,
        title: Text(
          'About',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            IconBroken.Arrow___Left_2,
            color:!social.isDark ? Colors.black:Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Work',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(IconBroken.Work,color: Colors.grey[700],),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Work Experience',
                        style:!social.isDark? Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.blue[800]):
                        Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.blue[400]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.grey[300],
                            child: Icon(IconBroken.Work,color: Colors.grey[700],),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                child: Text(
                                  '${user.details['works at']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Container(
                                width: 200,
                                child: Text(
                                  'August 18,2020 to present',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed:(){
                              Navigator.push(context, MaterialPageRoute(builder:(_)=>DetailsWorkAtScreen()));
                            },
                              icon: Icon(IconBroken.Edit),
                          ),
                        ],
                      ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 1.0,
                    color:Colors.grey[400],
                  ),
                  SizedBox(height: 10.0,),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Education',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: ()=>Navigator
                        .push(context,
                        MaterialPageRoute(builder:(_)=>DetailsEducationScreen())),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.school_outlined,color: Colors.grey[700],),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your College',
                              style: !social.isDark?Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.blue[800]):
                            Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.blue[400]),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                '${user.details['education']['college']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: ()=>Navigator
                        .push(context,
                        MaterialPageRoute(builder:(_)=>DetailsEducationScreen())),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.account_balance_outlined,color:Colors.grey[700],),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your High School',
                              style:!social.isDark ?
                              Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.blue[800]):
                            Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.blue[400]),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                  '${user.details['education']['high school']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 1.0,
                    color:Colors.grey[400],
                  ),
                  SizedBox(height: 10.0,),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Places Lived',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.home_outlined,color: Colors.grey[700],),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Your City',
                        style: !social.isDark? Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.blue[800]):
                        Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.blue[400]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(IconBroken.Home,color: Colors.grey[700],),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              '${user.details['from']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'Hometown',
                            style: Theme.of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder:(_)=>
                              DetailsFromCityScreen()));
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(IconBroken.Home,color: Colors.grey[700],),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              '${user.details['lives in']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'Current City',
                            style: Theme.of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder:(_)=>DetailsLiveInScreen()));
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 1.0,
                    color:Colors.grey[400],
                  ),
                  SizedBox(height: 10.0,),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Info',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(IconBroken.Call,color: Colors.grey[700],),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              '${user.details['contact info']['mobile number']=='' ?'Item not selected':user.details['contact info']['mobile number']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'mobile',
                            style: Theme.of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder:(_)=>
                              EditMobileNumberScreen()));
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(IconBroken.Message,color: Colors.grey[700],),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              '${user.details['contact info']['email']=='' ?'Item not selected':user.details['contact info']['email']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'Email',
                            style: Theme.of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:(){
                         Navigator.push(context, MaterialPageRoute(builder:(_)=>EditEmailScreen()));
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 1.0,
                    color:Colors.grey[400],
                  ),
                  SizedBox(height: 10.0,),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Info',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.account_circle_outlined,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                                '${user.details['basic info']['gender']=='' ?'Item not selected':user.details['basic info']['gender']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'Gender',
                            style: Theme.of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder:(_)=>
                              EditGenderScreen()));
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage('assets/icons/birthday.jpg',)
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                                '${user.details['basic info']['birthday']=='' ?'Item not selected':user.details['basic info']['birthday']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'Birthday',
                            style: Theme.of(context)
                                .textTheme
                                .caption,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:() async {
                          await DatePicker.showSimpleDatePicker(
                            context,
                            initialDate: DateTime(1994),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now(),
                            dateFormat: "dd-MMMM-yyyy",
                            locale: DateTimePickerLocale.en_us,
                            looping: true,
                          ).then((value){
                            var date =  formatDate(value!, [yyyy, '-', mm, '-', dd]);
                            userProvider.updateBasicInfoBirthday(date.toString())
                                .then((value){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Success'),
                                backgroundColor: Colors.blue[800],
                              ));
                            })
                                .catchError((error){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error.toString()),
                                backgroundColor: Colors.red,
                              ));
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:Text('$date')
                            ),
                            );
                          });
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 1.0,
                    color:Colors.grey[400],
                  ),
                  SizedBox(height: 10.0,),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relationship',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey[300],
                        child: Icon(IconBroken.Heart,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                            '${user.details['relationship']=='' ?'Item not selected':user.details['relationship']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder:(_)=>
                              DetailsRelationshipScreen()));
                        },
                        icon: Icon(IconBroken.Edit),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 1.0,
                    color:Colors.grey[400],
                  ),
                  SizedBox(height: 10.0,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
