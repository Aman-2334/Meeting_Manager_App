import 'package:flutter/material.dart';

class OnlineMeetingSchema with ChangeNotifier {
  final String title;
  final String platform;
  final String meetingId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  OnlineMeetingSchema(
    this.title,
    this.platform,
    this.meetingId,
    this.date,
    this.startTime,
    this.endTime,
  );
}
