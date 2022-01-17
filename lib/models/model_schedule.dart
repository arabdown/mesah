import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleModel {
  TimeOfDay start;
  TimeOfDay end;

  ScheduleModel({required this.start, required this.end});

  factory ScheduleModel.fromString(String value) {
    final arr = value.split(" - ");
    return ScheduleModel(
      start: TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(arr[0])),
      end: TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(arr[1])),
    );
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    if (json['start'].toString() == '0') {
      json['start'] = '00:00';
    }
    if (json['end'].toString() == '0') {
      json['end'] = '00:00';
    }

    return ScheduleModel(
      start: TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['start'])),
      end: TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['end'])),
    );
  }
}
