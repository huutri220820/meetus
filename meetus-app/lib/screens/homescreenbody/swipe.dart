import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gsc/const.dart';
import 'package:gsc/model/event.dart';
import 'package:gsc/model/repositories/eventrepository.dart';
import 'package:gsc/screens/widgets/eventcard.dart';
import 'package:http/http.dart' as http;

String token = "";

class SwipeBody extends StatefulWidget {
  @override
  _SwipeBody createState() => _SwipeBody();
}

class _SwipeBody extends State<SwipeBody> with TickerProviderStateMixin {
  String swipe;
  CardController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventModel>>(
      future: getEvent(),
      builder:
          (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg3.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: TinderSwapCard(
                orientation: AmassOrientation.RIGHT,
                totalNum: snapshot.data.length,
                stackNum: 4,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 1.15,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 1.1,
                cardBuilder: (context, index) => EventCard(
                  image: snapshot.data[index].userId,
                  name: snapshot.data[index].displayName,
                  place: snapshot.data[index].place,
                ),
                cardController: controller = CardController(),
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  if (align.x < 0) {
                    swipe = "skip";
                  } else if (align.x > 0) {
                    swipe = "join";
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientaion, int index) async {
                  await http.get(
                    Uri.parse(serverlink +
                        "/api/event/" +
                        swipe +
                        "/" +
                        snapshot.data[index].id),
                    headers: {'Authorization': 'Bearer ' + token},
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return Center(
            child: Text(
              "Your've just swipe all of our events!",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<EventModel>> getEvent() async {
    final EventRepository _eventRepository = EventRepository();
    final String tk = await getAccount();
    if (token == "")
      setState(() {
        token = tk;
      });
    return _eventRepository.getAllEvent(tk);
  }
}

Future<String> getAccount() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final user = await FirebaseAuth.instance.signInWithCredential(credential);
  return await user.user.getIdToken();
}
