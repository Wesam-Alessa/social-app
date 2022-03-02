import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_details_screen/edit_details_education_screen.dart';
import 'edit_details_screen/edit_details_from_city_screen.dart';
import 'edit_details_screen/edit_details_live_in_screen.dart';
import 'edit_details_screen/edit_details_relashinShip_screen.dart';
import 'edit_details_screen/edit_details_work_at_screen.dart';

class EditDetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    var social = Provider.of<SocialProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5.0,
        title: Text(
          'Edit Profile Details',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            IconBroken.Arrow___Left_2,
            color: !social.isDark? Colors.black : Colors.white,
          ),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 25.0,
            ),
            InkWell(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>DetailsWorkAtScreen())),
              child: Row(
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
                    '${user.details['works at']} ',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                  ),
                  Spacer(),
                  Icon(IconBroken.Edit,color:!social.isDark ? Colors.blue : Colors.white,),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            InkWell(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>DetailsLiveInScreen())),
              child: Row(
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
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                  ),
                  Spacer(),
                  Icon(IconBroken.Edit,color:!social.isDark ? Colors.blue : Colors.white,),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            InkWell(
                onTap: ()=>Navigator.
                push(context,MaterialPageRoute(builder:(_)=>DetailsFromCityScreen())),

              child: Row(
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
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                  ),
                  Spacer(),
                  Icon(IconBroken.Edit,color:!social.isDark ? Colors.blue : Colors.white,),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            InkWell(
              onTap: ()=>Navigator.
              push(context,MaterialPageRoute(builder:(_)=>DetailsRelationshipScreen())),
              child: Row(
                children: [
                  Icon(IconBroken.Heart),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '${user.details['relationship']}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                  ),
                  Spacer(),
                  Icon(IconBroken.Edit,color:!social.isDark ? Colors.blue:Colors.white,),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            InkWell(
              onTap: ()=>Navigator.
              push(context,MaterialPageRoute(builder:(_)=>DetailsEducationScreen())),
              child: Row(
                children: [
                  Icon(Icons.school_outlined),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'College ',
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 2,
                  ),
                  Text(
                    '${user.details['education']['college']}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                  ),
                  Spacer(),
                  Icon(IconBroken.Edit,color:!social.isDark ? Colors.blue:Colors.white,),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            InkWell(
              onTap: ()=>Navigator.
              push(context,MaterialPageRoute(builder:(_)=>DetailsEducationScreen())),
              child: Row(
                children: [
                  Icon(Icons.account_balance_outlined),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'High School',
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 2,
                  ),
                  Text(
                    ' ${user.details['education']['high school']}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 2,
                  ),
                  Spacer(),
                  Icon(IconBroken.Edit,color: !social.isDark ? Colors.blue:Colors.white,),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),

    );
  }
}
