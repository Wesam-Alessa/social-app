
import 'package:chat/Screens/main_posts_Screen/main_posts_screen.dart';
import 'package:chat/Screens/menuScreen/cards_screens/find_friend_and_friendShip_Requests/find_friends_screen.dart';
import 'package:chat/Screens/menuScreen/cards_screens/saved_screen.dart';
import 'package:chat/Screens/menuScreen/menu_screen.dart';
import 'package:chat/Screens/new_posts/new_posts_screen.dart';
import 'package:chat/Screens/notificationScreen/notification_screen.dart';
import 'package:chat/Screens/usersScreen/users_screen.dart';
import 'package:chat/widgets/icons/iconBroken.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialProvider with ChangeNotifier {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  int currentIndex = 0;
  bool loading = false;
  bool isDark = false;
  List<Widget> bottomNavScreens = [
    MainPostsScreen(),
    UsersScreen(),
    NewPostScreen(),
    NotificationsScreen(),
    MenuScreen(),
  ];

  void init(){
    prefs.then((shared) {
      isDark = shared.getBool('isDark') ?? false;
      notifyListeners();
    });
  }

  void changeTheme(bool val){
    isDark = val;
    changeThemeInSharedPreferences(val);
    notifyListeners();
  }
  void changeThemeInSharedPreferences(bool value) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setBool('isDark', value);
    var x = shared.getBool('isDark');
    print('/\/\/\/\\/\//\\/\/\/\/\/\/\/\\/\//\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/\//\/\/\/\/\\/\/\/\\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ $x');
  }

  List<String> titles = [
    'Home',
    'Chats',
    'Create Post',
    'Notifications',
    'Menu',
  ];

  void changeNavbarIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  // Future<void> getUsers()async{
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((value){
  //     value.docs.forEach((element) {
  //       users.add(UserModel.fromJson(element.data()));
  //     });
  //   })
  //       .catchError((error){
  //     print(error.toString());
  //     throw error;
  //   });
  //   notifyListeners();
  // }


  var menuCardItems = [
    {
      'icon': IconBroken.Folder,
      "title": 'Saved',
      'new': 0,
      'onTap':SavedScreen()
    },
    {
      'icon': IconBroken.Add_User,
      "title": 'Find Friends',
      'new': 0,
      'onTap':FindFriendsScreen()
    },
    // {
    //   'icon': IconBroken.Play,
    //   "title": 'Videos on Watch',
    //   'new': 7,
    //   'onTap':VideosOnWatchScreen()
    // },
    // {
    //   'icon': IconBroken.User1,
    //   "title": 'Groups',
    //   'new': 0,
    //   'onTap':GroupsScreen()
    // },
    // {
    //   'icon': Icons.event_available_outlined,
    //   "title": 'Events',
    //   'new': 3,
    // },
  ];

  List<String> cities = [
    //"Capital cities in Europe",
    "Åland Islands	Mariehamn",
    "Albania	Tirana",
    "Andorra	Andorra la Vella",
    "Austria	Vienna",
    "Belarus	Minsk	",
    "Belgium	Brussels",
    "Bosnia and Herzegovina	Sarajevo",
    "Bulgaria	Sofia",
    "Croatia	Zagreb",
    "Czechia	Prague",
    "Denmark	Copenhagen",
    "Estonia	Tallinn",
    "Faroe Islands	Tórshavn",
    "Finland	Helsinki",
    "France	Paris",
    "Germany	Berlin",
    "Gibraltar	Gibraltar",
    "Greece	Athens",
    "Guernsey	Saint Peter Port",
    "Hungary	Budapest",
    "Iceland	Reykjavík",
    "Ireland	Dublin",
    "Isle of Man	Douglas",
    "Italy	Rome",
    "Jersey	Saint Helier",
    "Kosovo	Pristina",
    "Latvia	Riga",
    "Liechtenstein	Vaduz",
    "Lithuania	Vilnius",
    "Luxembourg	Luxembourg",
    "Malta	Valletta",
    "Moldova	Chisinau",
    "Monaco	Monaco",
    "Montenegro	Podgorica",
    "Netherlands	Amsterdam",
    "North Macedonia	Skopje",
    "Norway	Oslo",
    "Poland	Warsaw",
    "Portugal	Lisbon",
    "Romania	Bucharest",
    "Russia	Moscow",
    "San Marino	San Marino",
    "Serbia	Belgrade",
    "Slovakia	Bratislava",
    "Slovenia	Ljubljana",
    "Spain	Madrid",
    "Svalbard	Longyearbyen",
    "Sweden	Stockholm",
    "Switzerland	Bern",
    "Ukraine	Kiev",
    "United Kingdom	London",
    //"Capital cities in the Americas",
    "Anguilla	The Valley",
    "Antigua and Barbuda	Saint John\'s",
    "Argentina	Buenos Aires",
    "Aruba	Oranjestad",
    "Bahamas	Nassau",
    "Barbados	Bridgetown",
    "Belize	Belmopan",
    "Bermuda	Hamilton",
    "Bolivia	Sucre",
    "Brazil	Brasília",
    "British Virgin Islands	Road Town",
    "Canada	Ottawa",
    "Cayman Islands	George Town",
    "Chile	Santiago",
    "Colombia	Bogotá",
    "Costa Rica	San José",
    "Cuba	Havana",
    "Curacao	Willemstad",
    "Dominica	Roseau",
    "Dominican Republic	Santo Domingo",
    "Ecuador	Quito	",
    "El Salvador	San Salvador",
    "Falkland Islands	Stanley",
    "French Guiana	Cayenne",
    "Greenland	Nuuk",
    "Grenada	Saint George \' s",
    "Guadeloupe	Basse-Terre",
    "Guatemala	Guatemala City",
    "Guyana	Georgetown",
    "Haiti	Port-au-Prince",
    'Honduras	Tegucigalpa',
    "Jamaica	Kingston",
    "Martinique	Fort-de-France",
    "Mexico	Mexico City",
    "Montserrat	Brades",
    "Nicaragua	Managua",
    "Panama	Panama City",
    "Paraguay	Asunción",
    "Peru	Lima",
    "Puerto Rico	San Juan",
    "Saint Barthelemy	Gustavia",
    "Saint Kitts and Nevis	Basseterre",
    "Saint Lucia	Castries",
    "Saint Martin	Marigot",
    "Saint Pierre and Miquelon	Saint-Pierre",
    "Saint Vincent and the Grenadines	Kingstown",
    "Sint Maarten	Philipsburg",
    'South Georgia and South Sandwich Islands	King Edward Point	',
    "Suriname	Paramaribo",
    "Trinidad and Tobago	Port-of-Spain",
    "Turks and Caicos Islands	Cockburn Town",
    "United States	Washington D.C.",
    "Uruguay	Montevideo",
    "Venezuela	Caracas",
    "Virgin Islands	Charlotte Amalie",
    //"Capital cities in Asia",
    "Afghanistan	Kabul",
    "Armenia	Yerevan",
    "Azerbaijan	Baku",
    "Bahrain	Manama",
    "Bangladesh	Dhaka",
    "Bhutan	Thimphu",
    "Brunei	Bandar Seri Begawan",
    "Burma	Nay Pyi Taw",
    "Cambodia	Phnom Penh",
    "China	Beijing",
    "Cyprus	Nicosia",
    "East Timor	Dili",
    "Georgia	Tbilisi",
    "Hong Kong	Hong Kong",
    "India	New Delhi",
    "Indonesia	Jakarta",
    "Iran	Tehran",
    "Iraq	Baghdad",
    "Israel	Jerusalem",
    "Japan	Tokyo",
    "Jordan	Amman",
    "Kazakhstan	Nursultan	",
    "Kuwait	Kuwait City",
    "Kyrgyzstan	Bishkek",
    "Laos	Vientiane",
    "Lebanon	Beirut",
    "Macao	Concelho de Macau	",
    "Malaysia	Kuala Lumpur",
    "Maldives	Malé",
    "Mongolia	Ulaanbaatar",
    "Nepal	Kathmandu",
    "North Korea	Pyongyang	",
    "Oman	Muscat",
    "Pakistan	Islamabad",
    "Palestine	Ramallah",
    "Philippines	Manila",
    "Qatar	Doha",
    "Saudi Arabia	Riyadh",
    "Singapore	Singapore",
    "South Korea	Seoul",
    "Sri Lanka	Colombo",
    "Syria	Damascus",
    "Taiwan	Taipei",
    "Tajikistan	Dushanbe",
    "Thailand	Bangkok",
    "Turkey	Ankara",
    "Turkmenistan	Ashgabat",
    "United Arab Emirates	Abu Dhabi",
    "Uzbekistan	Tashkent",
    "Vietnam	Hanoi",
    "Yemen	Sanaa",
    //"Capital cities on the Australian continent",
    "Australia	Canberra",
    "Christmas Island	Flying Fish Cove",
    "Cocos (Keeling) Islands	West Island",
    "New Zealand	Wellington",
    "Norfolk Island	Kingston",
    //"Capital cities in Africa",
    "Algeria	Algiers",
    "Angola	Luanda",
    "Benin	Porto-Novo",
    "Botswana	Gaborone",
    "Burkina Faso	Ouagadougou",
    "Burundi	Bujumbura",
    "Cameroon	Yaoundé",
    "Cape Verde	Praia",
    "Central African Republic	Bangui",
    "Chad	N\'Djamena",
    "Comoros	Moroni",
    "Democratic Republic of the Congo	Kinshasa",
    "Djibouti	Djibouti",
    "Egypt	Cairo	",
    "Equatorial Guinea	Malabo",
    "Eritrea	Asmara	",
    "Eswatini	Mbabane",
    "Ethiopia	Addis Ababa",
    "Gabon	Libreville",
    "Gambia	Banjul",
    "Ghana	Accra",
    "Guinea	Conakry",
    "Guinea-Bissau	Bissau",
    "Ivory Coast	Yamoussoukro",
    "Kenya	Nairobi",
    "Lesotho	Maseru",
    "Liberia	Monrovia",
    "Libya	Tripoli",
    "Madagascar	Antananarivo",
    "Malawi	Lilongwe",
    "Mali	Bamako",
    "Mauritania	Nouakchott",
    "Mauritius	Port Louis	",
    "Mayotte	Mamoudzou",
    "Morocco	Rabat",
    "Mozambique	Maputo",
    "Namibia	Windhoek",
    "Niger	Niamey",
    "Nigeria	Abuja",
    "Republic of the Congo	Brazzaville	",
    "Reunion	Saint-Denis",
    "Rwanda	Kigali",
    "Saint Helena, Ascension and Tristan da Cunha	Jamestown",
    "Sao Tome and Principe	São Tomé",
    "Senegal	Dakar",
    "Seychelles	Victoria",
    "Sierra Leone	Freetown",
    "Somalia	Mogadishu",
    "South Africa	Pretoria",
    "South Sudan	Juba",
    "Sudan	Khartoum",
    "Tanzania	Dodoma",
    "Togo	Lomé",
    "Tunisia	Tunis",
    "Uganda	Kampala	",
    "Western Sahara	El Aaiún",
    "Zambia	Lusaka",
    "Zimbabwe	Harare",
  ];

  List<String> relationShip = [
    '___',
    'Single',
    'In a relationship',
    'Engaged',
    'Married',
    'In a civil union',
    'In a domestic partnership',
    'In an open relationship',
    'It\'s complicated',
    'Separated',
    'Divorced',
    'Widowed',
  ];

  List<String> genders = [
    '___',
    'Male',
    'Female',
  ];
}
