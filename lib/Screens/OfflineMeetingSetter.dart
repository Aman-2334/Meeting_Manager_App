import 'package:flutter/material.dart';

class OfflineManualMeets extends StatefulWidget {
  @override
  _OfflineManualMeetsState createState() => _OfflineManualMeetsState();
  static const routeName = '/OfflineMeetingSetter';
}

class _OfflineManualMeetsState extends State<OfflineManualMeets> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Offline meeting',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
