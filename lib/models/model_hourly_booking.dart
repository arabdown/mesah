import 'package:listar_flutter_pro/models/model.dart';

class HourlyBookingModel extends BookingStyleModel {
  int person;
  DateTime startDate;
  ScheduleModel? schedule;
  List<String> hourList = [];

  HourlyBookingModel({
    this.person = 0,
    required this.startDate,
  }) : super();

  @override
  Future<void> calcPrice() async {}

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    hourList = [
      '08:00 - 09:00',
      '09:00 - 10:00',
      '10:00 - 11:00',
      '11:00 - 12:00',
      '12:00 - 13:00',
      '13:00 - 14:00',
      '14:00 - 15:00',
      '15:00 - 16:00',
      '16:00 - 17:00',
      '17:00 - 18:00',
    ];
  }

  @override
  Map<String, dynamic> get params {
    return {};
  }
}
