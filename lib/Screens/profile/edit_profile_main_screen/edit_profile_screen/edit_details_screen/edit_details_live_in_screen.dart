import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsLiveInScreen extends StatefulWidget {
  @override
  _DetailsLiveInScreenState createState() => _DetailsLiveInScreenState();
}

class _DetailsLiveInScreenState extends State<DetailsLiveInScreen> {
  final _formKey = GlobalKey<FormState>();
  var liveIn = TextEditingController();
@override
  void dispose() {
    super.dispose();
    liveIn.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    var social = Provider.of<SocialProvider>(context,listen: true);
    liveIn.text = user.details['lives in'];
    return  Scaffold(
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
            color:!social.isDark? Colors.black:Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              userProvider.updateLivesIn(liveIn.text)
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
                  .copyWith(color: Colors.blue[800]):TextStyle(color: Colors.white),
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
              Text('Edit Your Current City '),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: liveIn,
                autocorrect: true,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color:!social.isDark? Colors.black : Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Current City",
                  labelStyle:!social.isDark ?
                  TextStyle(color:Colors.black):TextStyle(color: Colors.white),
                  prefixIcon: Icon(IconBroken.Home,color: !social.isDark ? Colors.black : Colors.white,),
                ),
                key: ValueKey('Live In '),
                onSaved: (val) => liveIn.text = val??'',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
