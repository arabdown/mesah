class Images {
  static const String intro1 = "assets/images/intro_1.png";
  static const String intro2 = "assets/images/intro_2.png";
  static const String intro3 = "assets/images/intro_3.png";
  static const String logo = "assets/images/logo.png";
  static const String slide = "assets/images/slide.png";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
