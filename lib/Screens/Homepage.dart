import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/GenerateMeets.dart';
import '../widgets/ShowSnackBar.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/Homepage';
  final Function _showSnackBar = ShowSnackBar().showSnackBar;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[GmailApi.gmailReadonlyScope],
  );
  final _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, String> _authHeaders;
  Map<String, dynamic> userDoc;
  final meetingExtractor = RegExp(r"Title:\s*(.*)[\S]*Platform:\s*(.*)[\S]*Meeting Id:\s*(.*)[\S]*Date:\s*(.*)[\S]*Duration:\s*(.*)[\S]*StartTime:\s*(.*)[\S]*EndTime:\s*(.*)([\s\S]*)");

  void _addMeeting(messageGetResponse) {
    print('_addMeeting ran');
    final rawMessage = json.decode(messageGetResponse.body)['payload']['parts'].firstWhere((part) => part["mimeType"] == "text/plain")['body']['data'];
    print('rawMessage: $rawMessage');
    final message = utf8.decode(base64.decode(rawMessage));
    print('message: $message');
    // print(meetingExtractor.firstMatch(mess));
  }

  Future<void> _getPermission() async {
    GoogleSignInAccount _ = await _googleSignIn.signInSilently();
    _authHeaders = await _googleSignIn.currentUser.authHeaders;
  }

  void _searchMails(response, DocumentSnapshot channels) async {
    print('_searchMailsRan');
    final messageGetUrl = 'https://gmail.googleapis.com/gmail/v1/users/${_user.email}/messages/';
    final historyList = json.decode(response.body);
    final List<dynamic> history = historyList['history'];
    print('history: $history');
    history.forEach((element) async {
      final messageAddedId = element['messagesAdded'][0]['message']['id'];
      try {
        print('messageAddedId $messageAddedId');
        final messageGetResponse = await http.get(Uri.parse('$messageGetUrl$messageAddedId'), headers: _authHeaders);
        print('messageGetResponse: $messageGetResponse');
        final sender = RegExp(r"<(.*)>").firstMatch(json.decode(messageGetResponse.body)['payload']['headers'].reversed.firstWhere((header) => header['name'] == 'From')['value']).group(1);
        print('sender: $sender');
        if (channels.data()['Gmail'].contains(sender)) _addMeeting(messageGetResponse);
      } catch (err) {
        print('_getHistory history error: $err');
      }
    });
  }

  void _syncMails() async {
    print('_syncMails ran');
    await _getPermission();
    print('_authHeaders: $_authHeaders');
    final channels = await db.collection('Users').doc('${_user.uid}').get();
    print('channels.data(): ${channels.data()}');
    final historyListUrl = 'https://gmail.googleapis.com/gmail/v1/users/${_user.email}/history?historyTypes=messageAdded';
    try {
      print('_referenceHistoryId: ${channels.data()['ReferenceHistoryId']}');
      final historyListResponse = await http.get(Uri.parse('$historyListUrl&startHistoryId=${int.parse(channels.data()['ReferenceHistoryId'])}'), headers: _authHeaders);
      print('historyListResponse: ${json.decode(historyListResponse.body)}');
      final _newMessagesAdded = json.decode(historyListResponse.body).containsKey('history');
      print('_newMessagesAdded: $_newMessagesAdded');
      _newMessagesAdded ? _searchMails(historyListResponse, channels) : _updateHistoryId();
    } catch (err) {
      print('_getHistory message error: $err');
    }
  }

  void _updateHistoryId() {
    print('_updateHistory ran');
  }

  void _updateDatabaseSlots(slots) async {
    print('_updateDatabaseSlots ran');
    await db.collection('Users').doc('${_user.uid}').update({
      'Slots': slots,
    }).catchError((err) {
      print('_updateDatabaseSlots err: $err');
    });
  }

  var i;

  void _updateSlot() {
    print('_updateSlot ran');
    final slots = userDoc['Slots'];
    if (slots.isEmpty) {
      slots['${DateFormat('yyyy-MM-dd').format(DateTime.now())}'] = {for (var hour = 0; hour < 24; hour++) hour.toString(): {}};
      _updateDatabaseSlots(slots);
      return;
    }
    final List<String> keys = slots.keys.toList();
    keys.sort();
    print(keys);
    for (i = 0; i < keys.length; i++) {
      final difference = DateTime.parse(keys[i]).difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())));
      if (difference.inDays < 0) {
        slots.remove(keys[i]);
      } else if (difference.inDays > 0) {
        break;
      } else {
        if (i == 0) _updateDatabaseSlots(slots);
        return;
      }
      print('slots: $slots');
    }
    slots['${DateFormat('yyyy-MM-dd').format(DateTime.now())}'] = {for (var hour = 0; hour < 24; hour++) hour.toString(): {}};
    _updateDatabaseSlots(slots);
  }

  @override
  Widget build(BuildContext context) {
    print('Homepage ran');
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: Colors.black38, width: 0.5),
        ),
        title: Text('Meetings'),
        actions: <Widget>[
          IconButton(
            onPressed: _syncMails,
            icon: Icon(Icons.sync_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/ChannelPage', arguments: userDoc),
            icon: Icon(Icons.list),
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () async {
              try {
                await _googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
              } catch (err) {
                print('SignOut error: $err');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: db.collection('Users').doc('${_user.uid}').get().then((snapshot) {
              if (!snapshot.exists) {
                db.collection('Users').doc('${_user.uid}').set({
                  'Channels_Status': {
                    'Enabled_Channels': 0,
                    'Gmail': 'Disabled',
                    'Outlook': 'Disabled',
                    'whatsapp': 'Disabled',
                    'Discord': 'Disabled',
                    'Slack': 'Disabled',
                    'Telegram': 'Disabled',
                    'Messages': 'Disabled',
                  },
                  'Gmail': [],
                  'Outlook': [],
                  'whatsapp': [],
                  'Discord': [],
                  'Slack': [],
                  'Telegram': [],
                  'Messages': [],
                  'ReferenceHistoryId': '0',
                  'Slots': {},
                }).catchError((err) {
                  widget._showSnackBar(context, 'An error occurred');
                });
                return db.collection('Users').doc('${_user.uid}').get();
              } //create snapshot
              return snapshot;
            }),
            builder: (futureBuilderCtx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (futureSnapshot.connectionState == ConnectionState.done) {
                userDoc = futureSnapshot.data.data();
                _updateSlot();
                return StreamBuilder(
                    stream: db.collection('Users').doc('${_user.uid}').collection('Meetings').snapshots(),
                    builder: (streamBuilderCtx, streamSnapshot) {
                      print('Stream updated');
                      if (streamSnapshot.connectionState == ConnectionState.active) {
                        if (streamSnapshot.data.docs.length != 0)
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return GenerateMeeting(streamSnapshot.data.docs[index]);
                            },
                            itemCount: streamSnapshot.data.docs.length,
                          );
                        else if (userDoc['Channels_Status']['Enabled_Channels'] == 0)
                          return Center(
                              child: RichText(
                                  text: TextSpan(children: [
                            TextSpan(
                              text: 'Add ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'channels ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed('/ChannelPage', arguments: userDoc);
                                },
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextSpan(
                              text: 'to start getting meetings.',
                              style: TextStyle(color: Colors.black),
                            ),
                          ])));
                        else
                          return Center(
                            child: Text('No upcoming meetings'),
                          );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 3,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed('/OnlineMeetingSetter');
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Online Meeting',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed('/OfflineMeetingSetter');
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Offline Meeting',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
