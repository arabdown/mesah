abstract class BookingStyleModel {
  num price;

  BookingStyleModel({
    this.price = 0,
  });

  Future<void> init();

  Future<void> calcPrice();

  Map<String, dynamic> get params;
}
