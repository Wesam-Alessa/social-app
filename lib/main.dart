import 'package:chat/Screens/socialScreen/social_screen.dart';
import 'package:chat/providers/auth.dart';
import 'package:chat/providers/social_provider.dart';
import 'package:chat/providers/userDataProvider.dart';
import 'package:chat/widgets/internet_connection/internet_connection_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat/Screens/authScreen/auth_screen.dart';
import 'package:chat/Screens/splashScreen/splash_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SharedPreferences shared = await SharedPreferences.getInstance();
  // bool isDark = shared.getBool('isDark') ?? false;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // final bool isDark;
  // const MyApp({Key? key,required this.isDark}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasInternet = false;
  @override
  void initState(){
    super.initState();
   InternetConnectionChecker().onStatusChange.listen((status) {
    final hasInternet = status == InternetConnectionStatus.connected ? true : false;
     setState(() {
       this.hasInternet = hasInternet;
     });
   });

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: SocialProvider()..init()),
        ChangeNotifierProvider.value(value: UserDataProvider()..init()),
      ],
      builder: (context, _){
        var social = Provider.of<SocialProvider>(context,listen: true);
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'chat App',
        themeMode: social.isDark ? ThemeMode.dark :ThemeMode.light ,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
              titleSpacing: 15.0,
              color: Colors.white,
              elevation: 0.0,
              titleTextStyle: TextStyle(color: Colors.black),
              actionsIconTheme: IconThemeData(color: Colors.black45)),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              elevation: 0.0),
          cardTheme:CardTheme(
            color: Colors.white,
          ) ,
          iconTheme: IconThemeData(
              color: Colors.blue
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            bodyText2: TextStyle(
              color: Colors.black,
            ),
            subtitle1: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                height: 1.3),
            subtitle2: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                height: 1.3),
          ),
          sliderTheme: SliderThemeData(
            inactiveTrackColor: Colors.white,
            trackShape:
            RoundedRectSliderTrackShape(),
            trackHeight: 10.0,
            thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 5),
            activeTickMarkColor: Colors.red[700],
            inactiveTickMarkColor: Colors.red[100],
            valueIndicatorShape:RectangularSliderValueIndicatorShape(),
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[800],
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
              titleSpacing: 15.0,
              color: Colors.grey[800],
              elevation: 0.0,
              titleTextStyle: TextStyle(color: Colors.white,),
              actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.grey[800],
              elevation: 0.0),
          cardTheme:CardTheme(
            color: Colors.grey[700],
          ),
          iconTheme: IconThemeData(
            color: Colors.white70
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            bodyText2: TextStyle(
              color: Colors.white,
            ),
            subtitle1: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.3),
            subtitle2: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.3),
            caption: TextStyle(
                color: Colors.white70,
            ),
          ),
          sliderTheme: SliderThemeData(
            inactiveTrackColor: Colors.black,
            trackShape:RoundedRectSliderTrackShape(),
            trackHeight: 10.0,
            thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 5),
            activeTickMarkColor: Colors.red[700],
            inactiveTickMarkColor: Colors.red[100],
            valueIndicatorShape:RectangularSliderValueIndicatorShape(),
          ),
        ),
        home: hasInternet ?
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }
                if (snapShot.hasData) {
                  return SocialScreen();
                } else {
                  return AuthScreen();
                }
              },
            ) :
            InternetConnection()
        );
      },
    );
  }
}
