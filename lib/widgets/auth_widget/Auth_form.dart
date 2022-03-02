// import 'dart:io';
//
// import 'package:chat/pickers/user_image_picker.dart';
// import 'package:chat/providers/auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class AuthForm extends StatefulWidget {
//   @override
//   _AuthFormState createState() => _AuthFormState();
// }
//
// class _AuthFormState extends State<AuthForm> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLogin = true;
//   String _email = '';
//   String _password = '';
//   String _userName = '';
//   File? _userImageFile;
//
//   void _pickedImage(File pickedImage) {
//     _userImageFile = pickedImage;
//   }
//
//   void _submit() {
//     final isValid = _formKey.currentState!.validate();
//     FocusScope.of(context).unfocus();
//     if (_isLogin && isValid) {
//       _formKey.currentState!.save();
//       Provider.of<AuthProvider>(context, listen: false)
//           .submitAuthFormLogin(_email, _password, context);
//     } else if (!_isLogin) {
//       if (_userImageFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("Please pick an Image."),
//           backgroundColor: Colors.red,
//         ));
//         return;
//       } else if (_userImageFile != null && isValid) {
//         _formKey.currentState!.save();
//         Provider.of<AuthProvider>(context, listen: false).submitAuthFormSignUp(
//           _email,
//           _password,
//           _userName,
//           _userImageFile!,
//           context,
//         );
//
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var auth = Provider.of<AuthProvider>(context, listen: true);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text('Social App',
//           style: TextStyle(
//           fontSize: 50,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontStyle: FontStyle.italic
//           ),
//         ),
//         SizedBox(height: 25,),
//         Center(
//               child: Card(
//                 margin: EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.all(16),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (!_isLogin) UserImagePicker(_pickedImage),
//                         TextFormField(
//                           autocorrect: false,
//                           enableSuggestions: false,
//                           textCapitalization: TextCapitalization.none,
//                           key: ValueKey('email'),
//                           validator: (val) {
//                             if (val!.isEmpty || !val.contains('@')) {
//                               return "Please enter a valid email address";
//                             }
//                             return null;
//                           },
//                           onSaved: (val) => _email = val!,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(labelText: "Email Address"),
//                         ),
//                         if (!_isLogin)
//                           TextFormField(
//                             autocorrect: true,
//                             enableSuggestions: false,
//                             textCapitalization: TextCapitalization.words,
//                             key: ValueKey('userName'),
//                             validator: (val) {
//                               if (val!.isEmpty || val.length < 4) {
//                                 return "Please enter at least 4 characters";
//                               }
//                               return null;
//                             },
//                             onSaved: (val) => _userName = val!,
//                             decoration: InputDecoration(labelText: "User Name"),
//                           ),
//                         TextFormField(
//                           key: ValueKey('password'),
//                           validator: (val) {
//                             if (val!.isEmpty || val.length < 7) {
//                               return "Password most be at least 7 characters";
//                             }
//                             return null;
//                           },
//                           onSaved: (val) => _password = val!,
//                           decoration: InputDecoration(labelText: "Password"),
//                           obscureText: true,
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         if (auth.isLoading) CircularProgressIndicator(),
//                         if (!auth.isLoading)
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: Theme.of(context).primaryColor, // background
//                               onPrimary: Colors.white, // foreground
//                             ),
//                             child: Text(_isLogin ? "Login" : "Sign Up"),
//                             onPressed: _submit,
//                           ),
//                         if (!auth.isLoading)
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 _isLogin = !_isLogin;
//                               });
//                             },
//                             child: Text(
//                               _isLogin
//                                   ? "Create new account"
//                                   : "I already have an account",
//                               style: TextStyle(color: Theme.of(context).primaryColor),
//                             ),
//                           )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'dart:math';
import 'package:chat/pickers/user_image_picker.dart';
import 'package:chat/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _userName = '';
  File? _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isLogin && isValid) {
      _formKey.currentState!.save();
      Provider.of<AuthProvider>(context, listen: false)
          .submitAuthFormLogin(_email, _password, context);
    } else if (!_isLogin) {
      if (_userImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please pick an Image."),
          backgroundColor: Colors.red,
        ));
        return;
      } else if (_userImageFile != null && isValid) {
        _formKey.currentState!.save();
        Provider.of<AuthProvider>(context, listen: false).submitAuthFormSignUp(
          _email,
          _password,
          _userName,
          _userImageFile!,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var auth = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container(
                  child: Transform.rotate(
                    angle: -pi / 3.5,
                    child: ClipPath(
                      //clipper:ClipPainter(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffE6E6E6),
                              Color(0xff14279B),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'Social\t',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff14279B),
                            ),
                            children: [
                              TextSpan(
                                text: 'App',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 30),
                              ),
                            ]),
                      ),
                      SizedBox(height: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (!_isLogin) UserImagePicker(_pickedImage),
                                SizedBox(height: 10,),
                                TextFormField(
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  textCapitalization: TextCapitalization.none,
                                  style: TextStyle(color: Colors.black),
                                  key: ValueKey('email'),
                                  validator: (val) {
                                    if (val!.isEmpty || !val.contains('@')) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                  onSaved: (val) => _email = val!,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:
                                      InputDecoration(
                                          labelText: "Email Address",
                                          border: InputBorder.none,
                                          fillColor: Color(0xfff3f3f4),
                                          filled: true),
                                ),
                                SizedBox(height: 10,),
                                if (!_isLogin)
                                  TextFormField(
                                    autocorrect: true,
                                    enableSuggestions: false,
                                    textCapitalization: TextCapitalization.words,
                                    style: TextStyle(color: Colors.black),
                                    key: ValueKey('userName'),
                                    validator: (val) {
                                      if (val!.isEmpty || val.length < 4) {
                                        return "Please enter at least 4 characters";
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _userName = val!,
                                    decoration: InputDecoration(
                                        labelText: "User Name",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true),
                                  ),
                                if (!_isLogin)
                                  SizedBox(height: 10,),
                                TextFormField(
                                  key: ValueKey('password'),
                                  style: TextStyle(color: Colors.black),
                                  validator: (val) {
                                    if (val!.isEmpty || val.length < 7) {
                                      return "Password most be at least 7 characters";
                                    }
                                    return null;
                                  },
                                  onSaved: (val) => _password = val!,
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  obscureText: true,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (auth.isLoading) CircularProgressIndicator(),
                      if (!auth.isLoading)
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xff14279B),
                                  Color(0xff14279B),
                                ],
                              ),
                            ),
                            child: Text(
                              _isLogin ? "Login" : "Sign Up",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      SizedBox(height: height * .055),
                      if (!auth.isLoading)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            padding: EdgeInsets.all(15),
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _isLogin
                                      ? "Create new account"
                                      : "I already have an account",
                                  style: TextStyle(
                                      color: Color(0xff14279B),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
