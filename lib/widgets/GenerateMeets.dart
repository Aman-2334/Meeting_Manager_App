import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenerateMeeting extends StatelessWidget {
  final QueryDocumentSnapshot meetingDocumentReference;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  GenerateMeeting(this.meetingDocumentReference);

  DateTime formatTimeStamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  }

  Future<void> deleteMeeting(meetingDocument,id) async {
    final selectedStartTime = formatTimeStamp(meetingDocument['Meeting Information']['selectedStartTime']);
    final selectedEndTime = formatTimeStamp(meetingDocument['Meeting Information']['selectedEndTime']);
    final selectedDate = formatTimeStamp(meetingDocument['Meeting Information']['selectedDate']);
    await db.collection('Users/${_user.uid}/Meetings').doc('$id').delete();
    final startTimeHourSlot = selectedStartTime.hour;
    final endTimeHourSlot = selectedEndTime.hour;
    final userDocs = await db.collection('Users').doc('${_user.uid}').get();
    final Map<String, dynamic> slots = userDocs.data()['Slots'];
    final meetingStartDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    var meetingEndDate = DateFormat('yyyy-MM-dd').format(selectedEndTime);
    if (meetingEndDate != DateFormat('yyyy-MM-dd').format(selectedStartTime)) meetingEndDate = DateFormat('yyyy-MM-dd').format(selectedDate.add(Duration(days: 1)));
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
      slots[slotKey][i.toString()].remove(id);
      i += 1;
    }
    print('slots: $slots');
    removeClashes(id);
    updateSlots(slots);
  }

  void removeClashes(id) async {
    print('removeClashes ran');
    CollectionReference meetingCollectionReference = db.collection('Users/${_user.uid}/Meetings');
    WriteBatch batch = db.batch();
    final QuerySnapshot meetingCollection = await meetingCollectionReference.get();
    final List<QueryDocumentSnapshot> meetings = meetingCollection.docs;
    meetings.forEach((document) {
      if (document.data()['Clashes'].contains(id)) {
        final List<dynamic> clashedDataList = document.data()['Clashes'];
        clashedDataList.remove(id);
        print('clashedDataList: $clashedDataList');
        batch.update(document.reference, {'Clashes': clashedDataList});
      }
    });
    await batch.commit().catchError((err) => print('batchCommit error: $err'));
  }

  void updateSlots(slots) async {
    print('updateSlots ran');
    await db.collection('Users').doc('${_user.uid}').update({
      'Slots': slots,
    }).catchError((err) {
      print('_updateSlots err: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Meeting generator ran');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.black38,width: 0.3),),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 1,
      child: Container(
        height: 130,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.people),
              ),
              title: Text(meetingDocumentReference['Meeting Information']['title']),
              subtitle: Text(
                '${DateFormat.yMMMEd().format(formatTimeStamp(meetingDocumentReference['Meeting Information']['selectedDate']))} || '
                '${DateFormat("HH:mm").format(formatTimeStamp(meetingDocumentReference['Meeting Information']['selectedStartTime']))} - '
                '${DateFormat("HH:mm").format(formatTimeStamp(meetingDocumentReference['Meeting Information']['selectedEndTime']))}',
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.more_vert_sharp,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                    ),
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 280,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  style: ButtonStyle(alignment: Alignment.topLeft),
                                  icon: Icon(Icons.edit),
                                  label: Text('Edit'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed('/OnlineMeetingSetter', arguments: meetingDocumentReference);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  style: ButtonStyle(alignment: Alignment.topLeft),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.share),
                                  label: Text('Share to...'),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  style: ButtonStyle(alignment: Alignment.topLeft),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.notifications),
                                  label: Text('Notification'),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  style: ButtonStyle(alignment: Alignment.topLeft),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              height: 100,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  SizedBox(
                                                    child: Text(
                                                      'This action is irreversible, Confirm delete.',
                                                      style: TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(),
                                                        child: Text('Cancel'),
                                                      ),
                                                      SizedBox(width: 10),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          deleteMeeting(meetingDocumentReference.data(),meetingDocumentReference.id);
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {},
                  label: Text('${meetingDocumentReference['type'] == 'online' ? 'Join' : 'Book'}'),
                  icon: Icon(meetingDocumentReference['type'] == 'online' ? Icons.call : Icons.search_sharp),
                ),
                if (meetingDocumentReference['Clashes'].isNotEmpty)
                  TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      'Clashed',
                      style: TextStyle(color: Colors.red),
                    ),
                    icon: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                TextButton.icon(
                  onPressed: () {},
                  label: Text('Notes'),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
