import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineMeetingFunctionProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final meetingDoc;
  final User _user = FirebaseAuth.instance.currentUser;
  DateTime selectedStartTime;
  DateTime selectedEndTime;
  DateTime selectedDate;
  bool update;
  var docId;
  final clashedMeetingId = [];
  bool canAssignSlot = true;

  OnlineMeetingFunctionProvider(this.selectedStartTime, this.selectedEndTime, this.selectedDate, this.docId, this.meetingDoc, this.update);

  Future<void> assignSlotsCheckClashes() async {
    print('assignSlotsCheckClashes ran');
    final startTimeHourSlot = selectedStartTime.hour;
    final endTimeHourSlot = selectedEndTime.hour;
    final startTimeMinuteSlot = selectedStartTime.minute;
    final endTimeMinuteSlot = selectedEndTime.minute;
    final userDocs = await db.collection('Users').doc('${_user.uid}').get();
    Map<String, dynamic> slots = userDocs.data()['Slots'];
    final meetingStartDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    var meetingEndDate = DateFormat('yyyy-MM-dd').format(selectedEndTime);
    if (meetingEndDate != DateFormat('yyyy-MM-dd').format(selectedStartTime)) meetingEndDate = DateFormat('yyyy-MM-dd').format(selectedDate.add(Duration(days: 1)));
    if (update) slots = await updateInitialSlots(slots);
    if (!slots.containsKey(meetingStartDate)) slots[meetingStartDate] = {for (var hour = 0; hour < 24; hour++) hour.toString(): {}};
    if (!slots.containsKey(meetingEndDate)) slots[meetingEndDate] = {for (var hour = 0; hour < 24; hour++) hour.toString(): {}};
    print('startTime = $startTimeHourSlot endTimeHourSlot = $endTimeHourSlot meetingStartDate= $meetingStartDate meetingEndDate= $meetingEndDate slots=$slots ');
    var k = 0;
    var i = startTimeHourSlot;
    var slotKey = meetingStartDate;
    if (meetingStartDate != meetingEndDate) k = 1;
    while (i <= endTimeHourSlot || k == 1) {
      var currentStartTimeMinuteSlot = 0;
      var currentEndTimeMinuteSlot = 59;
      if (i == 24) {
        i = 0;
        k -= 1;
        slotKey = meetingEndDate;
      }
      if (slots[slotKey][i.toString()].isEmpty) {
        if (i != startTimeHourSlot && i != endTimeHourSlot) {
          slots[slotKey][i.toString()][docId] = createSlot(0, 59);
        } else {
          if (meetingStartDate == meetingEndDate) {
            if (startTimeHourSlot == endTimeHourSlot) {
              slots[slotKey][i.toString()][docId] = createSlot(startTimeMinuteSlot, endTimeMinuteSlot);
            } else {
              if (i == startTimeHourSlot)
                slots[slotKey][i.toString()][docId] = createSlot(startTimeMinuteSlot, 59);
              else
                slots[slotKey][i.toString()][docId] = createSlot(0, endTimeMinuteSlot);
            }
          } else {
            if (i == startTimeHourSlot && k == 1)
              slots[slotKey][i.toString()][docId] = createSlot(startTimeMinuteSlot, 59);
            else
              slots[slotKey][i.toString()][docId] = createSlot(0, endTimeMinuteSlot);
          }
        }
      } else {
        if (i == startTimeHourSlot && i != endTimeHourSlot) {
          currentStartTimeMinuteSlot = startTimeMinuteSlot;
          currentEndTimeMinuteSlot = 59;
        } else if (i != startTimeHourSlot && i == endTimeHourSlot) {
          currentStartTimeMinuteSlot = 0;
          currentEndTimeMinuteSlot = endTimeMinuteSlot;
        } else if (i == startTimeHourSlot && i == endTimeHourSlot) {
          if (k == 1) {
            currentStartTimeMinuteSlot = startTimeMinuteSlot;
            currentEndTimeMinuteSlot = 0;
          } else {
            currentStartTimeMinuteSlot = 0;
            currentEndTimeMinuteSlot = endTimeMinuteSlot;
          }
        }
        for (var meetingId in slots[slotKey][i.toString()].keys) {
          if (!clashedMeetingId.contains(meetingId)) {
            if (slots[slotKey][i.toString()][meetingId]['startTimeMinuteSlot'] == 0 && slots[slotKey][i.toString()][meetingId]['endTimeMinuteSlot'] == 59) {
              clashedMeetingId.add(meetingId);
            } else if (slots[slotKey][i.toString()][meetingId]['startTimeMinuteSlot'] == 0 && slots[slotKey][i.toString()][meetingId]['endTimeMinuteSlot'] != 59) {
              if (currentStartTimeMinuteSlot <= slots[slotKey][i.toString()][meetingId]['endTimeMinuteSlot']) {
                clashedMeetingId.add(meetingId);
              }
            } else if (slots[slotKey][i.toString()][meetingId]['startTimeMinuteSlot'] != 0 && slots[slotKey][i.toString()][meetingId]['endTimeMinuteSlot'] == 59) {
              if (currentEndTimeMinuteSlot >= slots[slotKey][i.toString()][meetingId]['startTimeMinuteSlot']) {
                clashedMeetingId.add(meetingId);
              }
            } else {
              if (currentStartTimeMinuteSlot >= slots[slotKey][i.toString()][meetingId]['startTimeMinuteSlot'] &&
                      currentStartTimeMinuteSlot <= slots[slotKey][i.toString()][meetingId]['endTimeMinuteSlot'] ||
                  currentEndTimeMinuteSlot >= slots[slotKey][i.toString()][meetingId]['startTimeMinuteSlot'] &&
                      currentEndTimeMinuteSlot <= slots[slotKey][i.toString()][meetingId]['endTimeMinuteSlot']) {
                clashedMeetingId.add(meetingId);
              }
            }
          }
        }
        slots[slotKey][i.toString()][docId] = createSlot(currentStartTimeMinuteSlot, currentEndTimeMinuteSlot);
      }
      i += 1;
    }
    print('slots: $slots');
    updateClashes();
    updateSlots(slots);
  }

  DateTime formatTimeStamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  }

  Future<dynamic> updateInitialSlots(slots) async {
    print('updateInitialSlots ran');
    final Map<String, dynamic> _initialValue = meetingDoc.data()['Meeting Information'];
    final selectedStartTime = formatTimeStamp(_initialValue['selectedStartTime']);
    final selectedEndTime = formatTimeStamp(_initialValue['selectedEndTime']);
    final selectedDate = formatTimeStamp(_initialValue['selectedDate']);
    final meetingStartDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    var meetingEndDate = DateFormat('yyyy-MM-dd').format(selectedEndTime);
    if (meetingEndDate != DateFormat('yyyy-MM-dd').format(selectedStartTime)) meetingEndDate = DateFormat('yyyy-MM-dd').format(selectedDate.add(Duration(days: 1)));
    final startTimeHourSlot = selectedStartTime.hour;
    final endTimeHourSlot = selectedEndTime.hour;
    print('startTime = $startTimeHourSlot endTimeHourSlot = $endTimeHourSlot meetingStartDate= $meetingStartDate meetingEndDate= $meetingEndDate slots=$slots ');
    var k = 0;
    var i = startTimeHourSlot;
    var slotKey = meetingStartDate;
    if (meetingStartDate != meetingEndDate) k = 1;
    while (i <= endTimeHourSlot || k == 1) {
      if (i == 24) {
        i = 0;
        k -= 1;
        slotKey = meetingEndDate;
      }
      slots[slotKey][i.toString()].remove(docId);
      i += 1;
    }
    await updateSlots(slots);
    return slots;
  }

  Map<String, dynamic> createSlot(startTimeMinuteSlot, endTimeMinuteSlot) {
    return {
      'startTimeMinuteSlot': startTimeMinuteSlot,
      'endTimeMinuteSlot': endTimeMinuteSlot,
    };
  }

  void updateClashes() async {
    print('updateClashes ran');
    CollectionReference meetingCollectionReference = db.collection('Users/${_user.uid}/Meetings');
    WriteBatch batch = db.batch();
    final QuerySnapshot meetingCollection = await meetingCollectionReference.get();
    final List<QueryDocumentSnapshot> meetings = meetingCollection.docs;
    meetings.forEach((document) {
      if (document.id == docId)
        batch.update(document.reference, {'Clashes': clashedMeetingId});
      else if (clashedMeetingId.contains(document.id)) {
        final List<dynamic> clashedDataList = document.data()['Clashes'];
        if (!clashedDataList.contains(docId)) {
          clashedDataList.add(docId);
          print('clashedDataList: $clashedDataList');
          batch.update(document.reference, {'Clashes': clashedDataList});
        }
      } else {
        if (update) {
          final List<dynamic> clashedDataList = document.data()['Clashes'];
          clashedDataList.remove(docId);
          print('clashedDataList: $clashedDataList');
          batch.update(document.reference, {'Clashes': clashedDataList});
        }
      }
    });
    await batch.commit().catchError((err) => print('batchCommit error: $err'));
  }

  Future<void> updateSlots(slots) async {
    print('updateSlots ran');
    await db.collection('Users').doc('${_user.uid}').update({
      'Slots': slots,
    }).catchError((err) {
      print('_updateSlots err: $err');
    });
  }
}
