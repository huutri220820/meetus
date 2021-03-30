import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gsc/screens/homescreenbody/chatscreen.dart';
import 'package:gsc/screens/homescreenbody/createevent.dart';
import 'package:gsc/screens/homescreenbody/swipe.dart';
import 'package:gsc/screens/homescreenbody/profile.dart';
import 'package:gsc/logic/login/authenticationprovider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _title = [
    "Profile",
    "Event match",
    "Message",
    "Create an event"
  ];
  List<StatefulWidget> _body = [
    ProfileBody(),
    SwipeBody(),
    ChatScreen(),
    CreateEvent(),
  ];
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromRGBO(255, 208, 215, 1),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        height: 70.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30.0,
            color: Colors.redAccent,
          ),
          Icon(
            Icons.connect_without_contact_rounded,
            size: 30.0,
            color: Colors.redAccent,
          ),
          Icon(
            Icons.chat_bubble,
            size: 30.0,
            color: Colors.redAccent,
          ),
          Icon(
            Icons.add,
            size: 30.0,
            color: Colors.redAccent,
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _page = index;
            },
          );
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _title[_page],
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.black,
                  ),
                  onTap: () {
                    AuthProvider().logOut();
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: _body[_page],
    );
  }
}
