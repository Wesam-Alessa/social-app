import 'package:chat/Screens/profile/profile_screen/profile_screen.dart';
import 'package:chat/Screens/settingScreen/setting_screen.dart';
import 'package:chat/providers/auth.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/conditionBuilder/conditionalBuilder.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _value = false;

  @override
  void initState() {
    Provider.of<UserDataProvider>(context, listen: false).getAllUsers();
    //

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    var auth = Provider.of<AuthProvider>(context, listen: true);
    var socialProvider = Provider.of<SocialProvider>(context, listen: true);
    //Provider.of<UserDataProvider>(context, listen: true).getSavedPosts();
    return ConditionalBuilder(
        condition: user.userId != '',
        builder: (context) => SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                socialProvider.titles[socialProvider.currentIndex],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                color:socialProvider.isDark ? Colors.grey[700] : Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ProfileScreen()));
                        },
                        child: Hero(
                          tag: 'profile',
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: FadeInImage.memoryNetwork(
                                  width: 40,
                                  height: 40,
                                  placeholder: kTransparentImage,
                                  image: '${user.userImage}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.username}',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    'See your profile',
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 100.0,
                        ),
                        shrinkWrap: true,
                        itemCount: socialProvider.menuCardItems.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildGridViewItems(context, socialProvider.menuCardItems[index]),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                      ExpansionPanelList(
                        animationDuration: const Duration(milliseconds: 500),
                        elevation: 0,
                        expansionCallback:(context, value){
                          setState(() {
                            _value = !_value;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (context, value) {
                              return Row(
                                children: [
                                  Icon(IconBroken.Setting,color:Theme.of(context).iconTheme.color,),
                                  Text('  Settings '),
                                ],
                              );
                            },
                            backgroundColor:socialProvider.isDark? Colors.grey[700] : Colors.grey[300],
                            canTapOnHeader: true,
                            isExpanded: _value,
                            body: InkWell(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder:(_)=>SettingsScreen()));
                              },
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: socialProvider.isDark? Colors.grey[800] :Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(IconBroken.Profile),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text('Sittings'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)) ,
                        color:socialProvider.isDark? Colors.grey[800] : Colors.grey[400],
                        onPressed:(){
                          auth.logout();
                        },
                        child: Text(
                          'Log Out',
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        fallback: (context) => Center(child: CircularProgressIndicator()),
    );
  }
  Widget buildGridViewItems(context, item) {
    return InkWell(
      onTap: ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>item['onTap'])),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Icon(
                  item['icon'],
                  color: Colors.blue[400],
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  '${item['title']}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            if(item['new'] != 0)
                 Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      CircleAvatar(
                        radius: 5.0,
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${item['new']} new',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),

          ],
        ),
      ),
    );
  }
}
