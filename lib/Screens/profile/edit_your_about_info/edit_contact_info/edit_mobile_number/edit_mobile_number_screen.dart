import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMobileNumberScreen extends StatefulWidget {
  @override
  _EditMobileNumberScreenState createState() => _EditMobileNumberScreenState();
}

class _EditMobileNumberScreenState extends State<EditMobileNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  var mobileNumber = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mobileNumber.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var social = Provider.of<SocialProvider>(context, listen: true);
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    mobileNumber.text = user.details['contact info']['mobile number'];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5.0,
        title: Text(
          'Edit Details',
          style: Theme.of(context).textTheme.bodyText1
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            IconBroken.Arrow___Left_2,
            color:social.isDark?Colors.white: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              userProvider.updateContactInfoMobileNumber(mobileNumber.text)
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
              style:
              social.isDark?
              Theme.of(context)
                  .textTheme
                  .subtitle1 :
              Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.blue[800]),
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
              Text('Edit Your Mobile Number ',style: Theme.of(context)
                  .textTheme
                  .subtitle2,),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: mobileNumber,
                autocorrect: true,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:  social.isDark ? Colors.white : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  labelText: "Your mobile number",
                  prefixIcon: Icon(IconBroken.Call,color: social.isDark ? Colors.white : Colors.black,),
                    labelStyle:  social.isDark
                        ?  TextStyle(color: Colors.white)
                        :TextStyle(color: Colors.blue)
                ),
                key: ValueKey('mobile number'),
                onSaved: (val) => mobileNumber.text = val ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
