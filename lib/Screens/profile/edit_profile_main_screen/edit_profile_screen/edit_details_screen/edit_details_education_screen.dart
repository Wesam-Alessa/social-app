import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsEducationScreen extends StatefulWidget {
  @override
  _DetailsEducationScreenState createState() => _DetailsEducationScreenState();
}

class _DetailsEducationScreenState extends State<DetailsEducationScreen> {
  final _formKey = GlobalKey<FormState>();
  var college = TextEditingController();
  var highSchool = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    college.dispose();
    highSchool.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var social = Provider.of<SocialProvider>(context, listen: true);
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    college.text = user.details['education']['college'];
    highSchool.text = user.details['education']['high school'];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5.0,
        title: Text(
          'Edit Details',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            IconBroken.Arrow___Left_2,
            color: !social.isDark ? Colors.black : Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              userProvider
                  .updateEducation(college.text, highSchool.text)
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Success'),
                  backgroundColor: Colors.blue[800],
                ));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.toString()),
                  backgroundColor: Colors.red,
                ));
              });
            },
            child: Text(
              'Save',
              style: !social.isDark
                  ? Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.blue[800])
                  : TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Edit Your Education '),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: college,
                autocorrect: true,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: !social.isDark ? Colors.black : Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "College Name",
                  labelStyle: TextStyle(
                      color: !social.isDark ? Colors.black : Colors.white),
                  prefixIcon: Icon(
                    Icons.school_outlined,
                    color: !social.isDark ? Colors.black : Colors.white,
                  ),
                ),
                key: ValueKey('College'),
                onSaved: (val) => college.text = val ?? '',
              ),
              SizedBox(
                height: 25.0,
              ),
              TextFormField(
                controller: highSchool,
                autocorrect: true,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: !social.isDark ? Colors.black : Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "High School Name",
                  labelStyle: TextStyle(
                      color: !social.isDark ? Colors.black : Colors.white),
                  prefixIcon: Icon(Icons.account_balance_outlined,color: !social.isDark ? Colors.black : Colors.white,),
                ),
                key: ValueKey('High School'),
                onSaved: (val) => highSchool.text = val ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
