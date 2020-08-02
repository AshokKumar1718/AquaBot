import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  FirebaseUser _user;
  bool state = true;
  bool _crossFade = false;

  final kFirebaseAuth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    silentSign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(),
              Text(
                "Welcome to AQUA BOT",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                child: Image.asset(
                  'img/logo.png',
                  width: 150,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: state
                      ? CircularProgressIndicator()
                      : OutlineButton(
                          onPressed: () => doLogin(), child: Text("Sign In"))),
              Text(
                "Bannari Amman Institute of Technology",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              )
            ],
          ),
        ));
  }

  void doLogin() async {
    setState(() {
      state = true;
      _crossFade = !_crossFade;
    });
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      setState(() {
        state = false;
        _crossFade = !_crossFade;
      });
      return;
    }

    final googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await kFirebaseAuth.signInWithCredential(credential);

    setState(() {
      _crossFade = !_crossFade;
    });

    silentSign();
  }

  void silentSign() async {
    final curUser = await kFirebaseAuth.currentUser();
    if (curUser == null) {
      setState(() {
        state = false;
        _crossFade = !_crossFade;
      });
      return;
    }
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }
}
