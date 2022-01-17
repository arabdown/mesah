import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';

class TableBookingModel extends BookingStyleModel {
  int person;
  DateTime startDate;
  TimeOfDay startTime;
  List<Map<String, dynamic>> tableList = [];
  List<Map<String, dynamic>> selected = [];

  TableBookingModel({
    this.person = 0,
    required this.startDate,
    required this.startTime,
  }) : super();

  @override
  Future<void> calcPrice() async {}

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    tableList = [
      {'id': 0, 'value': true},
      {'id': 1, 'value': true},
      {'id': 2, 'value': false},
      {'id': 3, 'value': true},
      {'id': 4, 'value': false},
      {'id': 5, 'value': false},
      {'id': 6, 'value': false},
      {'id': 7, 'value': false},
      {'id': 8, 'value': true},
      {'id': 9, 'value': false},
      {'id': 10, 'value': true},
      {'id': 11, 'value': true},
      {'id': 12, 'value': false},
      {'id': 13, 'value': true},
      {'id': 14, 'value': false},
      {'id': 15, 'value': true},
      {'id': 16, 'value': true},
      {'id': 17, 'value': false},
      {'id': 18, 'value': false},
      {'id': 19, 'value': true},
      {'id': 20, 'value': false},
    ];
  }

  @override
  Map<String, dynamic> get params {
    return {};
  }
}
