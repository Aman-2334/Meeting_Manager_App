import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../widgets/ChannelListTile.dart';

class GmailChannel extends StatefulWidget {
  const GmailChannel({Key key}) : super(key: key);
  static const routeName = '/gmailChannel';

  @override
  _GmailChannelState createState() => _GmailChannelState();
}

class _GmailChannelState extends State<GmailChannel> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> accountList;
  String email;
  String _referenceHistoryId;
  bool _watch = true;
  bool _permissionReceived = false;
  Map<String, String> _authHeaders;
  final RegExp _emailCheck = RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[GmailApi.gmailReadonlyScope],
  );

  void _addListItem(value) async {
    setState(() {
      accountList['Gmail'].add(value);
    });
    if (accountList['Channels_Status']['Gmail'] == 'Disabled') {
      accountList['Channels_Status'].update('Enabled_Channels', (existingValue) => existingValue + 1);
      accountList['Channels_Status'].update('Gmail', (existingValue) => 'Enabled');
    }
    await db.collection('Users').doc('${_user.uid}').update(
      {
        'Channels_Status': accountList['Channels_Status'],
        'Gmail': FieldValue.arrayUnion(accountList['Gmail']),
      },
    ).catchError((err) {
      print('err: $err');
    });
  }

  void _deleteListItem(index) async {
    setState(() {
      accountList['Gmail'].removeAt(index);
    });
    if (accountList['Channels_Status']['Gmail'] == 'Enabled' && accountList['Gmail'].length == 0) {
      accountList['Channels_Status'].update('Enabled_Channels', (existingValue) => existingValue - 1);
      accountList['Channels_Status'].update('Gmail', (existingValue) => 'Disabled');
    }
    await db.collection('Users').doc('${_user.uid}').update({
      'Channels_Status': accountList['Channels_Status'],
      'Gmail': accountList['Gmail'],
    }).catchError((err) {
      print('err: $err');
    });
  }

  void _getHistory() {
    final messageListUrl = Uri.parse('https://gmail.googleapis.com/gmail/v1/users/${_user.email}/messages?maxResults=1');
    try {
      http.get(messageListUrl, headers: _authHeaders).then((response) {
        final String messageId = json.decode(response.body)['messages'][0]['id'];
        final messageGetUrl = Uri.parse('https://gmail.googleapis.com/gmail/v1/users/${_user.email}/messages/$messageId');
        try {
          http.get(messageGetUrl, headers: _authHeaders).then((response) async {
            _referenceHistoryId = json.decode(response.body)['historyId'];
            await db.collection('Users').doc('${_user.uid}').update(
              {
                'ReferenceHistoryId': _referenceHistoryId,
              },
            ).catchError((err) {
              print('err: $err');
            });
          });
        } catch (err) {
          print('_getHistory history error: $err');
        }
      });
    } catch (err) {
      print('_getHistory message error: $err');
    }
  }

  Future<void> _getPermission() async {
    GoogleSignInAccount _ = _permissionReceived ? await _googleSignIn.signInSilently() : await _googleSignIn.signIn();
    _authHeaders = await _googleSignIn.currentUser.authHeaders;
  }

  void _formSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _addListItem(email);
    }
  }

  // void _setWatch(String userId) {
  //   final url = Uri.parse('https://gmail.googleapis.com/gmail/v1/users/$userId/watch');
  //   try {
  //     http
  //         .post(url,
  //             headers: _authHeaders,
  //             body: json.encode({
  //               "labelIds": ["INBOX"],
  //               "topicName": "projects/themxm/topics/GmailWatchTest",
  //             }))
  //         .then((value) => print(json.decode(value.body)));
  //   } catch (err) {
  //     print('err: $err');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    accountList = ModalRoute.of(context).settings.arguments;
    if (accountList['_referenceHistoryId'] == '0') {
      _permissionReceived = false;
      _getPermission().then((_) {
        _permissionReceived = true;
        if (_watch) {
          _getHistory();
          // _setWatch(_user.email);
          _watch = false;
        }
      });
    } else {
      _permissionReceived = true;
      _getPermission();
    }

    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: Colors.black38, width: 0.5),
        ),
        title: Text('Gmail Channel'),
      ),
      body: SafeArea(
        child: accountList['Gmail'].length > 0
            ? ListView.builder(
                itemBuilder: (ctx, index) {
                  return ChannelListTile(accountList['Gmail'][index], _deleteListItem, index);
                },
                itemCount: accountList['Gmail'].length,
              )
            : Center(
                child: Text('No gmail accounts added yet.'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            insetPadding: EdgeInsets.all(30),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Enter a Gmail account', suffixIcon: Icon(Icons.check)),
                      validator: (value) {
                        if (value.isNotEmpty) {
                          if (_emailCheck.hasMatch(value))
                            return null;
                          else
                            return 'Not a valid Email';
                        } else
                          Navigator.of(context).pop();
                        return '';
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _formSubmit();
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
