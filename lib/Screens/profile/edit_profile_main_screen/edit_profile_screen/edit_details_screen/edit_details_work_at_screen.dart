import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsWorkAtScreen extends StatefulWidget {
  @override
  _DetailsWorkAtScreenState createState() => _DetailsWorkAtScreenState();
}

class _DetailsWorkAtScreenState extends State<DetailsWorkAtScreen> {
  final _formKey = GlobalKey<FormState>();
  var workName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    workName.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataProvider>(context, listen: true);
    var user = Provider.of<UserDataProvider>(context, listen: true).user;
    var social = Provider.of<SocialProvider>(context,listen: true);
     workName.text = user.details['works at'];
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
              userProvider.updateWorkAt(workName.text)
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
                  .copyWith(color: Colors.blue[800])
              :TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Your Works '),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: workName,
                autocorrect: true,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:!social.isDark? Colors.black:Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Your Work",
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  prefixIcon: Icon(IconBroken.Work,color:! social.isDark?Colors.black:Colors.white,),
                ),
                key: ValueKey('Works At '),
                onSaved: (val) => workName.text = val??'',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
