import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'Screens/auth.dart';
import 'Screens/channels.dart';
import 'Screens/gmailChannel.dart';
import 'Screens/Homepage.dart';
import 'Screens/OfflineMeetingSetter.dart';
import 'Screens/OnlineMeetingSetter.dart';
import 'Screens/verificationScreen.dart';
import 'provider/meets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print('main ran');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MeetingsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          ),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.blue,
            errorColor: Colors.red,
          ),
          fontFamily: 'Raleway',
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.black),
          ),
        ),
        home: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final _user = _auth.currentUser;
              if (!_user.emailVerified) {
                return Verification(_user.uid);
              } else {
                return HomePage();
              }
            } else {
              return Auth();
            }
          },
        ),
        routes: {
          Channel.routeName: (ctx) => Channel(),
          HomePage.routeName: (ctx) => HomePage(),
          GmailChannel.routeName: (ctx) => GmailChannel(),
          OnlineManualMeets.routeName: (ctx) =>
              OnlineManualMeets(_auth.currentUser),
          OfflineManualMeets.routeName: (ctx) => OfflineManualMeets(),
        },
      ),
    );
  }
}
