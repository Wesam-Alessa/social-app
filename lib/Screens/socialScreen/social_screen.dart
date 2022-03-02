import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  void initState() {
    Provider.of<UserDataProvider>(context, listen: false)
        .getUserData(uId: FirebaseAuth.instance.currentUser!.uid);
    Provider.of<UserDataProvider>(context, listen: false).getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var socialProvider = Provider.of<SocialProvider>(context, listen: true);
    return Scaffold(
      body: ConditionalBuilder(
        condition:Provider.of<UserDataProvider>(context, listen: true).user.userId.isNotEmpty,
        builder: (context){
          return socialProvider.bottomNavScreens[socialProvider.currentIndex];
        },
        fallback: (context)=>Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          IconBroken.Home,
          IconBroken.Chat,
          IconBroken.Paper_Plus,
          IconBroken.Notification,
          Icons.menu,
        ],
        activeIndex: socialProvider.currentIndex,
        gapWidth: 1,
        activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        //gapLocation: GapLocation.center,
        //notchSmoothness: NotchSmoothness.defaultEdge,
        // leftCornerRadius: 0,
        // rightCornerRadius: 0,
        onTap: (index) {
          socialProvider.changeNavbarIndex(index);
        },
      ),
    );
  }
}
