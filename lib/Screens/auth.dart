import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/ShowSnackBar.dart';

class Auth extends StatefulWidget {
  final Function showSnackBar = ShowSnackBar().showSnackBar;
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var email;
  var confirmPassword;
  var pwd;
  bool progress = false;
  bool googleSignIn = false;
  bool outlookSignIn = false;
  final _formKey = GlobalKey<FormState>();

  final RegExp _emailCheck = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  bool signIn = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (!signIn) if (confirmPassword != pwd) {
        widget.showSnackBar(context, 'Password does not match');
        setState(() {
          progress = false;
        });
        return;
      }
      if (signIn)
        emailLogIn();
      else
        emailSignUp();
      return;
    }
  }

  Future signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential _ = await _auth.signInWithCredential(credential);
      //print('userCredentials: $userCredential');
    } on PlatformException catch (error) {
      widget.showSnackBar(context, error.code);
      print(error);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        widget.showSnackBar(
          context,
          'The account already exists with a different credential.',
        );
        print(e);
      } else if (e.code == 'invalid-credential') {
        widget.showSnackBar(
          context,
          'Error occurred while accessing credentials. Try again.',
        );
        print(e);
      }
    } catch (err) {
      widget.showSnackBar(
          context, 'Error occurred using Google Sign-In. Try again.');
      print(err);
    }
    setState(() {
      googleSignIn = false;
    });
  }

  void emailLogIn() async {
    print('emailLogIn called');
    try {
      UserCredential _ =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('$e an error occurred');
    }
    setState(() {
      progress = false;
    });
  }

  void emailSignUp() async {
    try {
      final UserCredential _ = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('$e an error occurred');
    }
    setState(() {
      progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Auth ran');
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              Center(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: signIn
                        ? MediaQuery.of(context).viewInsets.bottom == 0.0
                            ? 479
                            : 424
                        : MediaQuery.of(context).viewInsets.bottom == 0.0
                            ? 499
                            : 444,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                'Meeting Manager',
                                style: TextStyle(
                                    fontSize: 28, fontFamily: 'StardosStencil'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: signIn ? 298 : 318,
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextFormField(
                                      key: Key('Email'),
                                      //style: TextStyle(),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                        ),
                                        labelText: 'Email',
                                        errorStyle:
                                            TextStyle(height: 0, fontSize: 14),
                                      ),
                                      validator: (value) {
                                        if (value.isNotEmpty) {
                                          if (_emailCheck.hasMatch(value))
                                            return null;
                                          else
                                            widget.showSnackBar(
                                                context, 'Not a valid Email');
                                        } else
                                          widget.showSnackBar(context,
                                              'Email cannot be empty!');
                                        return null;
                                      },
                                      onSaved: (value) {
                                        email = value;
                                      },
                                    ),
                                    TextFormField(
                                      key: Key('Password'),
                                      //style: TextStyle(),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.vertical(
                                            bottom: signIn
                                                ? Radius.circular(10)
                                                : Radius.circular(0),
                                          ),
                                        ),
                                        labelText: 'Password',
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value.isNotEmpty) {
                                          if (value.length > 8)
                                            return null;
                                          else
                                            widget.showSnackBar(context,
                                                'Password must be 9 to 15 characters ');
                                        } else
                                          widget.showSnackBar(context,
                                              'Password cannot be empty!');
                                        return null;
                                      },
                                      onSaved: (value) {
                                        pwd = value;
                                      },
                                    ),
                                    if (!signIn)
                                      TextFormField(
                                        key: Key('Confirm Password'),
                                        //style: TextStyle(),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(10),
                                            ),
                                          ),
                                          labelText: 'Confirm Password',
                                        ),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value.isNotEmpty) {
                                            if (value.length < 16)
                                              return null;
                                            else
                                              widget.showSnackBar(context,
                                                  'Username maximum length exceeded');
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          confirmPassword = value;
                                        },
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    progress
                                        ? CircularProgressIndicator()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                  (states) {
                                                    return Theme.of(context)
                                                        .colorScheme
                                                        .primary;
                                                  },
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  progress = !progress;
                                                });
                                                print('$progress 3');
                                                formSubmit();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              child: Text(
                                                signIn ? 'Log in' : 'Sign up',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            if (!signIn)
                                              setState(() {
                                                signIn = !signIn;
                                              });
                                          },
                                          child: Text(
                                            'Sign in',
                                          ),
                                        ),
                                        Text(' | '),
                                        TextButton(
                                          onPressed: () {
                                            if (signIn)
                                              setState(() {
                                                signIn = false;
                                              });
                                          },
                                          child: Text(
                                            'Sign up',
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (signIn)
                                      TextButton(
                                        onPressed: () {},
                                        child: Text('Forgot password'),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                Positioned(
                  bottom: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              googleSignIn = true;
                            });
                            signInWithGoogle();
                          },
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: googleSignIn
                                ? CircularProgressIndicator()
                                : SvgPicture.asset(
                                    'assets/images-logos-svg/google-brands.svg',
                                  ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              outlookSignIn = true;
                            });
                          },
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: outlookSignIn
                                ? CircularProgressIndicator()
                                : SvgPicture.asset(
                                    'assets/images-logos-svg/microsoft-brands.svg',
                                  ),
                          ),
                        )
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
