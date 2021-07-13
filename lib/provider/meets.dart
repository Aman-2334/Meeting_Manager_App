import 'package:flutter/material.dart';
import './OnlineMeetingSchema.dart';
import './OfflineMeetingSchema.dart';

class MeetingsProvider with ChangeNotifier {

  List meets = [
    OnlineMeetingSchema('Innovation Team', 'Innovation Team', 'Google meet', DateTime.now(), DateTime.now(), DateTime.now()),
    OfflineMeetingSchema('Design Team', 'Design Team', 'address', DateTime.now(), DateTime.now(), DateTime.now()),
  ];

  void addOnlineMeet(title, platform, meetingId, date, startTime, endTime) {
    meets.add(OnlineMeetingSchema(title, platform, meetingId, date, startTime, endTime));
    notifyListeners();
  }
  void addOfflineMeet(id, title, address, date, startTime, endTime) {
    meets.add(OfflineMeetingSchema(id, title, address, date, startTime, endTime));
    notifyListeners();
  }

  void deleteMeet(id){
    meets.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  List getMeets(){
    return meets;
  }
}
