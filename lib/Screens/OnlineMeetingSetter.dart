import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../FunctionProviders/OnlineMeetingFunctionProviders.dart';
import '../widgets/ShowSnackBar.dart';

class OnlineManualMeets extends StatefulWidget {
  @override
  _OnlineManualMeetsState createState() => _OnlineManualMeetsState();
  static const routeName = '/OnlineMeetingSetter';
  final _user;
  final List platform = [
    'Google Meet',
    'Zoom',
    'Skype',
  ];

  final Function _showSnackBar = ShowSnackBar().showSnackBar;

  InputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    );
  }

  OnlineManualMeets(this._user);
}

class _OnlineManualMeetsState extends State<OnlineManualMeets> {
  List<dynamic> clashes = [];
  QueryDocumentSnapshot meetingDoc;
  var title;
  var selectedPlatform;
  var selectedMeetingId;
  var selectedDuration;
  DateTime selectedDate;
  DateTime selectedStartTime;
  DateTime selectedEndTime;
  DateTime picked;
  bool canAssignSlot = true;
  bool saved = false;
  bool _setEditingValue = true;
  var _docId;
  final formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  void _checkForEdit() {
    meetingDoc = ModalRoute.of(context).settings.arguments;
    if (meetingDoc == null) {
      _setEditingValue = false;
      return;
    }
    final Map<String, dynamic> _initialValue = meetingDoc.data()['Meeting Information'];
    clashes = meetingDoc.data()['Clashes'];
    _docId = meetingDoc.id;
    _setEditingValue = false;
    title = _initialValue.remove('title');
    selectedPlatform = _initialValue.remove('selectedPlatform');
    selectedMeetingId = _initialValue.remove('selectedMeetingId');
    selectedDuration = formatTimeStamp(_initialValue.remove('selectedDuration'));
    selectedDate = formatTimeStamp(_initialValue.remove('selectedDate'));
    selectedStartTime = formatTimeStamp(_initialValue.remove('selectedStartTime'));
    selectedEndTime = formatTimeStamp(_initialValue.remove('selectedEndTime'));
  }

  void formSubmit(bool update) async {
    formKey.currentState.save();
    if (update) {
      await OnlineMeetingFunctionProvider(selectedStartTime, selectedEndTime, selectedDate, _docId, meetingDoc, update).assignSlotsCheckClashes();
      try {
        await db.collection('Users/${widget._user.uid}/Meetings').doc('$_docId').update({
          'type': 'online',
          'Meeting Information': {
            'title': title,
            'selectedPlatform': selectedPlatform,
            'selectedMeetingId': selectedMeetingId,
            'selectedDate': selectedDate,
            'selectedDuration': selectedDuration,
            'selectedStartTime': selectedStartTime,
            'selectedEndTime': selectedEndTime,
          }
        });
        widget._showSnackBar(context, 'Meeting updated successfully');
      } catch (e) {
        widget._showSnackBar(context, 'An error occurred');
      }
    } else {
      try {
        final documentReference = await db.collection('Users/${widget._user.uid}/Meetings').add({
          'Clashes': clashes,
          'type': 'online',
          'Meeting Information': {
            'title': title,
            'selectedPlatform': selectedPlatform,
            'selectedMeetingId': selectedMeetingId,
            'selectedDate': selectedDate,
            'selectedDuration': selectedDuration,
            'selectedStartTime': selectedStartTime,
            'selectedEndTime': selectedEndTime,
          }
        });
        _docId = documentReference.id;
        widget._showSnackBar(context, 'Meeting Added successfully');
        await OnlineMeetingFunctionProvider(selectedStartTime, selectedEndTime, selectedDate, _docId, meetingDoc, update).assignSlotsCheckClashes();
      } catch (e) {
        widget._showSnackBar(context, 'An error occurred');
      }
    }
    print('update: $update');
    setState(() {
      saved = false;
    });
    Navigator.of(context).pop();
  }

