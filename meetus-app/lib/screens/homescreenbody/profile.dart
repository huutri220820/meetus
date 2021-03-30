import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gsc/model/repositories/userrepository.dart';
import 'package:gsc/model/user.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  List searchImages = [
    "https://i.pinimg.com/564x/27/6d/2d/276d2d457de75c489de3cf4c7c855e23.jpg",
    "https://i.pinimg.com/564x/d4/09/c4/d409c45b54870e01a0295ce2c5450e8d.jpg",
    "https://i.pinimg.com/564x/c9/a1/3b/c9a13b1ea71042a664cfd85b42da9f18.jpg",
    "https://i.pinimg.com/564x/89/ef/d1/89efd145fd3c32f84664986ad04e2de7.jpg",
    "https://i.pinimg.com/564x/dd/2a/30/dd2a30397561dd1979793559728a9c54.jpg",
    "https://i.pinimg.com/564x/45/0a/0b/450a0bfdacbc74e556e99d1544d1014b.jpg",
    "https://i.pinimg.com/564x/4e/a4/02/4ea402aec75b9483ffc6050a043f8217.jpg",
    "https://i.pinimg.com/564x/80/67/7c/80677c5a53484998f8f66f8bcb9add7a.jpg",
    "https://i.pinimg.com/564x/7a/0b/a8/7a0ba86c14a49cb3a5345ba146e967c3.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getAccount(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              SizedBox(height: 85),
              Container(
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.width * 0.95) /
                                  16 *
                                  9 +
                              60,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height:
                                    (MediaQuery.of(context).size.width * 0.95) /
                                        16 *
                                        9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://i.pinimg.com/originals/20/83/f7/2083f7d1bea6bc65e7bfad1e08e035c7.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left:
                                    (MediaQuery.of(context).size.width * 0.95) /
                                            2 -
                                        60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.white, spreadRadius: 4),
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        NetworkImage(snapshot.data.photoURL),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          snapshot.data.displayName,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                            ),
                            Text(
                              "VietNam",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Just a friendly guy on the earth <3",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 25),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: List.generate(
                            searchImages.length,
                            (index) {
                              return Container(
                                width:
                                    (MediaQuery.of(context).size.width - 30) /
                                        3,
                                height:
                                    (MediaQuery.of(context).size.width - 30) /
                                        3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(searchImages[index]),
                                      fit: BoxFit.cover),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Future<UserModel> getAccount() async {
  final UserRepository _userRepository = UserRepository();
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final user = await FirebaseAuth.instance.signInWithCredential(credential);
  final idToken = await user.user.getIdToken();
  return _userRepository.getUser(idToken);
}
