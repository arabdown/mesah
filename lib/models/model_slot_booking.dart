import 'package:listar_flutter_pro/models/model.dart';

class SlotBookingModel extends BookingStyleModel {
  int person;

  SlotBookingModel({
    this.person = 0,
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
