import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBioScreen extends StatefulWidget {
  @override
  _EditBioScreenState createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  final _formKey = GlobalKey<FormState>();
  var bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    var social = Provider.of<SocialProvider>(context, listen: true);
    bio.text = user.userBio;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5.0,
        title: Text(
          'Edit Your Bio',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: IconButton(
          onPressed: () {
            bio.dispose();
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
              userProvider.updateBio(bio.text).then((value) {
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
              if (userProvider.loading) LinearProgressIndicator(),
              SizedBox(
                height: 15.0,
              ),
              Text('Edit Your Bio '),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: bio,
                autocorrect: true,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: !social.isDark ? Colors.white : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor:  Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Your Bio",
                    labelStyle: !social.isDark
                        ? TextStyle(color: Colors.blue)
                        : TextStyle(color: Colors.white)),
                key: ValueKey('bio '),
                onSaved: (value) => bio.text = value ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
