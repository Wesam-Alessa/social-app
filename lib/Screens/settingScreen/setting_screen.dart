import 'package:chat/providers/social_provider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
   bool dark = false;

@override
  void initState() {
    super.initState();
    dark = Provider.of<SocialProvider>(context,listen: false).isDark;
  }

  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    //dark = social.isDark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            IconBroken.Arrow___Left_2,
            color:social.isDark?Colors.white: Colors.black,
          ),
        ),
        title: Text(
          'Setting',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color:social.isDark ? Colors.grey[700] : Colors.grey[300]
                ),
                child: Row(
                      children: [
                        Text(
                          '\t Dark Theme',
                        style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Switch(
                          value: dark,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            dark = value;
                            social.changeTheme(value);
                            setState(() {});
                          },
                        )
                      ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildSwitch(){
    var social = Provider.of<SocialProvider>(context,listen: false);
    return Switch(
      value: !social.isDark,
      activeColor: Colors.blue,
      onChanged: (value) {
        social.changeTheme(value);
        setState(() {});
      },
    );
  }
}
