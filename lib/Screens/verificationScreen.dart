import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();

  final userUid;

  Verification(this.userUid);

  ScaffoldFeatureController showSnackBar(ctx, text) {
    return ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 700),
      content: Text(text),
      backgroundColor: Colors.black,
    ));
  }

  SizedBox _sizedBox(String svg) {
    return SizedBox(
      height: 65,
      width: 65,
      child: SvgPicture.asset(
        svg,
      ),
    );
  }
}

class _VerificationState extends State<Verification> {
  bool resendVerification = false;
  bool _verifying = false;

//  Timer _timer;
  int _sec = 15;
  int _min = 0;
  int resendLimit = 3;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future _sendVerification() async {
    print('verification email sent');
    --resendLimit;
    print('resend left: $resendLimit');
    try {
      await _auth.currentUser.sendEmailVerification();
    } catch (err) {
      widget.showSnackBar(context, 'Some error occurred while sending Verification mail');
    }
  }

  @override
  void initState() {
    // final _userRef = await db.collection('Users/${widget.userUid}/Verification').doc('Verification_Information').get();
    // print(_userRef);
    //startTimer();
    //_sendVerification();
    super.initState();
  }

  void _deleteUser() async {
    await _auth.currentUser.delete();
  }

  // void _timeUp() {
  //   print('time up called');
  // }

  // void startTimer() {
  //   print('timer started');
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(oneSec, (Timer timer) {
  //     if (_sec == 0) {
  //       if (_min == 0) {
  //         _timer.cancel();
  //         _timeUp();
  //       } else {
  //         setState(() {
  //           _min--;
  //           _sec = 59;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         _sec--;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    //   _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Verification Screen');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: Colors.black38, width: 0.5),
        ),
        title: Text('Email Verification'),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget._sizedBox('assets/images-logos-svg/gmail-logo.svg'),
                            SizedBox(
                              width: 20,
                            ),
                            widget._sizedBox('assets/images-logos-svg/mail-ios-logo.svg'),
                            SizedBox(
                              width: 20,
                            ),
                            widget._sizedBox('assets/images-logos-svg/outlook-logo.svg'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'A verification mail has been sent to ${_auth.currentUser.email} kindly verify.',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Time left ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // Timer(duration, callback),
                            Text(
                              '0$_min:${_sec < 10 ? '0$_sec' : _sec.toString()}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'If verified click below to sign in again.',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _verifying = true;
                          });
                          await _auth.currentUser.reload();
                          _auth.currentUser.reload().whenComplete(() => setState(() {
                                _verifying = false;
                              }));
                          // print(_auth.currentUser);
                          _auth.currentUser.emailVerified ? await _auth.signOut() : widget.showSnackBar(context, 'Email not yet verified');
                        },
                        child: _verifying
                            ? CircularProgressIndicator()
                            : Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _verifying || resendVerification
                                ? () {}
                                : () async {
                                    setState(() {
                                      resendVerification = true;
                                    });
                                    await _auth.currentUser.sendEmailVerification().whenComplete(() => print('Initial verification cancelled'));
                                    if (resendLimit > 0)
                                      _sendVerification();
                                    else
                                      widget.showSnackBar(context, 'Maximum resend limit reached');
                                    setState(() {
                                      resendVerification = false;
                                    });
                                  },
                            child: resendVerification
                                ? CircularProgressIndicator()
                                : Text(
                                    "Resend Verification Mail",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteUser();
                            },
                            child: Text(
                              'Incorrect email!',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