  DateTime formatTimeStamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  }

  String _initialDurationValue(DateTime duration) {
    return duration != null
        ? '${duration.hour.toString().length == 1 ? '0${duration.hour}' : duration.hour} '
            ': ${duration.minute.toString().length == 1 ? '0${duration.minute}' : duration.minute}'
        : null;
  }

  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      helpText: 'Select meeting date',
      confirmText: 'Set',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  Future _selectTime(BuildContext context, String caller) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: caller == 'duration' ? TimePickerEntryMode.input : TimePickerEntryMode.dial,
      helpText: 'Select meeting time',
    );
    final now = DateTime.now();
    if (timePicked != null) picked = DateTime(now.year, now.month, now.day, timePicked.hour, timePicked.minute);
    setState(() {
      if (caller == 'start') {
        if (selectedDuration != null) {
          selectedStartTime = picked;
          selectedEndTime = picked.add(Duration(hours: selectedDuration.hour, minutes: selectedDuration.minute));
        } else
          selectedStartTime = picked;
      } else if (caller == 'duration') {
        selectedDuration = picked;
        if (selectedStartTime != null)
          selectedEndTime = selectedStartTime.add(Duration(hours: selectedDuration.hour, minutes: selectedDuration.minute));
        else if (selectedEndTime != null) selectedStartTime = selectedEndTime.subtract(Duration(hours: selectedDuration.hour, minutes: selectedDuration.minute));
      } else {
        if (selectedDuration != null) {
          selectedEndTime = picked;
          selectedStartTime = picked.subtract(Duration(hours: selectedDuration.hour, minutes: selectedDuration.minute));
        } else
          selectedEndTime = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_setEditingValue) {
      _checkForEdit();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Online meeting',
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.black38, width: 0.5),
        ),
        actions: [
          IconButton(
              icon: saved ? CircularProgressIndicator() : Icon(Icons.save_outlined),
              onPressed: () {
                setState(() {
                  saved = true;
                });
                formSubmit(meetingDoc != null);
              })
        ],
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
            child: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    enabled: !saved,
                    initialValue: title,
                    decoration: InputDecoration(
                      border: widget._border(),
                      labelText: 'Title',
                    ),
                    onSaved: (value) {
                      title = value;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedPlatform,
                          decoration: InputDecoration(
                            border: widget._border(),
                            labelText: 'Platform',
                          ),
                          items: widget.platform
                              .map(
                                (label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            selectedPlatform = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: selectedMeetingId,
                          decoration: InputDecoration(
                            enabled: !saved,
                            border: widget._border(),
                            labelText: 'Meeting id',
                          ),
                          onSaved: (value) {
                            selectedMeetingId = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: Key(selectedDate.toString()),
                          enabled: !saved,
                          decoration: InputDecoration(
                            border: widget._border(),
                            labelText: 'Date',
                          ),
                          showCursor: true,
                          readOnly: true,
                          initialValue: selectedDate != null ? DateFormat.yMMMEd().format(selectedDate) : null,
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          key: Key(selectedDuration.toString()),
                          enabled: !saved,
                          decoration: InputDecoration(
                            border: widget._border(),
                            labelText: 'Duration  HH:MM',
                          ),
                          showCursor: true,
                          readOnly: true,
                          onTap: () {
                            _selectTime(context, 'duration');
                          },
                          initialValue: _initialDurationValue(selectedDuration),
                          onEditingComplete: () {},
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: Key(selectedStartTime.toString()),
                          enabled: !saved,
                          decoration: InputDecoration(
                            border: widget._border(),
                            labelText: 'Start Time',
                          ),
                          showCursor: true,
                          readOnly: true,
                          initialValue: selectedStartTime != null ? MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(selectedStartTime)).toString() : null,
                          onTap: () {
                            _selectTime(context, 'start');
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          key: Key(selectedEndTime.toString()),
                          enabled: !saved,
                          decoration: InputDecoration(
                            border: widget._border(),
                            labelText: 'End Time',
                          ),
                          showCursor: true,
                          readOnly: true,
                          initialValue: selectedEndTime != null ? MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(selectedEndTime)).toString() : null,
                          onTap: () {
                            _selectTime(context, 'end');
                          },
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
