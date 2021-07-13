import 'package:flutter/material.dart';

class OfflineMeetingSchema with ChangeNotifier {
  final String id;
  final String title;
  final String address;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  OfflineMeetingSchema(
      this.id,
      this.title,
      this.address,
      this.date,
      this.startTime,
      this.endTime,
      );
}
