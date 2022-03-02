import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsFromCityScreen extends StatefulWidget {
  @override
  _DetailsFromCityScreenState createState() => _DetailsFromCityScreenState();
}

class _DetailsFromCityScreenState extends State<DetailsFromCityScreen> {
  String  city = '' ;

  @override
  void initState() {
    var user = Provider.of<UserDataProvider>(context, listen: false).user;
    city = user.details['from'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context,listen: true);
    List<String> cities =social.cities..sort();
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    return
      Scaffold(
        appBar: AppBar(
          titleSpacing: 5.0,
          title: Text(
            'Edit Details',
            style:Theme.of(context).textTheme.bodyText1,
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              IconBroken.Arrow___Left_2,
              color:!social.isDark? Colors.black:Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                userProvider.updateFromCity(city)
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
              },
              child: Text(
                'Save',
                style:!social.isDark? Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.blue[800]):
                TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              if(userProvider.loading)
                LinearProgressIndicator(),
              SizedBox(
                height: 15.0,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              itemBuilder: (context, index) => buildRadioButton(cities[index]),
              separatorBuilder: (context, index) => Container(height: 1.0,color: Colors.grey[300],),
              itemCount: cities.length,
    ),
            ],
          ),
        ),
      );
  }

  Widget buildRadioButton(String val) {
    return RadioListTile(
      activeColor: Colors.blue,
      title: Text('$val'),
      value: val,
      groupValue: city,
      onChanged: (value){
        setState(() {
          city = value.toString();
        });
      },
    );
  }
}
