import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/ShowSnackBar.dart';

class Channel extends StatefulWidget {
  @override
  _ChannelState createState() => _ChannelState();
  static const routeName = '/ChannelPage';

  final Function showSnackBar = ShowSnackBar().showSnackBar;
}

class _ChannelState extends State<Channel> {
  Map<String, dynamic> channel;
  String status;
  String currentlyChangingChannel;
  bool changeStatus = false;
  final _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: <String>[GmailApi.gmailReadonlyScope],
  );

  void _disableChannel() async {
    print('disabling channel');
    final url = Uri.parse('https://gmail.googleapis.com/gmail/v1/users/${_user.email}/stop');
    channel['Channels_Status'].update('Enabled_Channels', (existingValue) => existingValue - 1);
    channel['Channels_Status'].update('Gmail', (existingValue) => 'Disabled');
    await db.collection('Users').doc('${_user.uid}').update({
      'Channels_Status': channel['Channels_Status'],
      'Gmail': channel['Gmail'],
    }).catchError((err) {
      print('err: $err');
      widget.showSnackBar(context, 'An error occurred');
    }).then((value) => setState(() {
          changeStatus = false;
        }));
    GoogleSignInAccount _ = await _googleSignIn.signInSilently();
    print(_googleSignIn.currentUser);
    await _googleSignIn.currentUser.authHeaders.then((value) {
      try {
        http.post(url, headers: value).then((value) => print(value.body));
        print('Channel watch disabled');
      } catch (err) {
        print('Stop watch post error: $err');
      }
    });
  }

  void _enableChannel() async {
    print("Enabling channel");
    channel['Channels_Status'].update('Enabled_Channels', (existingValue) => existingValue + 1);
    channel['Channels_Status'].update('Gmail', (existingValue) => 'Enabled');
    await db.collection('Users').doc('${_user.uid}').update({
      'Channels_Status': channel['Channels_Status'],
      'Gmail': channel['Gmail'],
    }).catchError((err) {
      print('err: $err');
      widget.showSnackBar(context, 'An error occurred');
    }).then((value) => setState(() {
          changeStatus = false;
        }));
  }

  void _getChannels() {
    channel = ModalRoute.of(context).settings.arguments;
  }

  TableRow _createTableRow(String svgFileName, String column1Text) {
    status = channel['Channels_Status'][column1Text];
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12,))
      ),
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: SvgPicture.asset('assets/images-logos-svg/$svgFileName.svg'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            height: 40,
            child: Text(
              column1Text,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (channel['Channels_Status'][column1Text] == 'Enabled')
              setState(() {
                changeStatus = true;
                currentlyChangingChannel = column1Text;
                _disableChannel();
              });
            else
              setState(() {
                changeStatus = true;
                currentlyChangingChannel = column1Text;
                _enableChannel();
              });
          },
          child: changeStatus
              ? currentlyChangingChannel == column1Text
                  ? CircularProgressIndicator()
                  : Text(status)
              : Text(status),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/gmailChannel', arguments: channel);
          },
          icon: Icon(
            Icons.edit_outlined,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('channel ran');
    _getChannels();
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: Colors.black38, width: 0.5),
        ),
        title: Text('Channels'),
      ),
      body: Container(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(5),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(),
            },
            children: [
              _createTableRow('gmail-logo', 'Gmail'),
              _createTableRow('outlook-logo', 'Outlook'),
              _createTableRow('whatsapp-logo', 'whatsapp'),
              _createTableRow('discord', 'Discord'),
              _createTableRow('slack', 'Slack'),
              _createTableRow('telegram', 'Telegram'),
              _createTableRow('google-messages', 'Messages'),
            ],
          ),
        ),
      ),
    );
  }
}
