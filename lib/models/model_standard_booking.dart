import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';

class StandardBookingModel extends BookingStyleModel {
  int person;
  DateTime startDate;
  TimeOfDay startTime;

  StandardBookingModel({
    this.person = 0,
    required this.startDate,
    required this.startTime,
  }) : super();

  @override
  Future<void> calcPrice() async {}

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Map<String, dynamic> get params {
    return {};
  }
}
