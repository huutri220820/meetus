import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gsc/const.dart';
import 'package:gsc/screens/widgets/gradientbutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key key}) : super(key: key);
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _eventTitle = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _maxMem = TextEditingController();
  final TextEditingController _description = TextEditingController();

  File _imageFile;

  final picker = ImagePicker();

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    await storage.ref("upload/$fileName").putFile(_imageFile);
    String downloadURL = await storage.ref("upload/$fileName").getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NameBox(text: "Event title"),
                    FormField(
                      textEdit: _eventTitle,
                      hi: 45,
                      kbType: TextInputType.text,
                    ),
                    NameBox(text: "Place"),
                    FormField(
                      textEdit: _place,
                      hi: 45,
                      kbType: TextInputType.text,
                    ),
                    NameBox(text: "Time"),
                    FormField(
                      textEdit: _time,
                      hi: 45,
                      kbType: TextInputType.datetime,
                    ),
                    NameBox(text: "Maximum member"),
                    FormField(
                      textEdit: _maxMem,
                      hi: 45,
                      kbType: TextInputType.number,
                    ),
                    NameBox(text: "Image"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile,
                                    height: 80,
                                    width: 80,
                                  )
                                : GestureDetector(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                    ),
                                    onTap: pickImage,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    NameBox(text: "Description"),
                    FormField(
                      textEdit: _description,
                      hi: 150,
                      kbType: TextInputType.text,
                    ),
                    Center(
                      child: GradientButton(
                        height: 45,
                        width: 250,
                        text: Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          final GoogleSignInAccount googleUser =
                              await GoogleSignIn().signIn();
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;
                          final GoogleAuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );
                          final user = await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          final token = await user.user.getIdToken();
                          String link = await uploadImageToFirebase(context);
                          var response = await http.post(
                            Uri.parse(serverlink + '/api/event'),
                            headers: {
                              'Authorization': 'Bearer ' + token,
                              "Content-Type": "application/json",
                            },
                            body: jsonEncode(<String, dynamic>{
                              'location': {
                                "longitude": 70,
                                "latitude": 70,
                              },
                              'limit': int.parse(_maxMem.text),
                              'time': DateTime.now().toIso8601String(),
                              "description": _description.toString(),
                              "imageMain": link,
                              "images": [link],
                            }),
                          );
                          print(response.body);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return Complete();
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}

class Complete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Event created successfully",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 10),
            Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class FormField extends StatelessWidget {
  const FormField({
    Key key,
    this.textEdit,
    this.hi,
    this.kbType,
  }) : super(key: key);

  final TextEditingController textEdit;
  final double hi;
  final TextInputType kbType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hi,
      width: MediaQuery.of(context).size.width * 0.95,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.5,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: textEdit,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        keyboardType: kbType,
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}

class NameBox extends StatelessWidget {
  final String text;
  const NameBox({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Montserrat",
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
