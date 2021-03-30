import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsc/logic/login/authenticationprovider.dart';
import 'package:gsc/screens/homescreenbody/homescreen.dart';
import 'package:gsc/screens/widgets/gradientbutton.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phonenumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: Color.fromRGBO(99, 56, 161, 1),
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Color.fromRGBO(99, 56, 161, 1),
                    size: 35,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 110),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/a.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Join Social",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 45,
                width: 280,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.5,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(80),
                ),
                child: TextFormField(
                  controller: _phonenumber,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    icon: Icon(Icons.phone),
                    hintText: "Phone number",
                  ),
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.always,
                ),
              ),
              GradientButton(
                width: 200,
                height: 45,
                onPressed: () {},
                text: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                    ),
                    Text(
                      " Or ",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if (res)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return HomeScreen();
                      }),
                    );
                },
                child: Container(
                  height: 40,
                  width: 200,
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.5,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: Text(
                    "Continue with Google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () async {},
                child: Container(
                  height: 40,
                  width: 200,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.5,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: Text(
                    "Continue with Facebook",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    ),
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
